function clearfile(filename)

%this function takes as input a filename, runs the file in the function workspace, 
%  finds all the filename variables and clears them in the base workspace.

   try
      run(filename)
      h=who;
      assignin('base','temp4clearfile',h)
      evalin('base',['clear(temp4clearfile{:})'])
      evalin('base','clear temp4clearfile')
      
      disp(['***' filename ' variables cleared'])
   catch
      %get first few letters of filename and use them in clear command
      h=findstr(filename,'_');
      letters=lower(filename(1:min(h)));
      
      str=['clear ' letters '*'];
      evalin('base',str)
      disp(['*** cleared ' letters '* variables'])
   end
