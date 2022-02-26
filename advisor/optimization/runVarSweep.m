function runVarSweep(angInput, varCyc, varNames, varValues, saveFile, varTrack, evalString)
% this function uses adv_no_gui.m and varTracker.m to run and save parametric sweep results
% runVarSweep(angInput, varCyc, varNames, varValues, saveFile, varTrack, evalString)
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
% 2. varCyc [2 column cell of param and settings] array of drive cycle params and settings to use in adv_no_gui
% e.g., varCyc={{'cycle.name','cycle.number'},{'CYC_OCC',[1]};{'cycle.name','cycle.soc'},{'CYC_OCC','off'}};
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
% file created 26 March 2003 by Michael O'Keefe, NREL
% michael_okeefe@nrel.gov

[a,b]=adv_no_gui('initialize',angInput);

for i=1:size(varCyc,1) % per drive cycle
    for j=1:size(varValues,2) % per design iteration
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
        
        % run the simulation        
        in.cycle.param=varCyc{i,1};
        in.cycle.value=varCyc{i,2};
        
        [a,b]=adv_no_gui('drive_cycle',in);
        
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

return