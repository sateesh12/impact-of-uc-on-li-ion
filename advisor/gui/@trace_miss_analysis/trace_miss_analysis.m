function tm = trace_miss_analysis(varargin)
% TRACE MISS ANALYSIS Class
% constructor
% author: Michael O'Keefe, michael_okeefe@nrel.gov
%
% INPUT trace_miss_analysis(time_values, requested_speed, achieved_speed)
% constructor takes three arrays of equal size (i.e., same length+direction):
% 1. time sampled for data (sec)
% 2. requested speed vs. time trace (mph)
% 3. achieved speed vs. time trace (mph)
% 
% RETURNS object of trace_miss_analysis class
%
% e.g., tma = trace_miss_analysis([0 1 2 3], [0 1 4 6], [0 1 2 3.5]); % returns an object of type 'trace_miss_analysis'
%
% Public Class Methods: (in the text below, 'tma' represents any instantiated trace_miss_analysis object
% --- Note: more detailed help is available by typing 'help' followed by the method's name
%
% abs_ave_diff( tma ); % returns the absolute average difference between speed requested and achieved
% abs_ave_diff_txt( tma ); % returns a string value of the results from above function (more easily read)
% display( tma ); % this is the function called whenver you print a tma object without the semicolon--prints to workspace
% get_achieved_speed( tma ); % returns a single column array of achieved speeds (allows access to private data)
% get_del_time( tma ); % returns an array of "delta times"--e.g., del_time(1) corresponds to the amount of time 
%                      % represented by data point one
% get_requested_speed( tma ); % returns a single column array of requested speeds
% get_time( tma ); % returns a single column array of the elapsed times corresponding to the speed data points
% gr_dev( tma ); % returns the (absolute value) of the greatest deviation in cycle as well as the elapsed time at that point
%                % and the time index into the time array for the elapsed time. If more than one point are numerically 
%                % equal in terms of deviation, the point with the lower value of time will be returned
% gr_dev_txt( tma ); % returns a string value of the above function which is easier to read
% gr_per_dev( tma ); % returns the greatest percent deviation based on the cycle's maximum requested speed, the time of occurance
%                    % and the index into the time array for that occurance
% gr_per_dev_txt( tma ); % returns string value of the above
% gr_per_dev_local( tma ); % returns 1) the greatest percent deviation based on the cycle's local requested speed, 2) the time of 
%                          % occurance, and 3) the index into the time array giving time of occurance
% gr_per_dev_local_txt(tma); % returns string value of the above
% per_gr_2mph( tma ); % returns the percent of cycle time that trace is missing by greater than 2 mph
% per_gr_2mph_txt( tma ); % returns string value of the above
% plot( tma ); % generates a figure customized to depict the above statistics
% 


% make sure that all arrays are vertical
switch nargin
case 0 % no input arguments
    tm.time = [0 1 2 3]';
    tm.spd_req = [10 11 12 13]';
    tm.spd_act = [5  6  7  8 ]';
    tm = class(tm, 'trace_miss_analysis');
case 1
    inp1 = varargin{1};
    if isa(inp1, 'trace_miss_analysis')
        tm = inp1;
    end
case 3
    time = varargin{1};
    requestedSpeed = varargin{2};
    actualSpeed = varargin{3};
    
    [rowt, colt] = size(time);
    [rowsr,colsr]= size(requestedSpeed);
    [rowsa,colsa]= size(actualSpeed);
    if(rowt<colt)
       time = time';
   end
   if(rowsr<colsr)
       requestedSpeed = requestedSpeed';
   end
   if(rowsa<colsa)
       actualSpeed = actualSpeed';
   end
   
   if( max(size(time)) ~= max(size(requestedSpeed)) | max(size(time)) ~= max(size(actualSpeed)) )
       disp('Warning! Array''s are not of same size in Trace Miss Analysis');
       error('Arrays not of same size');
   end
   
   tm.time = time;
   tm.spd_req = requestedSpeed;
   tm.spd_act = actualSpeed;
   tm = class(tm, 'trace_miss_analysis');
otherwise
    error('Incorrect number of inputs');
end

