function cyc2 = cycSplice(cyc, varargin)
% cycle splice
% puts together two or more cycle objects or ADVISOR CYC_*.m files for analysis
% the end point of one cycle and start point of the next cycle will be made the same.
% If the points are physically different an average will be taken.
%
% cyc = cycSplice(cycArray, name) where cycArray is an array of CycleAudit objects
% cyc = cycSplice(cyc, cellArray, name) where cellArray is an cell array of char types of ADVISOR CYC_*.m names
if nargin==1
    name='Untitled';
    cyc2=cycSplice(cyc,name);
elseif nargin==2
    name=varargin{1};
    if isa(cyc,'CycleAudit')
        t=cyc(1).t;
        v=cyc(1).v;
        h=cyc(1).h;
        
        for i=2:length(cyc)
            t=[t; cyc(i).t(2:end)+t(end)];
            v=[v(1:end-1); mean([v(end);cyc(i).v(1)]); cyc(i).v(2:end)];
            h=[h; cyc(i).h(2:end)+h(end)-cyc(i).h(1)];
        end
    end
    cyc2 = CycleAudit(t,v,h,name);
    return
elseif nargin==3
    cellArray=varargin{1};
    name = varargin{2};
    if isa(cellArray,'cell')
        for i=1:length(cellArray)
            % if the cell array contains a char string of an m-file on matlab's path...
            if (isa(cellArray{i},'char'))&(exist(cellArray{i})==2)
                c(i)=CycleAudit(cellArray{i}); % ... then load up a CycleAudit object
            else
                error(['[',mfilename,'] Error! Cell does not contain string of m-file on matlab path'])
            end
        end
    else
        error(['[',mfilename,'] Error! Second argument must be a cell array of char in three argument overload option'])
    end
    c=c(:);
    c = [cyc;c];
    cyc2 = cycSplice(c,name);
else
    error(['[',mfilename,'] Only 1, 2, and 3 argument overload options defined for this method'])
end    