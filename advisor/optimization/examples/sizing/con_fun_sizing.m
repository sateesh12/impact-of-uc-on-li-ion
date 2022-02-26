function [con, con_e]=con_fun(x,varargin)

con=evalin('base','con');

offset=length(con);

% run acceleration test
input.accel.param={'spds'};
input.accel.value={[0 60; 40 60; 0 85]};
[error, resp]=adv_no_gui('accel_test',input);
if ~error&~isempty(resp.accel.times)
   con(offset+1,1)=resp.accel.times(1);
   con(offset+2,1)=resp.accel.times(2);
   con(offset+3,1)=resp.accel.times(3);
else
   con(offset+1:offset+3,1)=100;
end

% run grade test
input.grade.param={'duration','ess_init_soc','ess_min_soc','disable_systems','add_mass'};
input.grade.value={1200,0.6,0.4,0,272};
[error, resp]=adv_no_gui('grade_test',input);
if ~error&~isempty(resp.grade.grade)
   con(offset+4,1)=resp.grade.grade;
else
   con(offset+4,1)=0;
end

% matlab only
if length(varargin)>3
    for i=1:length(con)
        if varargin{4}(i)>-1e29
            con(i)=varargin{4}(i)-con(i);
        elseif varargin{5}(i)<1e29
            con(i)=con(i)-varargin{5}(i);
        end
    end
end
con_e=0;
% ****

return
