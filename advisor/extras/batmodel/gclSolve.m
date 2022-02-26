% gclSolve: A standalone version of glcSolve, independent of TOMLAB
%
% Solves general constrained mixed integer global optimizaion problems.
%
% gclSolve.m implements the algorithm DIRECT by Donald R. Jones presented
% in the paper "DIRECT", Encyclopedia of Optimization, Kluwer Academic
% Publishers 1999.
%
% gclSolve solves problems of the form:
%
% min   f(x)
%  x
% s/t   x_L <=   x  <= x_U
%       b_L <= A x  <= b_U
%       c_L <= c(x) <= c_U
%       x(i) integer, for i in I
%
%
% Calling syntax:
%
% function Result = gclSolve(p_f, p_c, x_L, x_U, A, b_L, b_U,...
%                   c_L, c_U, I, GLOBAL, PriLev, varargin)
%
% INPUT PARAMETERS
%
% p_f      Name of m-file computing the function value.
% p_c      Name of m-file computing the nonlinear constraints.
% x_L      Lower bounds for x
% x_U      Upper bounds for x
% A        Linear constraint matrix.
% b_L      Lower bounds for linear constraints.
% b_U      Upper bounds for linear constraints.
% c_L      Lower bounds for nonlinear constraints.
% c_U      Upper bounds for nonlinear constraints.
% I        Set of integer variables, default I=[].
%
% Note: DIRECT will run until BOTH the MaxEval and MaxIter are satisfied
%		  (and it will always finish the current iteration before exiting).
%		  So if you only want to set one of MaxEval or MaxIter, set the other
%		  to zero.
% GLOBAL.MaxEval      Number of function evaluations to run, default 200.
% GLOBAL.epsilon      Global/local search weight parameter, default 1E-4.
% GLOBAL.MaxIter		 Number of iterations to run, default 1.
%
% If restart is wanted, the following fields in GLOBAL should be defined
% and equal the corresonding fields in the Result structure from the
% previous run: 
%
% GLOBAL.C          Matrix with all rectangle centerpoints.
% GLOBAL.D          Vector with distances from centerpoint to the vertices.
% GLOBAL.F          Vector with function values.
% GLOBAL.Split      Split(i,j) = # splits along dimension i of rectangle j
% GLOBAL.T          T(i) is the number of times rectangle i has been trisected.
% GLOBAL.G          Matrix with constraint values for each point.
% GLOBAL.ignoreidx  Rectangles to be ignored in the rect. selection proceedure.
% GLOBAL.I_L        I_L(i,j) is the lower bound for rect. j in integer dim. I(i)
% GLOBAL.I_U        I_U(i,j) is the upper bound for rect. j in integer dim. I(i)
% GLOBAL.feasible   Flag indicating if a feasible point has been found.
% GLOBAL.f_min      Best function value found at a feasible point.
% GLOBAL.s_0        s_0 is used as s(0)
% GLOBAL.s          s(j) is the sum of observed rates of change for constraint j.
% GLOBAL.t          t(i) is the total # splits along dimension i.
% GLOBAL.TotalIter  total number of iterations run so far.
%
% PriLev            Printing level:
%                   PriLev >= 0   Warnings  
%                   PriLev >  0   Each iteration info  
%
% OUTPUT PARAMETERS
%        
% Result      Structure with results from optimization:
%    x_k       Matrix with optimal points as columns.
%    f_k       Function value at optimum.
%    c_k       Nonlinear constraints values at x_k
%    Iter      Number of iterations.
%    FuncEv    Number of function evaluations.
%    GLOBAL, special structure field (to make restart possible) containing:
%      C          Matrix with all rectangle centerpoints.
%      D          Vector with distances from centerpoint to the vertices.
%      F          Vector with function values.
%      Split      Split(i,j) = # splits along dimension i of rectangle j
%      T          T(i) is the number of times rectangle i has been trisected.
%      G          Matrix with constraint values for each point.
%      ignoreidx  Rectangles to be ignored in the rect. selection proceedure.
%      I_L        I_L(i,j) is the lower bound for rect. j in integer dim. I(i)
%      I_U        I_U(i,j) is the upper bound for rect. j in integer dim. I(i)
%      feasible   Flag indicating if a feasible point has been found.
%      f_min      Best function value found at a feasible point.
%      s_0        s_0 is used as s(0)
%      s          s(j) is the sum of observed rates of change for constraint j.
%      t          t(i) is the total # splits along dimension i.
% 		 TotalIter	total number of iterations run so far.
%		 f_min_hist Structure containing all 'best' points found:
%							f_min:	objective function values
%							x:			Matrix with points where those 'bests' occurred
%							nFuncEv:	the function evaluation number where those 'bests' occurred
%
%
% Kenneth Holmstrom, HKH MatrisAnalys AB, E-mail: hkh@acm.org.
% Copyright (c) 1999 by HKH MatrisAnalys AB, Sweden. $Revision: 1.0 $
% Written Apr 8, 1999.   Last modified Sep 9, 1999.
%

function Result = gclSolve(p_f, p_c, x_L, x_U, A, b_L, b_U,...
                  c_L, c_U, I, GLOBAL, PriLev, varargin)

if nargin < 12;
   PriLev = [];
   if nargin < 11
      GLOBAL = [];
      if nargin < 10
         I = [];
         if nargin < 9
            c_U = [];
            if nargin < 8
               c_L = [];
               if nargin < 7
                  b_U = [];
                  if nargin < 6
                     b_L = [];
                     if nargin < 5
                        A = [];
                        if nargin < 4
                           x_U = [];
                           if nargin < 3
                              x_L = [];
                              if nargin < 2
                                 p_c = [];
                                 if nargin < 1
                                    p_f = [];
                                 end
                              end
                           end
                        end
                     end
                  end
               end
            end
         end
      end
   end
end

if isempty(p_f) | isempty(x_L) | isempty(x_U)
   disp(' p_f, x_L and x_U must be defined')
   return;
end
if isempty(PriLev), PriLev=1;  end

if isempty(GLOBAL)
   MaxEval = 500;    % Number of function evaluations.
   epsilon = 1e-4;   % global/local weight parameter. 
   tol     = 0.01;   % Error tolerance parameter.
   MaxIter = 1;		% Max number of iterations
else
   if isfield(GLOBAL,'MaxEval') % Number of function evaluations
      MaxEval = GLOBAL.MaxEval;
   else
      MaxEval = 500;
   end
   if isfield(GLOBAL,'epsilon') % global/local weight parameter
      epsilon = GLOBAL.epsilon;
   else
      epsilon = 1E-4;
   end
   if isfield(GLOBAL,'tolerance') % Convergence tolerance
      tol = GLOBAL.tolerance;
   else
      tol = 0.01;
   end
   if isfield(GLOBAL,'MaxIter') % Number of function evaluations
      MaxIter = GLOBAL.MaxIter;
   else
      MaxIter = 1;
   end
   if ~isfield(GLOBAL,'MaxEval') & ~isfield(GLOBAL,'MaxIter')	% if neither exist
      MaxEval = 500;
      MaxIter = 1;
   end
end   
DEBUG=0;

x_L = x_L(:);  x_U = x_U(:);
b_L = b_L(:);  b_U = b_U(:);
c_L = c_L(:);  c_U = c_U(:);

cTol = 1E-6;   % Constraint feasibility tolerance

n     = length(x_L);  % Problem dimension
nFunc = 0;            % Function evaluation counter

integers   = ~isempty(I); % integers is true if there are integer variables
I_logic    = zeros(n,1); % Logic set for integer/continuous variables
I_logic(I) = 1;

% Index sets for linear and nonlinear constraints
b_L_idx = find(~isempty(b_L) & isfinite(b_L));
b_U_idx = find(~isempty(b_U) & isfinite(b_U));
c_L_idx = find(~isempty(c_L) & isfinite(c_L));
c_U_idx = find(~isempty(c_U) & isfinite(c_U));

% Check if there is a chance to find a feasible point
if any(x_L > x_U)
   fprintf('\n\n Error in gclSolve, upper variable bounds below lower bounds\n');
   return;
end

%
%  STEP 1, INITIALIZATION
%

if isfield(GLOBAL,'C') & ~isempty(GLOBAL.C)
   % Restart with values from previous run.
   F = GLOBAL.F;
   
   if PriLev > 0
      fprintf('\n Restarting with %d sampled points from previous run\n',size(F,2));
   end
   T   = GLOBAL.T;
   G   = GLOBAL.G;
   D   = GLOBAL.D;
   I_L = GLOBAL.I_L;
   I_U = GLOBAL.I_U;
   s_0 = GLOBAL.s_0;
   s   = GLOBAL.s;
   t   = GLOBAL.t;
   
   PrevIter=GLOBAL.TotalIter;
   ignoreidx = GLOBAL.ignoreidx;
   feasible  = GLOBAL.feasible;
   Split     = GLOBAL.Split;
   f_min     = GLOBAL.f_min;
   f_min_hist = GLOBAL.f_min_hist;
   
   lincon    = ~isempty(A);          % Is there any linear constraints
   nonlincon = ~(isempty(p_c));      % Is there any nonlinear constraints
   con       = lincon + nonlincon;   % Is there any constraints at all
   if con
      % Place all constraints in one vector gx with upper bounds g_U
      g_U = [-b_L(b_L_idx);b_U(b_U_idx);-c_L(c_L_idx);c_U(c_U_idx)];
      m   = length(g_U); % Number of constraints
   end
   
   % Must transform Prob.GLOBAL.C back to unit hypercube
   for i = 1:size(GLOBAL.C,2)
      C(:,i) = ( GLOBAL.C(:,i) - x_L )./(x_U - x_L);
   end
else
   PrevIter=0;	% initialize iteration counter
   % No restart, set first point to center of the unit hypercube.

   % SAMPLE THE CENTERPOINT OF THE ENTIRE SPACE.
   C = ones(n,1)./2;    % Matrix with all rectangle centerpoints.
                        % All C_coordinates refers to the n-dimensional hypercube. 
   Split = zeros(n,1);  % Split(i,j) is the number of times rectangle j
                        % has been split along dimension i. Split(i,j) is set to
                        % inf if rect j has sidelength 0 for integer variable i. 

   % IF ALL VARIABLES ARE INTEGERS, THEN IT IS POSSIBLE FOR A RECTANGLE
   % TO BE REDUCED TO A SINGLE POINT. IF THIS HAPPENS, THE RECTANGLE SHOULD
   % BE IGNORED IN THE RECTANGLE SELECTION PROCEEDURE.
   ignoreidx = []; % See comment above

   % Fixed variables should not be considered for the splitting proceedure
   idx = find(x_L==x_U);
   if length(idx) > 0
      Split(idx,1) = inf; % This will eliminate the risk of choosing this dimensions as
                          % splitting dimensions for any rectangle. 
      if length(idx)==n
         ignoreidx = [ignoreidx 1];
      end
   end

   if integers
      I_L =  ceil(x_L(I)); % I_L(i,j) is the lower bound for rectangle j in integer dimension I(i).
      I_U = floor(x_U(I)); % I_U(i,j) is the upper bound for rectangle j in integer dimension I(i).
      IL = (I_U-I_L);
      if any(IL < 0)
         disp('Error in gclSolve, empty domain for integer variables:')
         tmpidx = find(IL<0);
         I(tmpidx)
         return;
      end
      x_mid  = floor( (I_U+I_L)/2 );
      %x_mid  = floor( (x_U(I)+x_L(I))/2 );
      C(I,1) = (x_mid-x_L(I))./(max(x_U(I)-x_L(I),1E-20));
      tmpidx    = find(IL(:,1)==0);
      Split(I(tmpidx),1) = inf; % This will eliminate the risk of choosing this dimensions as
                             % splitting dimension for any rectangle.
      if length(tmpidx)==n
         ignoreidx = [ignoreidx 1];
      end 
   else
      I_L = [];
      I_U = [];
   end
   x     = x_L + C.*(x_U - x_L);  % Transform C to original search space
   f     = feval(p_f,x, varargin{:});   % Function value at x
   nFunc = nFunc+1;               % Number of function evaluations
   F     = f;                     % Vector with function values
   T = 0;         % T(i) is the number of times rectangle i has been trisected.
   D = sqrt(n)/2; % Vector with distances from centerpoint to the vertices.

   % IF THE CENTER IS FEASIBLE, SET x_min EQUAL TO THE CENTERPOINT AND
   % f_min EQUAL TO THE OBJECTIVE FUNCTION VALUE AT THIS POINT.

   lincon    = ~isempty(A);           % Is there any linear constraints
   nonlincon = ~(isempty(p_c));		  % Is there any nonlinear constraints
   con       = lincon + nonlincon;    % Is there any constraints at all
   if lincon
      Ax = A*x;
   else
      Ax=[];
   end   
   if nonlincon
      cx = feval(p_c,x, varargin{:});
      cx=cx(:);	% format vector to be column
   else
      cx=[];
   end

   if con
      % Place all constraints in one vector gx with upper bounds g_U
      g_U = [-b_L(b_L_idx);b_U(b_U_idx);-c_L(c_L_idx);c_U(c_U_idx)];
      m   = length(g_U); % Number of constraints
      gx  = [-Ax(b_L_idx);Ax(b_U_idx);-cx(c_L_idx);cx(c_U_idx)]; 
      if all( gx < g_U + cTol ) % Initial point is feasible ?
         feasible = 1; % feasible point has been found
      else
         feasible = 0;
      end
      G   = gx-g_U; % Subtract g_U to get g(x)<=0
      % G is a matrix with constraint values for each point.
      % G(i,j) is the value of constraint i at point j.
   else
      G = [];
      feasible = 1;
   end
   if feasible
      f_min_hist.nFuncEv = 1;
      f_min_hist.f_min = f;
      f_min_hist.x(1,:) = x;
      f_min = f;
   else
      f_min = NaN;
   end

   % SET s(j)=0 FOR j=1,2,...,m. SET t(i)=0 FOR i=1,2,...,n.
   if con
      s_0 = 0;          % Used as s(0).
      s   = zeros(m,1); % s(j) is the sum of observed rates of change for constraint j.
   else
      s_0 = [];
      s = [];
   end
   t = zeros(n,1); % t(i) is the number of times a rectangle has been split along dimension i.

end % if restart

BreakFlag = 0; % If max number of func.eval. has been reached set BreakFlag=1,
               % update s_0, s and then break main loop.
Iter = 0; % Iteration counter
while nFunc < MaxEval | (Iter+1) <= MaxIter
%while 1

   Iter = Iter+1;
   
   %
   %  STEP 2, SELECT RECTANGLES 
   %
   
   if length(ignoreidx)==length(F) % If all rects are fathomed
      break
   end
      
   % COMPUTE THE c(j) VALUES USING THE CURRENT VALUES OF s_0 AND s(j), j=1,2,...,m  
   if con
      c = s_0./(max(s,1E-30));
      cGD = (c'*max(G,0))./D;
   else
      cGD = zeros(1,length(F)); % Else computed in each iteration
   end
   
   S = []; % The set of rectangles selected for trisection
   
   % IF A FEASIBLE TRIANGLE HAS NOT BEEN FOUND, SELECT THE RECTANGLE THAT
   % MINIMIZES THE RATE OF CHANGE REQUIRED TO BRING THE WEIGHTED CONSTRAINT
   % VIOLATIONS TO ZERO.
   if ~feasible
      [a b] = min( cGD );
      % How to treat the integer variables????
      if ~isempty(ignoreidx)
         cGDtmp = cGD;
         while ismember(b,ignoreidx) % rectangle b is fathomed i.e. b is a single point and can't be split
            cGDtmp(b) = inf;
            [a b] = min( cGDtmp );
            if ~isfinite(a)
               disp(' No feasible integer point exist')
               S = [];
               break;
            end
         end
         S = b;
      else
         S = b;
      end   
   else
      % ON THE OTHER HAND, IF A FEASIBLE POINT HAS BEEN FOUND, IDENTIFY THE
      % SET OF RECTANGLES THAT PARTICIPATE IN THE LOWER ENVELOPE. LET S BE
      % THE SET OF SELECTED RECTANGLES.
      Epsilon = max(epsilon*abs(f_min),1E-8);
      
      f_star = f_min-Epsilon;
      r_previous=inf;
      idx1=[];
      while 1
         f_star_max = -inf;
         h      = max((F-f_star),0)./D + cGD;
         % tmpidx = setdiff([1:length(F)],idx1);    THE ROWS BELOW IS MUCH FASTER !!!
         tmpset1=ones(1,length(F));
         tmpset1(idx1)      = 0; % do not consider rects put in S in previous turn
         tmpset1(ignoreidx) = 0; % do not consider rects being fathomed
         tmpidx=find(tmpset1);
         
         h_min  = min(h(tmpidx));
      %   idx1   = find(h==h_min);
         idxurk   = find(h(tmpidx)==h_min);
         idx1     = tmpidx(idxurk);
% idx1   = intersect(idx1,tmpidx);
         
         if length(idx1) > 1
            if any(f_star > F(idx1))
               % Choose the rectangle being constant for the lowest value of f_star
               [a b] = max(f_star-F(idx1));
               r = idx1(b);
            else
               % Choose the rectangle with the flatest slope.
               [a b] = max(D(idx1));
               r = idx1(b);
            end
         else
            r = idx1;
         end
         S = [S setdiff(idx1,S)];
         
   
         if f_star > F(r) % We must move horisontally to the left
            f_star = F(r);
         end
         
         % Compute the intersection of the line y(x) = slope*x + const,
         % with all curves not in [idx;r_previous]
         slope = -1/D(r);
         const = h(r)-slope*f_star;
         
         % Trying to speed up the search for f_star_max by just checking the relevant rectangles
         idxspeed = find( (cGD<cGD(r)) | (D>D(r)) );
         % idxspeed = setdiff(idxspeed,[idx1 r_previous]);  %  THE ROWS BELOW IS MUCH FASTER !!!
         if isfinite(r_previous)
            tmpset2=ones(1,length(idxspeed)); tmpset2([idx1 r_previous])=0; idxspeed=find(tmpset2);
         else
            tmpset2=ones(1,length(idxspeed)); tmpset2(idx1)=0; idxspeed=find(tmpset2);
         end
         
         for dummy=1:length(idxspeed)
            i = idxspeed(dummy);
            % First assume that h(i) is constant i.e. max(F(i)-tmp1,0)=0
            tmp1 = (cGD(i)-const)/slope; % same as tmp1=-D(r)*( cGD(i)-const );
            if (tmp1 < f_star) & (tmp1 >= F(i) )
               % intersection between y(x) and h(i) where h(i) is constant.
               if tmp1 > f_star_max
                  f_star_max = tmp1;
               end
            else % Maybe this should be an end statement !!!!!!!!
               % Now assume that h(i) is not constant i.e. max(F(i)-tmp2,0)=F(i)-tmp2
               slope_hat = -1/D(i);
               if slope_hat > slope % Else, intersection will not occur or occur for values >= f_star
                  %const_hat = (F(i)-tmp1)/D(i) + cGD(i) - slope_hat*f_star;
                  const_hat = cGD(i) - slope_hat*F(i);
                  tmp2 = (const_hat-const)/(slope-slope_hat);
                  if tmp2 < f_star
                     if tmp2 > f_star_max
                        f_star_max = tmp2;
                     end
                  end
               end
            end
         end % dummy=1:length(idxspeed)   
         
         if ~isfinite(f_star_max) % if curve r is never intersected with another one
            break;
         else
            f_star = f_star_max;
            r_previous = r;
         end
         % DO NOT DOUBLE-COUNT ANY RECTANGLE !!!!!!   
      end % while 1  
   end % if ~feasible
   
   
   %
   %  STEP 3, CHOOSE ANY RECTANGLE IN S. 
   %
   
   if DEBUG      
      DDDD=find(all(Split==inf));
      Disaster=intersect(S,DDDD);
      if length(Disaster>0)
         Disaster
         S
         ignoreidx
         pause
      end
   end
   
   for dummy=1:length(S) % for each rectangle in S
      r = S(dummy);
      
      %
      %  STEP 4, TRISECT AND SAMPLE RECTANGLE r
      %
   
      % CHOOSE A SPLITTING DIMENSION BY IDENTIFYING THE SET OF LONG SIDES OF
      % RECTANGLE r AND THEN CHOOSING THE LONG SIDE WITH THE SMALLEST t(i) VALUE.
      % IF MORE THAN ONE SIDE IS TIED FOR THE SMALLEST t(i) VALUE, CHOOSE THE ONE
      % WITH THE LOWEST DIMENSIONAL INDEX.
      idx2 = find(Split(:,r)==min(Split(:,r)));
      if length(idx2) > 1
         idx3 = find(t(idx2)==min(t(idx2)));
         i = idx2(idx3(1));
      else
         i = idx2;
      end
      
      if DEBUG %I_L(i,r)==I_U(i,r)
         fprintf('\n\n Error in gclSolve, I_L(i,r)==I_U(i,r) !!!!!! \n');
         r
         i
         Split(:,r)
         C(:,r)
         pause
      end

      
      % Updates
      t(i) = t(i)+1;
      T(r) = T(r)+1;
      
      % Update D(r)
      j = mod(T(r),n);
      k = (T(r)-j)/n;
      D(r) = (3^(-k))/2*sqrt(j/9+n-j);
      
      e_i    = [zeros(i-1,1);1;zeros(n-i,1)];
      Split(i,r) = Split(i,r)+1;
      
      rightchild = 1; % flag if there will be a right/left child or not,
      leftchild  = 1; % used when splitting along an integer dimension.
      
      % ******* LEFT NEW POINT ********
      Split_left = Split(:,r);
      if integers
         I_L_left = I_L(:,r);
         I_U_left = I_U(:,r);
      end   
      if I_logic(i) % We shall split along an integer dimension
         I_i   = find(I==i);
         aa = I_L(I_i,r);
         bb = I_U(I_i,r);
         delta = floor( (bb-aa+1)/3 );
         c_left = C(:,r);
         if delta >= 1
            I_L_left(I_i) = aa;
            I_U_left(I_i) = aa+delta-1;
            I_L(I_i,r) = aa + delta;
            I_U(I_i,r) = bb - delta;
         elseif delta == 0 % Now there will be only 1 child. Left or right?
            %parent_center = (c_left(i)-x_L(i))./(max(x_U(i)-x_L(i),1E-20));
            parent_center = x_L(i) + c_left(i)*(x_U(i) - x_L(i));
            if abs(aa-parent_center) < 1E-4 % if aa==parent_center
               leftchild  = 0;
               rightchild = 0;
               I_L_left(I_i) = bb;
               I_U_left(I_i) = bb;
               I_L(I_i,r) = aa;
               I_U(I_i,r) = aa;
            else
               rightchild=0;
               I_L_left(I_i) = aa;
               I_U_left(I_i) = aa;
               I_L(I_i,r) = bb;
               I_U(I_i,r) = bb;
            end
         else
            rightchild = 0;
            disp('Error in gclSolve, this should not happen');
            return;
         end
         x_i_mid = floor((I_U_left(I_i)+I_L_left(I_i))/2);
         c_left(i) = (x_i_mid-x_L(i))./(max(x_U(i)-x_L(i),1E-20));
         if I_L_left(I_i)==I_U_left(I_i)
            Split_left(i) = inf;
         end
         if I_L(I_i,r)==I_U(I_i,r)
            Split(i,r) = inf;
         end
%         if length(I)==n
            if all(~isfinite(Split(:,r)))
               ignoreidx = [ignoreidx r];
            end
            if all(~isfinite(Split_left))
               ignoreidx = [ignoreidx length(F)+1];
            end
%         end
      else
         delta  = 3^(-Split(i,r));
         c_left = C(:,r) - delta*e_i;       % Centerpoint for new left rectangle
      end
      
      if DEBUG & C(i,r)==c_left(i)
        fprintf('\n\n Error in gclSolve, C(i,r)==c_left(i) !!!!!! \n');
        i   
        delta   
        Iter       
        C(:,r)
        c_left
        pause
      end

      x_left = x_L + c_left.*(x_U - x_L);  % Transform c_left to original search space
      f_left = feval(p_f,x_left, varargin{:});   % Function value at x_left
      nFunc  = nFunc+1;
      if con
         if lincon
            Ax_left = A*x_left;
         else
            Ax_left = [];
         end   
         if nonlincon
            cx_left = feval(p_c,x_left, varargin{:});
            cx_left=cx_left(:);	%format vector to be column
         else
            cx_left = [];
         end
         gx_left    = [-Ax_left(b_L_idx);Ax_left(b_U_idx);-cx_left(c_L_idx);cx_left(c_U_idx)]; 
         if all( gx_left < g_U + cTol ) % New point feasible ?
            if ~feasible
               f_min = f_left; % first feasible point
               feasible = 1;
               f_min_hist.nFuncEv = (length(F)+1);
      			f_min_hist.f_min = f_min;
      			f_min_hist.x = x_left(:)';
            else
               if f_left < f_min % Update f_min
                  f_min = f_left;
                  f_min_hist.nFuncEv = [f_min_hist.nFuncEv; (length(F)+1)];
      				f_min_hist.f_min = [f_min_hist.f_min ;f_min];
      				f_min_hist.x = [f_min_hist.x; x_left(:)'];
               end
            end
         end
         G = [G [gx_left-g_U]]; % Subtract g_U to get g(x)<=0
      else
         if f_left < f_min % Update f_min
            f_min = f_left;
            f_min_hist.nFuncEv = [f_min_hist.nFuncEv ;(length(F)+1)];
      		f_min_hist.f_min = [f_min_hist.f_min; f_min];
      		f_min_hist.x = [f_min_hist.x ;x_left(:)'];
         end      
      end
      C     = [C c_left];
      F     = [F f_left];
      Split = [Split Split_left];
      T     = [T T(r)];
      D     = [D D(r)];
      if integers
         I_L = [I_L I_L_left];
         I_U = [I_U I_U_left];
      end
      
      if ~feasible, f_minn=inf; else f_minn=f_min; end
      %if ~isempty(Prob.f_opt)
      %   if 100*(f_minn-Prob.f_opt)/abs(Prob.f_opt) < tol
      %      if 1%PriLev >= 2
      %         fprintf('\n Number of function evaluations:  %d',nFunc);
      %         fprintf('\n Number of iterations:  %d',Iter);
      %      end
      %      break;
      %   end
      %end    
      
      if rightchild
         % ******* RIGHT NEW POINT ********
         Split_right = Split(:,r);
         if integers
            I_L_right = I_L(:,r);
            I_U_right = I_U(:,r);
         end   
         if I_logic(i) % We shall split along an integer dimension
            c_right = C(:,r);
            I_L_right(I_i) = bb-delta+1;
            I_U_right(I_i) = bb;
            
            x_i_mid = floor((I_U_right(I_i)+I_L_right(I_i))/2);
            c_right(i) = (x_i_mid-x_L(i))./(max(x_U(i)-x_L(i),1E-20));
            if I_L_left(I_i)==I_U_left(I_i)
               Split_right(i) = inf;
            end
%            if length(I)==n
               if all(~isfinite(Split_right))
                  ignoreidx = [ignoreidx length(F)+1];
               end
%            end
         else
            c_right = C(:,r) + delta*e_i;       % Centerpoint for new right rectangle
         end
         x_right = x_L + c_right.*(x_U - x_L);  % Transform c_right to original search space
         f_right = feval(p_f,x_right, varargin{:}); % Function value at x_right
         nFunc  = nFunc+1;
         if con
            if lincon
               Ax_right = A*x_right;
            else
               Ax_right = [];
            end
            if nonlincon
               cx_right = feval(p_c,x_right, varargin{:});
               cx_right = cx_right(:);	%format vector to be column
            else
               cx_right = [];
            end
            gx_right    = [-Ax_right(b_L_idx);Ax_right(b_U_idx);-cx_right(c_L_idx);cx_right(c_U_idx)]; 
            if all( gx_right < g_U + cTol ) % New point feasible ?
               if ~feasible
                  f_min = f_right; % first feasible point
                  feasible = 1;
                  f_min_hist.nFuncEv = (length(F)+1);
      				f_min_hist.f_min = f_min;
      				f_min_hist.x = x_right(:)';
               else
                  if f_right < f_min % Update f_min
                     f_min = f_right;
                     f_min_hist.nFuncEv = [f_min_hist.nFuncEv ;(length(F)+1)];
      					f_min_hist.f_min = [f_min_hist.f_min; f_min] ;
      					f_min_hist.x = [f_min_hist.x ;x_right(:)'];
                  end
               end
            end
            G = [G [gx_right-g_U]]; % Subtract g_U to get g(x)<=0
         else
            if f_right < f_min % Update f_min and x_min
               f_min = f_right;
               f_min_hist.nFuncEv = [f_min_hist.nFuncEv ;(length(F)+1)];
      			f_min_hist.f_min = [f_min_hist.f_min; f_min] ;
      			f_min_hist.x = [f_min_hist.x; x_right(:)'];
            end
         end   
         C     = [C c_right];
         F     = [F f_right];
         Split = [Split Split_right];
         T     = [T T(r)];
         D     = [D D(r)];
         if integers
            I_L = [I_L I_L_right];
            I_U = [I_U I_U_right];
         end
         
         if ~feasible, f_minn=inf; else f_minn=f_min; end
         %if ~isempty(Prob.f_opt)
         %   if 100*(f_minn-Prob.f_opt)/abs(Prob.f_opt) < tol
         %      if 1%PriLev >= 2
         %         fprintf('\n Number of function evaluations:  %d',nFunc);
         %         fprintf('\n Number of iterations:  %d',Iter);
         %      end
         %      break;
         %   end
         %end
      
      end % if rightchild
   
      if con
         % UPDATE THE s(j):s
         x_mid = x_L + C(:,r).*(x_U - x_L);  % Transform C(:,r) to original search space
         norm_left  = norm(x_left-x_mid);
         if rightchild
            norm_right = norm(x_right-x_mid);
            s_0 = s_0 + abs(f_left-F(r))/norm_left    + abs(f_right-F(r))/norm_right;
            s   = s   + abs(gx_left-G(:,r))/norm_left + abs(gx_right-G(:,r))/norm_right;
         else
            s_0 = s_0 + abs(f_left-F(r))/norm_left;
            s   = s   + abs(gx_left-G(:,r))/norm_left;
         end
      end
      
      if BreakFlag; % Max number of function evaluations has been reached
         break;
      end
      
   end % for each rectangle in S
   
   %
   %  STEP 5, UPDATE S (this step is handled by the for loop)
   %
   
   %
   %  STEP 6, ITERATE (this step is handled by the for loop)
   %
   
   if isempty(S) % If no feasible integer solution exist
      break;
   else
   	if PriLev > 0   
      	fprintf('\n Iterations this run: %d      Func. Evals this run: %d      f_min:%20.10f',Iter,nFunc,f_minn);
   	end
   end
   
end % while 1  (main loop)

fprintf('\n -------------------------------------------------------')
fprintf('\n Total Iterations: %d	 	Total Func. Evals: %d', PrevIter + Iter, length(F))

fprintf('\n\n');


% SAVE RESULTS
Result.Solver = 'gclSolve';
Result.SolverAlgorithm = 'DIRECT by Don Jones';

if feasible
   Result.f_k  = f_min;    % Best function value
else
   Result.f_k  = inf;      % No feasible point found
end
Result.Iter = Iter;     % Number of iterations

CC = [];
for i = 1:length(F) % Transform to original coordinates
   CC = [CC x_L+C(:,i).*(x_U-x_L)];
end

% For restart
Result.GLOBAL.C         = CC;   % All sampled points in original coordinates
Result.GLOBAL.F         = F;    % All function values computed
Result.GLOBAL.D         = D;    % All distances
Result.GLOBAL.Split     = Split;
Result.GLOBAL.T         = T;
Result.GLOBAL.G         = G;
Result.GLOBAL.ignoreidx = ignoreidx;
Result.GLOBAL.I_L       = I_L;
Result.GLOBAL.I_U       = I_U;
Result.GLOBAL.feasible  = feasible;
Result.GLOBAL.f_min     = f_min;
Result.GLOBAL.s_0       = s_0;
Result.GLOBAL.s         = s;
Result.GLOBAL.t         = t;
Result.GLOBAL.TotalIter = PrevIter + Iter;
Result.GLOBAL.f_min_hist = f_min_hist;

% Find all points i with F(i)=f_min
if feasible
   idx = find(F==f_min);
   if con % If there are constraints, pick out the feasible points in idx.
      idx2 = [];
      for i=1:length(idx)
         if all(G(:,idx(i)) < cTol ) % if feasible
            idx2 = [idx2 idx(i)];
         end
      end
   else
      idx2=idx;
   end
   Result.x_k = CC(:,idx2);    % All points i with F(i)=f_min
else
   idx2=[];
end

if nonlincon
   c_k=[];
   for i=1:length(idx2)
      Result.x_k(:,i)
      feval(p_f,Result.x_k(:,i),varargin{:});
      c_k_temp = feval(p_c,Result.x_k(:,i),varargin{:});
   	c_k_temp = c_k_temp(:);	%format vector to be column
      c_k = [c_k  c_k_temp];
   end
   c_k
   Result.c_k = c_k; % Constraint value at x_k;
end
%keyboard
Result.FuncEv=nFunc;


% MODIFICATION LOG:
%
% 001215	 jww  made so that constraint vector does not have to be column
% 001213  jww  added best point history, 'f_min_hist'
% 001129  jww  added iteration counter
% 001121  jww  implemented changes to stop after certain # of iterations, never stop in middle of iteration.
% 990408  mbk  First standalone version of glcSolve.
% 990416  mbk  Output if PriLev > 0.
% 990416  mbk  Small changes in comments.
% 010316  vhj  comment out the keyboard statement
