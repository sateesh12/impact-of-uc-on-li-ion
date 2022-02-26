function cyc = CycleAudit(varargin)
% CYCLE AUDIT CONSTRUCTOR
% cyc = CycleAudit(t, v, h, name) % input time (s), velocity (m/s), elevation (m), and cycle name
% cyc = CycleAudit(t, v, h) % input time (s), velocity (m/s), and elevation (m)
% cyc = CycleAudit(t, v, name) % input time (s), and velocity (m/s)--elevation is assumed as constant 0 m, name given
% cyc = CycleAudit(t, v) % input time (s), and velocity (m/s)--elevation is assumed as constant 0 m, default name assumed
% cyc = CycleAudit(v, name) % input speed at an assumed 1 HZ sampling frequency which determines t--elevation assumed zero, name given
% cyc = CycleAudit(v) % input speed at an assumed 1 HZ sampling frequency which determines t--elevation assumed zero, default name
% cyc = CycleAudit(ADVISOR_CYC_NAME) % give a character string for an ADVISOR CYC_*.m file to load
% cyc = CycleAudit % default constructor
%
% e.g.,
% cyc = CycleAudit('CYC_CSHVR') % loads the CSHVR Drive Cycle info

if nargin==0
    % cyc = CycleAudit % default constructor
    
    t = [0; 10; 28.5; 33; 40];
    v = [0; 8.94; 8.94; 0; 0];
    h = [0; 1;    2;    1; 0];
    name='Untitled';
    cyc = CycleAudit(t,v,h,name);
    
elseif nargin==1
    % cyc = CycleAudit(v) % input speed at an assumed 1 HZ sampling frequency which determines t--elevation assumed zero, default name
    % cyc = CycleAudit(ADVISOR_CYC_NAME) % give a character string for an ADVISOR CYC_*.m file to load
    
    % if the user is specifying the velocity only assuming 1 hz sampling...
    if isa(varargin{1},'double')
        t = linspace(0,length(varargin{1})-1,length(varargin{1}));
        v = varargin{1};
        h = zeros(size(varargin{1}));
        name = 'Untitled';
        cyc = CycleAudit(t,v,h,name);
        % otherwise, if the user is specifying the name of an ADVISOR file...
    elseif isa(varargin{1},'char')
        try
            eval(varargin{1}); % execute the script file
            t = cyc_mph(:,1);
            v = cyc_mph(:,2).*0.44704; % convert from mph to m/s
            name=cyc_description; % get the name from the advisor file
            vAvg=conv(v,[0.5 0.5]);
            vAvg=vAvg(2:end-1); % shave off the edges which don't mean anything
            d = vAvg.*diff(t); % distance in meters
            dcum = [0; cumsum(d)]; % get the cumulative sum of distance traveled
            dcumLimited = dcum;
            dcumLimited(find(dcum<min(cyc_grade(:,1))))=min(cyc_grade(:,1)); % extrap with nearest
            dcumLimited(find(dcum>max(cyc_grade(:,1))))=max(cyc_grade(:,1)); % extrap with nearest
            gradeAvg=conv(interp1(cyc_grade(:,1), cyc_grade(:,2), dcumLimited, 'linear'),[0.5 0.5]);
            gradeAvg=gradeAvg(2:end-1); % cut the ends which don't have meaning
            h = [0; cumsum(d.*gradeAvg)]; % get the height at each time referenced from start height
            cyc=CycleAudit(t,v,h,name);
        catch
            disp('error')
            keyboard
        end
    else
        error(['[',mfilename,'] Error! Invalid data type for one-argument constructor: must be DOUBLE or CHAR'])
    end
    
elseif nargin==2
    % cyc = CycleAudit(t, v) % input time (s), and velocity (m/s)--elevation is assumed as constant 0 m, default name assumed
    % cyc = CycleAudit(v, name) % input speed at an assumed 1 HZ sampling frequency which determines t--elevation assumed zero, name given
    
    if isa(varargin{1},'double')&isa(varargin{2},'double')
        t = varargin{1};
        v = varargin{2};
        h = zeros(size(varargin{1}));
        name='Untitled';
        cyc = CycleAudit(t,v,h,name);
    elseif isa(varargin{1},'double')&isa(varargin{2},'char')
        t = linspace(0,length(varargin{1})-1,length(varargin{1}));
        v = varargin{1};
        h = zeros(size(varargin{1}));
        name = varargin{2};
        cyc = CycleAudit(t,v,h,name);
    else
        error(['[',mfilename,'] Error! Invalid data type for two-argument constructor: must be DOUBLE,DOUBLE or DOUBLE,CHAR'])
    end    
    
elseif nargin==3
    % cyc = CycleAudit(t, v, h) % input time (s), velocity (m/s), and elevation (m)
    % cyc = CycleAudit(t, v, name) % input time (s), and velocity (m/s)--elevation is assumed as constant 0 m, name given
    
    if isa(varargin{1},'double')&isa(varargin{2},'double')&isa(varargin{3},'double')
        t = varargin{1};
        v = varargin{2};
        h = varargin{3};
        name = 'Untitled';
        cyc = CycleAudit(t,v,h,name);
    elseif isa(varargin{1},'double')&isa(varargin{2},'double')&isa(varargin{3},'char')
        t = varargin{1};
        v = varargin{2};
        h = zeros(size(varargin{1}));
        name = varargin{3};
        cyc = CycleAudit(t,v,h,name);
    else
        error(['[',mfilename,'] Error! Invalid data type for three-argument constructor: must be DOUBLE,DOUBLE,DOUBLE or DOUBLE,DOUBLE,CHAR'])
    end 
    
elseif nargin==4
    % cyc = CycleAudit(t, v, h, name) % input time (s), velocity (m/s), elevation (m), and cycle name
    if isa(varargin{1},'double')&isa(varargin{2},'double')&isa(varargin{3},'double')&isa(varargin{4},'char')
        if (length(varargin{1})==length(varargin{2}))&(length(varargin{2})==length(varargin{3}))
            cyc.t = varargin{1}; % time (s)
            cyc.t = cyc.t(:);
            cyc.v = varargin{2}; % velocity (m/s)
            cyc.v = cyc.v(:);
            cyc.h = varargin{3}; % height (aka. elevation) (m)
            cyc.h = cyc.h(:);
            cyc.name=varargin{4}; % the name of the cycle
            
            cyc = class(cyc, 'CycleAudit');
        else
            error(['[',mfilename,'] Error! Length of t, v, and h must be the same!'])
        end
    else
        error(['[',mfilename,'] Error! Invalid data type for four-argument constructor: must be DOUBLE,DOUBLE,DOUBLE,CHAR'])
    end
end