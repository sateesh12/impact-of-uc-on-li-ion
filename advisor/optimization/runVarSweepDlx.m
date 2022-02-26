function runVarSweepDlx(angInput, varAng, varNames, varValues, saveFile, varTrack, evalString, evalStringInit)
% this function uses adv_no_gui.m and varTracker.m to run and save parametric sweep results
% runVarSweep(angInput, varAng, varNames, varValues, saveFile, varTrack, evalString, evalStringInit)
%
% INPUT ARGUMENTS:
% 1. angInput [structure] input structure for adv_no_gui 'initialize' (--see ch 2. of advisor docs for fields)
% input.init.saved_veh_file
% input.init.comp_files.comp
% input.inti.comp_files.name
% input.init.overrides.name
% input.init.overrides.value
% input.init.overrides.default
% input.init.units 'us'|'metric'
% input.init.init_conds_file 'init_conds'|'init_conds_amb'|'init_conds_hot'
%
% 2. varAng [3 column cell of advisor_no_gui flag, param, and settings] array of advisor_no_gui flags, 
% params, and settings to use in adv_no_gui
% e.g., varAng={{'drive_cycle'},{'cycle.name','cycle.number'},{'CYC_OCC',[1]};
% {'drive_cycle'}{'cycle.name','cycle.soc'},{'CYC_OCC','off'}};
% case 'drive_cycle'
% cycle.run               <==>'on'|'off'
% cycle.number            <==> any integer
% cycle.name              <==> 'CYC_UDDS'|other cycle name
% cycle.soc               <==> 'off'|'on'
% cycle.socmenu           <==> 'zero delta'|...
% cycle.soc_tol_method    <==> 'soctol'
% cycle.SOCtol            <==> double
% cycle.SOCiter           <==> max number of iterations [double]
% test.run                <==> 'off'
% test.name               <==> 'TEST_CITY_HWY'
% gradeability.run        <==> 'off'
% acceleration.run        <==> 'off'
% road_grade.run          <==> 'off'
% parametric.run          <==> 'off'
% multi_cycles.run        <==> 'off'
% saber_cosim.run         <==> 0|1 (should be set to zero)
%
% CASE 'accel_test'
% Inputs:
% spds				(mph), matrix of initial speeds in first column and final speeds in second column
% dist_in_time		(s), time over which to measure max distance traveled (e.g. distance traveled in 5s)
% time_in_dist		(mi), distance over which to measure time (e.g. 1/4 mi time)
% ess_init_soc		(--), initial state of charge of the ess
% gb_shift_delay	(s), delay time during a shift in which no torque can be transmitted
% disp_results		(--), boolean flag 1==> display results, 0 ==> don't display
% max_rate_bool	(--), boolean flag 1==> calc max accel rate, 0 ==> don't calc
% max_speed_bool	(--), boolean flag 1==> calc max speed, 0 ==> don't calc
% override_mass	(kg), override vehicle mass to be used for the accel test only
% add_mass			(kg), additional mass to be added to current vehicle mass for accel test only
% disable_systems	(--), flag to disable power systems 1==> disable ess, 2 ==> disable fc
% 
% Responses:
% accel_resp.times			(s), vector of accel times associated with input speed ranges
% accel_resp.dist				(mi), distance traveled in specified time
% accel_resp.time				(s), time to travel specified distance
% accel_resp.max_rate		(ft/s^2), maximum rate of acceleration
% accel_resp.max_speed		(m/s), vehicle top speed
%
% CASE 'grade_test'
% NOTES:
%	1) If neither grade nor speed is specified, the script will find the max 
%		grade achievable at 55 mph.
%  2) If a speed argument is provided, the script will find the max grade 
%		at the specified speed.
%  3) If both a speed and a grade argument is provided, the script will only 
%		test that one point and return an empty set if unsuccessful or the grade 
%		if successful.
% Input arguments:
%		disp_status		(boolean), 1==>0 display status in command window, 0==> do not display status [optional]
%		grade				(%), grade the vehicle will try to achieve  [optional]
%		duration			(s), duration over which the vehicle must maintain speed and grade [optional]
%		speed				(mph), the speed the vehicle is to achieve at the specified grade [optional]
%		gear_num			(--), user specified gear ratio in which test is to be performed [optional]
%		ess_init_soc	(--), user specified initial SOC of the ESS [optional]
%		ess_min_soc		(--), user specified minimum SOC of the ESS [optional]
%		grade_lb			(%), grade lower bound for search [optional]
%		grade_ub			(%), grade upper bound for search [optional]
%		grade_init_step(%), grade initial step size [optional]
%		speed_tol		(mph), convergence tolerance on speed [optional]
%		max_iter			(--), maximum number of interations [optional]
%		grade_tol		(%), convergence tolerance on grade [optional]
%		disable_systems(--), flag to disable systems 1=disable ess, 2=disable fc [optional]
%		override_mass	(kg), override the current vehicle mass with specified mass [optional]
%		add_mass			(kg), add specified mass to current vehicle mass [optional]
%
% 3. varNames [cell of char] variable names to modify on the workspace between each run
%
% 4. varValues [cell matrix of any] values to assign to the workspace for each iteration
% -----> format is important! the number of rows (size(*,1)) of varValues must equal varNames
% -----> the number of columns of varValues is the number of iterations of variables per drive cycle
% 
% 5. saveFile [char] the save file to use for varTracker.m (suggest calling it *.csv to open in MS Excel)
%
% 6. varTrack [cell array of char] these are the variables you want to track to the save file
%
% 7. evalString [cell of char] optional--a string that is evaluated on the base workspace to allow you 
%    to do post process on variables before varTracker is run
%
% 8. evalStringInit [cell of char] optional--run after initialization
%
% file created 09 May 2003 by Michael O'Keefe, NREL
% michael_okeefe@nrel.gov

try
    
    [a,b]=adv_no_gui('initialize',angInput);
    
    % run eval strings if present
    if exist('evalStringInit')==1
        for m=1:length(evalStringInit)
            evalin('base',evalStringInit{m});
        end
    end
    
    for i=1:size(varAng,1) % per advisor_no_gui evaluation
        for j=1:size(varValues,2) % per variable setting
            % modify the workspace
            for k=1:length(varNames) % number of variables to modify
                if isa(varValues{k,j}{:},'double')
                    if (max(size(varValues{k,j}{:}))==1) % we'll use adv_no_gui if possible
                        inMod.modify.param=varNames(k);
                        inMod.modify.value=varValues{k,j};
                        [a,b]=adv_no_gui('modify',inMod);
                    else
                        assignin('base',varNames{k},varValues{k,j}{:});
                    end
                else % otherwise we'll just assign the variable directly
                    assignin('base',varNames{k},varValues{k}{j});
                end
            end
            
            assignin('base','angRun',varAng{i,1}{:});
            % run the simulation
            switchStr = varAng{i,1}{:};
            switch lower(switchStr)
                case 'drive_cycle', % assumes you specify the stars corresponding to vinf.*.*
                    in.cycle.param=varAng{i,2};
                    in.cycle.value=varAng{i,3};
                    
                case 'test_procedure', % assumes you specify the stars corresponding to vinf.test.*
                    in.procedure.param=varAng{i,2}; 
                    in.procedure.value=varAng{i,3};
                    
                case 'other_info', % assumes you specify workspace variable *
                    in.resp.param=varAng{i,2};
                    
                case 'modify', % assumes you specify constant scalar workspace variable *
                    in.modify.param=varAng{i,2};
                    in.modify.value=varAng{i,3};
                    
                case 'accel_test', % assumes you specify according to accel_test_advanced
                    in.accel.param=varAng{i,2};
                    in.accel.value=varAng{i,3};
                    
                case 'grade_test', % assumes you specify
                    in.grade.param=varAng{i,2};
                    in.grade.value=varAng{i,3};
                
                case 'keyboard',
                    keyboard
                    
                otherwise,
                    error('Unknown flag!')
                   
            end
            
            [a,b]=adv_no_gui(varAng{i,1}{:},in); % run with the selected switch
            
            
            % run eval strings if present
            if exist('evalString')==1
                for m=1:length(evalString)
                    evalin('base',evalString{m});
                end
            end
            
            % save variables
            if i==1&j==1 % turns the heading logging on for only the first run
                headOn=1;
            else
                headOn=0;
            end
            varTracker(saveFile,varTrack,1,headOn);
            
        end
    end
    
catch
    disp(lasterr)
    keyboard
end

return