% enhancedToWsMaker
% This script file runs in the initialization mask of the lib_etc/enhancedToWorkspace block
% the file dynamically reconfigures the To Workspace block with the correct logging info
% or places a terminator block in the system if no variables are to be logged
%
% a note to future updaters: change the value of SIMULINK_LIB if a new version of simulink changes the name
SIMULINK_LIB='simulink3';
DEBUG=0;
if DEBUG
    disp(['[',mfilename,'] start'])
end
try
    r=gcb;
    [s,r]=strtok(r,'/');
    try
        if DEBUG
            disp('INIT:')
            disp(['For block ',gcb])
            disp(['LinkStatus is ',get_param(gcb,'LinkStatus')])
        end
    end
    if strcmp(get_param(s,'Lock'),'off') % only run this function in an unlocked system--i.e. models and unlocked libraries        
        try
            parentBlock=get_param(gcb,'Parent');
            parentLinkStatus=get_param(parentBlock,'LinkStatus');
            if DEBUG
                disp(['ParentLinkStatus is ',parentLinkStatus])
            end
        end
        blockLinkStatus=get_param(gcb,'LinkStatus');
        %if strcmp(blockLinkStatus,'resolved')
        if strcmp(blockLinkStatus,'resolved')
            %set_param(gcb,'LinkStatus','inactive')
            set_param(gcb,'LinkStatus','none')
        end
        %disp('running2')
        a=find_system(gcb,'LookUnderMasks','all');
        
        % determine blocks to delete--don't delete the masked subsystem or the input port
        del=a;
        ind=strcmp(del,gcb); % don't delete the subsystem itself
        del=del(~ind);
        ind=strcmp(del,[gcb,'/In1']); % don't delete the input port
        del=del(~ind);
        
        % delete the blocks
        for i=1:length(del)
            delete_block(del{i})
        end
        
        % delte any lines
        lineInf = get_param([gcb,'/In1'],'PortConnectivity');
        try % if the try block fails, there musn't have been a line there...
            delete_line(gcb,lineInf.Position);
        end
        
        load_system(SIMULINK_LIB); % make sure Simulink3 is loaded so that we can pull in the appropriate blocks
        % add blocks depending on what is going on:
        
        if isempty(logFlag)
            add_block('simulink3/Sinks/Terminator',[gcb,'/Terminator'],'Position',[145    85   205   115])
            add_line(gcb,'In1/1','Terminator/1')
        elseif logFlag==1 % we need a To Workspace

            % handle cases where the generalName is not specified
            if ~isempty(generalName)
                VariableName = [generalName,'_',specificName];
            else
                Variablename = specificName;
            end
            
            %MaxDataPoints= 'inf'; %'MaxDataPoints',MaxDataPoints,...
            Decimation='1';
            SampleTime='-1';
            SaveFormat='Array';
            add_block('simulink3/Sinks/To Workspace',[gcb,'/To Workspace']);
            set_param([gcb,'/To Workspace'],'VariableName',VariableName);
            set_param([gcb,'/To Workspace'],'Decimation',Decimation);
            set_param([gcb,'/To Workspace'],'SampleTime',SampleTime);
            set_param([gcb,'/To Workspace'],'SaveFormat',SaveFormat);
            set_param([gcb,'/To Workspace'],'Position',[145    85   205   115]);
            add_line(gcb,'In1/1','To Workspace/1')
        else
            add_block('simulink3/Sinks/Terminator',[gcb,'/Terminator'],'Position',[145    85   205   115])
            add_line(gcb,'In1/1','Terminator/1')
        end
        %disp('finished2')
        try % not sure if this will work all the time (if at top level of model for instance)
            % set_param(parentBlock,'LinkStatus',parentLinkStatus); % reset the parent link status to previous
            %         parentBlock=get_param(gcb,'Parent');
            %         if ~strcmp(get_param(parentBlock,'LinkStatus'),'none')
            %             % if the parent block is a resolved, unresolved, implicit, or inactive link...
            %             set_param(gcb,'LinkStatus','implicit')
            %         end
        end
        if DEBUG
            try
                disp(['After set, Link Status is ', get_param(gcb,'LinkStatus')])
            end
        end
        get_param(gcb,'LinkStatus'); % the block seems to need to query this again to resolve links correctly
    end
catch
    if DEBUG
        disp(lasterr)
        disp(sllasterror) 
        keyboard
    end
end
