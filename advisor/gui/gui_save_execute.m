function gui_save_execute()
%This function was created to save all the information, including initial conditions
%from the simulation setup figure.

global vinf

[f,p] = uiputfile('*_sim.mat',['ADVISOR--',advisor_ver('info'),' Simulation Setup File Save as *_sim.mat']);

if f==0 %user did not select a file name
   return
end

changed_filename=0;
%if last characters do not equal _sim.mat then change so that they do
if length(f)<=8;%not enough characters to include _sim.mat
   i=findstr('.',f);
   if isempty(i)
      f=[f,'_sim.mat'];
   else
      f=[f(1:i-1),'_sim.mat'];
   end
   changed_filename=1;
elseif isempty(findstr('_sim.mat',f))
   i=findstr('.',f);
   if isempty(i)
      f=[f,'_sim.mat'];
   else
      f=[f(1:i-1),'_sim.mat'];
   end
   changed_filename=1;
end

if changed_filename
   buttonname=questdlg(['actual filename=',f],'','cancel','ok','ok');
   if strcmp(buttonname,'cancel')
      return
   end
end


%do not overwrite gui_defaults_sim.mat
if strcmp(f,'gui_defaults_sim.mat')
   errordlg('cannot overwrite gui_defaults_sim.m.  Do it manually!');
   return;
end


simulation.gradeability=vinf.gradeability;
simulation.acceleration=vinf.acceleration;
simulation.test=vinf.test;
simulation.cycle=vinf.cycle;
simulation.road_grade=vinf.road_grade;
simulation.parametric=vinf.parametric;
simulation.init_conds=vinf.init_conds;
simulation.multi_cycles=vinf.multi_cycles; %ss 1/25/01
simulation.AuxLoadsOn=vinf.AuxLoadsOn;
simulation.AuxLoads=vinf.AuxLoads;

%save information
fullname=[p,f];
save([p,f],'simulation')

%**************
%revision history
%**************
% 11/4/98:ss changed break to return in two places and changed the question dlg
% to only display if the filename was being changed from user inputed filename.
% 9/23/99: vhj initialize changed_filename=0; advisor_ver('info')
% 9/23/99: ss fixed problem with uiputfile statement.
% 7/21/00 ss: updated name for version info to advisor_ver.
% 1/25/01 ss: added vinf.multi_cycles for the new option in simsetupfig

