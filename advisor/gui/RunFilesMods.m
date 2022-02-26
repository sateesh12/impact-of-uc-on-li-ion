function RunFilesMods(option,var_name,var_value,group)

global vinf

switch option
    
case 'modify'
    
    eval('vinf.RunFileMods;test4exist=1;','test4exist=0;');
    if test4exist
        %   Check if name already exists-- if so replace value
        ListValue=strmatch(var_name,vinf.RunFileMods(:,1),'exact');
        if ~isempty(ListValue)
            vinf.RunFileMods{ListValue,1}=var_name;
            vinf.RunFileMods{ListValue,2}=var_value;
            if exist('group')
                vinf.RunFileMods{ListValue,3}=group;
            else
                vinf.RunFileMods{ListValue,3}=[];
            end
        else
            vinf.RunFileMods{end+1,1}=var_name;
            vinf.RunFileMods{end,2}=var_value;
            if exist('group')
                vinf.RunFileMods{end,3}=group;
            else
                vinf.RunFileMods{end,3}=[];
            end
        end
    else
        vinf.RunFileMods{1,1}=var_name;
        vinf.RunFileMods{1,2}=var_value;
        if exist('group')
            vinf.RunFileMods{1,3}=group;
        else
            vinf.RunFileMods{1,3}=[];
        end
    end
    
case 'update'
    
    %   If any other modifications, run those
    eval('UpdateMods=isfield(vinf,''RunFileMods'');','UpdateMods=0;');
    if UpdateMods
        for i=1:length(vinf.RunFileMods(:,1))
            if isa(vinf.RunFileMods{i,2},'numeric')
                eval([vinf.RunFileMods{i,1},'=',num2str(vinf.RunFileMods{i,2}),';']);
            elseif isa(vinf.RunFileMods{i,2},'char')
                evalin('base',[vinf.RunFileMods{i,1},'=',(vinf.RunFileMods{i,2}),';']);
            end
        end
    end
    
case 'remove'
    
    %   Remove from vinf.RunFileMods all information associated with the specified group
    eval('vinf.RunFileMods;group;test4exist=1;','test4exist=0;');
    if test4exist
        old_RunFileMods=vinf.RunFileMods;
        vinf=rmfield(vinf,'RunFileMods');
        RunFileModsNum=0;
        for i=1:length(old_RunFileMods(:,1))
            if ~strcmp(old_RunFileMods{i,3},group)
                for j=1:3
                    vinf.RunFileMods{RunFileModsNum,j}=old_RunFileMods{i,j};
                end
            end
        end
    end
    
end % end switch option
