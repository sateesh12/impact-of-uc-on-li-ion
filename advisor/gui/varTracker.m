function varTracker(fname,vars,enable,headRowOn)
% function varTracker(fname,vars,enable,headRowOn)
% fname is a char string with the name of the file to use, vars is a cell array of strings of variable names on workspace,
% and enable is an optional flag that turns the variable tracking on and off
% headRowOn is also optional and is a flag to turn logging of the header row on/off
% -this function opens the fname in append mode and does the following:
% -drops all tracked variable names down with time as the first variable in a row as a comma separated variable list
% -drops a time step and then values of variables down as strings in a comma separated variable list (matrices are averaged)
% -closes the file
%
% if enable = 2 or greater, then, don't actually print variable values--this is so just the header can be printed
% if enable == 1, this is the default enable functionality
if exist('enable')~=1
    enable=1; % by default, enable the logging
end

if exist('headRowOn')~=1
    headRowOn=1; % by default, print the header row always 
end

if enable
    % open the file
    try
        fid = fopen(fname,'a');
    catch
        warning('file cannot be opened--returning')
        return
    end
    
    if headRowOn
        fprintf(fid,'\n');
        fprintf(fid,'timeStamp, '); 
        for i=1:length(vars)
            fprintf(fid,'%s, ',vars{i});
        end
    end
    
    if enable<2 % if enable = 2 or greater, then, don't actually print variable values--this is so just the header can be printed
        fprintf(fid,'\n');
        fprintf(fid, ['%s, '],datestr(clock,0));
        for i=1:length(vars)
            if evalin('base',['exist(''',vars{i},''')==1;'])
                val = evalin('base',vars{i});
                if isa(val,'double')
                    if max(size(val))>1 % make into a scalar
                        dims=length(find(size(val)>1));
                        for cnt=1:dims
                            val=mean(val);
                        end
                    end
                    fprintf(fid,'%-32.16f, ',val);
                elseif isa(val,'char')
                    fprintf(fid,'%s, ',val);
                else
                    fprintf(fid,'%s, ','UnknownType');
                end
            else
                fprintf(fid,'%s, ','NotAvailableOnWS');
            end
        end
    end
    fclose(fid);
end

return