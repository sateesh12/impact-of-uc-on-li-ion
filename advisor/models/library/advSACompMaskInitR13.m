%function logFlag=advSACompMaskInitR13(generalName,logPick,initFileName,modCell,DEBUG)
% advSACompMaskInit.m
% ADVISOR Stand-Alone Component Mask Initialization Function
%
% Mask must define the following:
% 1. generalName --> [char--evaluated] the general name for all variables and control signal tags employed
% 2. logPick --> [double] [1|2] a flag to tell whether or not to log variables to workspace 1--> no, 2-->yes
% 3. initFileName --> [cell of char] a cell array containing files to load to initialize the component
% 4. modCell --> [two column cell of char and any type] a two column cell array with variable name in first column and new value in second
% 5. DEBUG --> a flag to turn on/off the DEBUG functionality
%
% note: logFlag is assumed to be determined via a pulldown menu assigned to variable logPick--choice 1 --> logFlag=0,
% choice 2 --> logFlag=1
% variables 3 and 4 can be empty cells if not used (i.e., {},{})
if exist('DEBUG')~=1
    DEBUG='ON';
end
if strcmp(DEBUG,'ON')
    disp(['Starting ',mfilename])
end
try
    r=gcb;
    [s,r]=strtok(r,'/');
    if strcmp(get_param(s,'Lock'),'off') % only run this script in an unlocked system--i.e. models and unlocked libraries
        
        disp(['==> Initializing: ', generalName])
        
        %         blockLinkStatus=get_param(gcb,'LinkStatus');
        %         if strcmp(blockLinkStatus,'resolved')
        %             set_param(gcb,'LinkStatus','inactive') % must make link inactive to perform changes to block tags
        %             %set_param(gcb,'LinkStatus','none')
        %         end
        
        % assumes code is run from a masked block with 'MaskSelfModifiable' set to 'on' 
        % -- note: works but not eligant. If you look at the model block where enhancedToWorkspace blocks reside 
        % before running the model, you get one of those horrid MATLAB stack dumps on the workspace--then the block will work fine...
        % maybe we could try putting a copy function on the model block to set links to inactive???
        %         model=[gcb,'/model&interface/model'];
        %         modelBlockLinkStatus=get_param(model,'LinkStatus');
        %         if strcmp(modelBlockLinkStatus,'resolved')
        %             set_param(model,'LinkStatus','inactive') % must make link inactive to perform changes to block enhancedToWorkspace tags
        %             %set_param(gcb,'LinkStatus','none')
        %         end
        
        if logPick==1 % pick one is equal to "OFF" or 0
            logFlag=0;
        elseif logPick==2 % pick two is equal to "ON" or 1
            logFlag=1;
        end
        
        if ~isempty(initFileName)
            for i=1:length(initFileName)
                eval(initFileName{i});
            end
        end
        
        if ~isempty(modCell)
            for j=1:length(modCell(:,1))
                eval([modCell{j,1},'= modCell{',num2str(j),',2};']);
                
                if strcmp(DEBUG,'ON')
                    disp([modCell{j,1},' is being assigned.'])
                end
            end
        end
        
        try 
            set_param([gcb,'/controlTag'],'GotoTag',[generalName,'Control'])
            set_param([gcb,'/sensorsTag'],'GotoTag',[generalName,'Sensors'])
            set_param([gcb,'/sensorsTag'],'TagVisibility','global')
            set_param([gcb,'/reqOutTag'],'GotoTag',[generalName,'ReqOut'])
            set_param([gcb,'/reqOutTag'],'TagVisibility','global')
        catch
            disp(['[',mfilename,'] error setting tag parameters'])
            if DEBUG
                disp(lasterr)
                disp(sllasterror)
                keyboard
            end
        end
    end
catch
    if DEBUG
        disp(lasterr)
        disp(sllasterror)
        disp(['[',mfilename,'] An error has occured in this script file. Going to keyboard--''dbquit'' or ''return'' to exit keyboard'])
        keyboard
    end
end