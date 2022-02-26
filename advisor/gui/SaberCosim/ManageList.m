function ReturnList=ManageList(StorageFileName,Operation,ListName,CellName,NewCellName)

% ReturnList=ListControl(StorageFileName,StorageVarName,Operation,ListName,CellName,NewCellName)
%   This function does several operations pertaining to lists 
%       -Get (list)
%       -Add (to list)
%       -Delete (from list)
%       -Rename (list item CellName with NewCellName)
%       -AddList (add new list to an existing list structure)
%   ReturnList:  The list returned from calling function
%   StorageFileName:  .mat file name for storing list
%   Operation:  The desired operation (get, add, delete,...)
%   ListName:  Structure variable of name of list to perform operation on or to add  
%   CellName:  Name of cell in list or list of cells for a new ListName
%   NewCellName:  New name for a cell 

switch Operation
    
case 'Get'
    TempList=GetExistingList(StorageFileName,ListName);  
    
case 'Add'
    load(StorageFileName);
    TempList=GetExistingList(StorageFileName,ListName);
    TempList(length(TempList)+1)=cellstr(CellName);
    eval([ListName,'=TempList;']);
    save(StorageFileName,strtok(ListName,'.'));
    
case 'Delete'
    load(StorageFileName);
    TempList=GetExistingList(StorageFileName,ListName);
    if nargin > 3
        for i=1:length(TempList)
            if strmatch(TempList(i),CellName)
                DeleteValue=i;
            end
        end
        TempList(DeleteValue)=[];
    end
    eval([ListName,'=TempList;']);
    save(StorageFileName,strtok(ListName,'.'));
    
case 'Rename'
    TempList=GetExistingList(StorageFileName,ListName);
    if nargin > 4
        for i=1:length(TempList)
            if strmatch(TempList(i),CellName)
                TempList(i)=cellstr(NewCellName);
            end
        end
    end
    eval([ListName,'=TempList;']);
    save(StorageFileName,strtok(ListName,'.'));
    
case 'AddList'
    load(StorageFileName);
    eval([ListName,'=cellstr(CellName);']);
    TempList=ListName;
    save(StorageFileName,strtok(ListName,'.'));
    
case 'DeleteList'
    load(StorageFileName);
    %Cell
    
    
    
    NameParts=symvar(ListName);
    FieldName=NameParts(length(NameParts));
    BaseName=strrep(ListName,['.',FieldName{1}],'');
    TempList=rmfield(eval(BaseName),FieldName);
    eval([ListName,'=TempList;']);
    save(StorageFileName,strtok(ListName,'.'));
    
end

ReturnList=TempList;



%=================================================================================
% [List]=GetExistingList(StorageFileName,ListName)
%   This function returns the list called ListName stored in file StorageFileName
%=================================================================================
function [List]=GetExistingList(StorageFileName,ListName)

if exist(StorageFileName) > 0
    load(StorageFileName);
    List=eval([ListName]);
else
    fprintf('Error:  %s does not exist\n',StorageFileName);
    List=[];
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revision notes
% 05/21/01: ab file created 
