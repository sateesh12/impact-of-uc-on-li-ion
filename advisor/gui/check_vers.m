function flag=check_vers(filename,pathname)

% gives message about user needing to update old files
% flag = 1 if everything worked ok.

flag=0;
current_ver=2003;

%ss:4/29/99 try statement added because some files require variables from other files.
%this way the file will at least get to the version number before crashing and won't
%cause the program to stop and display warnings.
filename=strrep(filename,'.m','');
try
	eval(filename);
catch
end


ver_name=who('*version'); %cell array
try
   old_ver_num=eval(ver_name{1});
catch
   old_ver_num=2.0;
end

if old_ver_num<current_ver
   
   buttonname=questdlg(['The file ', filename,' which you have attempted to add is from version ', num2str(old_ver_num,3),' of ADVISOR (*_version is not equal to ',...
         num2str(current_ver),'). ', filename,' does not contain all data necessary to be used with ADVISOR ',...
         num2str(current_ver),'.  Please refer to a current ',num2str(current_ver),...
         ' file when creating a new file. Would you like ADVISOR to automatically update your file?     Please Note: Spaces in directories or filenames are not supported for this function.'  ],...
      '','Yes','No','HELP','Yes');
   
   if strcmp(buttonname,'Yes')
      filename=[filename,'.m'];
      update_file(filename,pathname);
      flag=1;
  elseif strcmp(buttonname,'HELP')
      try
          load_in_browser('advisor_ch2.html', '#2.2'); % mpo 8-Aug-2001: the -browser flag starts up the user's web-browser
                                                                % which is somewhat easier to use than the matlab browser IMHO.
      catch
         disp('Help documentation not installed or not in path-- advisor_ch2.html not found');
      end
      flag=0;
  else
      flag=0;
   end
      
else
   flag=1;
end

eval(['clear ', filename]); % mpo 8-Aug-2001: force MATLAB to re-evaluate this file next time it is incountered since
                            % the file may have been modified and MATLAB may want to reference the file contents from memory

%REVISIONS
% 4/29/99 ss: added try statement
% 9/6/99 mc: updated version number from 2.1 to 2.12
% 9/7/99 mc: added second try/catch to catch cases where ver # is not picked up
%            updated GUI questdlg to use numstr(current_ver) rather than '2.1'
% 9/9/99:tm fixed version number error (changed 2.12 to 2.2)
% 8/22/00:tm updated version to 3.0
% 8/22/00: ss added pathname to update_file
% 2/8/01: ss updated version to 3.1
% 8/2/01: mpo added 'help' feature to the button menu (at the sacrifice of 'cancel' though...) and changed text displayed
% 8/8/01: mpo added line to force matlab to clear filename from memory and re-evaluate (in case file was changed/modified)
% 04/19/01: mpo updated version to 2002
% 10/9/03: ss updated version to 2003
