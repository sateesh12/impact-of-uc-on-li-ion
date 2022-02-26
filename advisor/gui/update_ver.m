% update_ver(newvernum, oldvernum, datafile_name, pathname)
%
% Overwrites old version number of selected file with new version number.  In the
% event that there is more than one occurrence of '_version=X.XX;', each 
% occurrence is updated.
%
% Input new and old vernum as character strings!!
% This function may be called with two or three input parameters.  
% If two parameters are given, all files in the current directory are updated to 
% the new version number to the old version number.
%
% The input parameter datafile_name may be passed with or without its .m suffix.

function update_ver(newvernum, oldvernum, datafile_name, pathname)

%
% initialize
%
if nargin==2
   batch=1;
elseif nargin>2
   batch=0;
   %datafile_name=upper(datafile_name);
   if isempty(findstr(datafile_name,'.m'))
      datafile_name=[datafile_name,'.m'];
   end
else
   error('didn''t understand request')
end

%
% build an array of all m-files, if necessary
%
if batch
   filelist_all=dir;
   mfilecount=0;
   for file_i=1:length(filelist_all)
      current_file=upper(filelist_all(file_i).name);
      if ~isempty(findstr(current_file,'.M')) & ...
            isempty(findstr(current_file,'.MDL')) & isempty(findstr(current_file,'.MAT')) & ...
            ~strcmp(current_file,'UPDATE_VER.M')
         mfilecount=mfilecount+1;
         filelist{mfilecount}=current_file;
      end
   end
   if isempty(filelist)
      disp('No files to update!')
      return
   end
else
   filelist=datafile_name;
end

%
% loop through the files
%
if batch
   pathname=[pwd '\'];
   for file_i=1:length(filelist)
      current_file=upper(filelist{file_i});
      % update current file
      InsertNewVerNum(current_file,newvernum,oldvernum,pathname);
   end
else
   InsertNewVerNum(filelist,newvernum,oldvernum,pathname)
end


%---------------------------------------
% END OF MAIN FUNCTION
%---------------------------------------

function InsertNewVerNum(current_file,newvernum,oldvernum,pathname)
% BEGIN added by mpo [02-APRIL-2002] trying to ensure that the pathname will be handled correctly
% --we want pathname to include a slash between it and current_file
pathname=strrep(pathname,'/',filesep);
pathname=strrep(pathname,'\',filesep);
if ~isempty(pathname)&length(pathname)>1
    if ~strcmp(pathname(end), filesep)
        pathname=[pathname filesep];
    end
end
% END added by mpo [02-April-2002]
% open and read the current file
fid=fopen([pathname,current_file],'rt');
str_old=fscanf(fid,'%c'); %str_old used to be S
fclose(fid);

% replace current version with new version by searching out and replacing 
% every '_version=oldvernum;' command in the file
try
    ind_start=min(findstr(str_old,'_version'));
    ind_semi=findstr(str_old,';');
    ind_end=ind_semi(min(find(ind_semi>ind_start)));
    ver_str_old=str_old(ind_start:ind_end);
    %S=strrep(str_old , ['_version=',oldvernum] , ['_version=',newvernum] );
    S=strrep(str_old , ver_str_old , ['_version=',newvernum,';'] );
    
    if ~strcmp(S,str_old)
        % fix it for printing via MATLAB
        Snew=strrep(S,'%','%%');     % double all % signs
        Snew=strrep(Snew,'\','\\');  % replace all escape sequences to print backslash?
        
        % write updated file, using same filename
        
        fid=fopen([pathname,current_file],'wt');
        fprintf(fid,Snew);
        fclose(fid);
        disp(['[update_ver.m] UPDATED file version: ', pathname, current_file]) 
    else
        disp(['[update_ver.m] did not update version: ', pathname, current_file])
    end
catch
    disp(['[update_ver.m] error encountered updating ("*_version=##;" may not exist): ', pathname, current_file])
end

% 8/22/00 ss: updated by adding in pathname.
% 2/12/01:tm added statements to find indices of str surrounding version number so that entire string is replaced not just the numerical part
% 4/02/02:mo added filesep in InsertNewVerNum so pathname and filename are separated correctly. This error only occurs if not called as batch and user doesn't give pathname with trailing slash
% 4/19/02:mpo added a try-catch in InsertNewVerNum() to avoid errors due to *_version=##; not existing
% 4/26/02:mpo added the line strrep(Snew,'\','\\') in the InsertNewVerNum subfunction to eliminate printing problems due to accidental interpretation of escape characters