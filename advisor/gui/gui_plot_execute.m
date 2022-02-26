function gui_plot_execute()

%this function plots the trace of the cycle to run based
%on what is selected on the cycle listbox

global vinf

waithandle=waitbar(0,'Updating Display...');

if get(findobj('tag','cycle_radiobutton'),'value')==1
   str=gui_current_str('cycles');
   
   %functionality for cycle statistics information 
   cyc=get_cycle_info(str,1);
   set(findobj('tag','time'),'string',num2str(cyc.time))
   set(findobj('tag','distance'),'string',num2str(round(cyc.distance*units('miles2km')*100)/100))
   set(findobj('tag','max speed'),'string',num2str(round(cyc.max_spd*units('mph2kmph')*100)/100))
   set(findobj('tag','avg speed'),'string',num2str(round(cyc.avg_spd*units('mph2kmph')*100)/100))
   set(findobj('tag','max accel'),'string',num2str(round(cyc.max_accel*units('ft2m')*100)/100))
   set(findobj('tag','max decel'),'string',num2str(round(cyc.max_decel*units('ft2m')*100)/100))
   set(findobj('tag','avg accel'),'string',num2str(round(cyc.avg_accel*units('ft2m')*100)/100))
   set(findobj('tag','avg decel'),'string',num2str(round(cyc.avg_decel*units('ft2m')*100)/100))
   set(findobj('tag','idle time'),'string',num2str(cyc.idle_time))
   set(findobj('tag','no. of stops'),'string',num2str(cyc.num_stops))
   set(findobj('tag','max up grade'),'string',num2str(round(cyc.max_up_grade*100*10)/10))
   set(findobj('tag','avg up grade'),'string',num2str(round(cyc.avg_up_grade*100*10)/10))
   set(findobj('tag','max dn grade'),'string',num2str(round(cyc.max_dn_grade*100*10)/10)) 
   set(findobj('tag','avg dn grade'),'string',num2str(round(cyc.avg_dn_grade*100*10)/10)) 
   
   h1=findobj('tag','statistics axes');
   axes(h1)
   cla
   reset(gca)
   h=bar(cyc.spd_range*units('mph2kmph'),cyc.dist_percent);
   if strcmp(vinf.units,'metric')
      xlabel('Speed (km/h)')
   elseif strcmp(vinf.units,'us')
      xlabel('Speed (mph)')
   end
   ylabel('Percentage (%)')
   title(strrep(cyc.cyc_name,'_','\_'))
   set(gca,'tag','statistics axes','box','off','userdata','statistics')
 
   waitbar(.5)
   
   %run in the 'base' workspace to make variables available
   evalin('base',str);
   
   % build cycle grade vector if only defined as a scalar tm:8/23/99
   if evalin('base','size(cyc_grade,2)')<2
      evalin('base',['cyc_grade=[0 cyc_grade; 1 cyc_grade];']) 
   end
   
   % use road grade from figure if checkbox is checked for road grade
   if get(findobj('tag','road_grade_checkbox'),'value')==1
      grade=get(findobj('tag','road_grade_edit'),'string');%this is a string!   
      %change grade into a decimal instead of percentage for use with block diagram
      grade=num2str(str2num(grade)/100);
      % build grade vector
      evalin('base',['cyc_grade=[0 ',grade,'; 1 ',grade,'];']) 
   end
   
   %obtain cyc_cargo_mass from base
   cyc_cargo_mass=evalin('base','cyc_cargo_mass');
   %obtain speed, time and distance from cyc_mph variable
   cyc_mph=evalin('base','cyc_mph');
   mph2mps=1/3600; %units conversion: mph to miles/s
   distance=cumtrapz(cyc_mph(:,1), cyc_mph(:,2)*mph2mps); %in miles
   miles2meters=1609.344;
   distance_meters=distance*miles2meters;
   
   %obtain key on information vs. time
   vc_key_on=evalin('base','vc_key_on');
   
   %obtain cyc_grade from workspace
   cyc_grade=evalin('base','cyc_grade');
   
   %make sure distance_meters contains all cyc_grade and cyc_cargo_mass distance 
   %points and add these points into cyc_mph (if they don't already exist)
   new_distance_pts=[];
   j=1;
   for i=1:max(size(cyc_grade))
       index = find( distance_meters == cyc_grade(i,1) );
       if isempty(index) 
           if cyc_grade(i,1)<max(distance_meters)
               new_distance_pts(j,1)=cyc_grade(i,1);
               j=j+1;
           end
       end
   end
   for i=1:max(size(cyc_cargo_mass))
       index = find( distance_meters == cyc_cargo_mass(i,1) );
       if isempty(index) 
           if cyc_cargo_mass(i,1)<max(distance_meters)
               new_distance_pts(j,1)=cyc_cargo_mass(i,1);
               j=j+1;
           end
       end
   end
   
   if ~isempty(new_distance_pts)
      %remove repeated distances for interp1 to work
      j=1;
      for i=2:length(distance_meters)
          if distance_meters(i)~=distance_meters(i-1)
              j=[j i];
          end
      end
      temp_distance=distance_meters(j);
      temp_cyc_mph=[cyc_mph(j,1) cyc_mph(j,2)];
      
      %add points to cyc_mph for the exact distances in grade
      new_cyc_mph_pts=interp1(temp_distance,temp_cyc_mph(:,2),new_distance_pts);
      new_time_pts=interp1(temp_distance,temp_cyc_mph(:,1),new_distance_pts);
      
      cyc_mph=[cyc_mph(:,1) cyc_mph(:,2);
            new_time_pts  new_cyc_mph_pts  ];
            
      %sort the new cyc_mph so it's in the correct sequential time order
      cyc_mph=sortrows(cyc_mph);
      
      %recalculate distance_meters
      distance=cumtrapz(cyc_mph(:,1), cyc_mph(:,2)*mph2mps); %in miles
      clear mph2mps
      distance_meters=distance*miles2meters;
      
   end
   
   
   
   %assume that distance is based on time (ie. cyc_mph(:,1))
   %for each distance (assumed to be based on its counter part in cyc_mph(:,1)
   %       find the grade associated with distance and therefore time, assuming that the grade vector repeats itself
   
   %note in the following that distance is adjusted for repeating because cyc_grad(:,1) (ie. distance) usually
   %does not go the distance of the cycle
   grade_t_d_dep=interp1(cyc_grade(:,1),cyc_grade(:,2),rem(distance_meters,cyc_grade(end,1))); %grade that is time and distance dependent.
   
   %cargo_mass
   mass_t_d_dep=interp1(cyc_cargo_mass(:,1),cyc_cargo_mass(:,2),rem(distance_meters,cyc_cargo_mass(end,1))); %cargo_mass that is time and distance dependent.
   
   %calculate elevation vs. distance
   elevation_delta=diff(distance_meters).*sin(atan(grade_t_d_dep(1:end-1)));
   elevation=evalin('base','cyc_elevation_init');
   
   elevation=cumsum([elevation(1); elevation_delta]);   
   
   
   h=findobj('tag','simulation_axes');
   axes(h)
   cla
   %delete all axes in simulation figure except for the base one
   handles=findobj(gcf,'type','axes');
   h1=findobj('tag','statistics axes');

   if ~isempty(handles)
      for i=1:length(handles)
         if handles(i)~=h & handles(i)~=h1
            delete(handles(i))
         end
      end
   end
   xlim('auto')
   ylim('auto')
   hold on
   
      
   %plot trace based on which type of plot is selected
   plot_str=gui_current_str('plot_menu');
   
   title(strrep(str,'_','\_'));%the extra command inside of title is to deal with underscores

   switch plot_str
      
   case 'Speed/Grade vs. Time'
      
      handle=plot(vc_key_on(:,1),vc_key_on(:,2),'r');
      
      %Create the plotyy graph.  The handle(s) to the lines in the left axis are in h1 and the handles
      %to the second axis lines are in h2.  ax contains the handles to the two axes created.
      [ax,h1,h2]=plotyy(cyc_mph(:,1),cyc_mph(:,2)*units('mph2kmph'),cyc_mph(:,1),grade_t_d_dep);
      xlabel('time (sec)')
      if strcmp(vinf.units,'metric')
         ylabel('speed (km/h)')
      else
         ylabel('speed (mph)')
      end
      %create the legend and explicitly state the handles to each line
      legend([handle h1 h2],'key on','speed','grade',0);
      
      %make the second axes current (the axes with a color of 'none') so that both lines are visible
      axes(ax(2))
      ylabel('grade (decimal)')
      
   case 'Speed/Elevation vs. Time'
      
      handle=plot(vc_key_on(:,1),vc_key_on(:,2),'r');
      
      %Create the plotyy graph.  The handle(s) to the lines in the left axis are in h1 and the handles
      %to the second axis lines are in h2.  ax contains the handles to the two axes created.
      [ax,h1,h2]=plotyy(cyc_mph(:,1),cyc_mph(:,2)*units('mph2kmph'),cyc_mph(:,1),elevation*3.281*units('ft2m'));
      xlabel('time (sec)')
      if strcmp(vinf.units,'metric')
         ylabel('speed (km/h)')
      else
         ylabel('speed (mph)')
      end
      
      %create the legend and explicitly state the handles to each line
      legend([handle h1 h2],'key on','speed','elevation',0);
      
      %make the second axes current (the axes with a color of 'none') so that both lines are visible
      axes(ax(2))
      if strcmp(vinf.units,'metric')
         ylabel('elevation (meters)')
      else
         ylabel('elevation (feet)')
      end

   case 'Speed/Grade vs. Distance'
      cla
      %Create the plotyy graph.  The handle(s) to the lines in the left axis are in h1 and the handles
      %to the second axis lines are in h2.  ax contains the handles to the two axes created.
      [ax,h1,h2]=plotyy(distance*units('miles2km'),cyc_mph(:,2)*units('mph2kmph'),distance*units('miles2km'),grade_t_d_dep);
      if strcmp(vinf.units,'metric')
         ylabel('speed (km/h)')
         xlabel('distance (km)')
      else
         ylabel('speed (mph)')
         xlabel('distance (miles)')
      end
 
      %create the legend and explicitly state the handles to each line
      legend([h1 h2],'speed','grade',0);
      
      %make the second axes current (the axes with a color of 'none') so that both lines are visible
      axes(ax(2))
      ylabel('grade (decimal)')
 
   case 'Speed/Elevation vs. Distance'
      %Create the plotyy graph.  The handle(s) to the lines in the left axis are in h1 and the handles
      %to the second axis lines are in h2.  ax contains the handles to the two axes created.
      [ax,h1,h2]=plotyy(distance*units('miles2km'),cyc_mph(:,2)*units('mph2kmph'),distance*units('miles2km'),elevation*3.281*units('ft2m'));
      if strcmp(vinf.units,'metric')
         ylabel('speed (km/h)')
         xlabel('distance (km)')
      else
         ylabel('speed (mph)')
         xlabel('distance (miles)')
      end
      
      %create the legend and explicitly state the handles to each line
      legend([h1 h2],'speed','elevation',0);
      
      %make the second axes current (the axes with a color of 'none') so that both lines are visible
      axes(ax(2))
      if strcmp(vinf.units,'metric')
         ylabel('elevation (meters)')
      else
         ylabel('elevation (feet)')
      end
      
   case 'Speed/Cargo Mass vs. Time'
      
      handle=plot(vc_key_on(:,1),vc_key_on(:,2),'r');
      
      %Create the plotyy graph.  The handle(s) to the lines in the left axis are in h1 and the handles
      %to the second axis lines are in h2.  ax contains the handles to the two axes created.
      [ax,h1,h2]=plotyy(cyc_mph(:,1),cyc_mph(:,2)*units('mph2kmph'),cyc_mph(:,1),mass_t_d_dep);
      xlabel('time (sec)')
      if strcmp(vinf.units,'metric')
         ylabel('speed (km/h)')
      else
         ylabel('speed (mph)')
      end
      %create the legend and explicitly state the handles to each line
      legend([handle h1 h2],'key on','speed','cargo mass',0);
      
      %make the second axes current (the axes with a color of 'none') so that both lines are visible
      axes(ax(2))
      ylabel('cargo mass (kg)')
      
      
   case 'Speed/Cargo Mass vs. Distance'
      cla
      %Create the plotyy graph.  The handle(s) to the lines in the left axis are in h1 and the handles
      %to the second axis lines are in h2.  ax contains the handles to the two axes created.
      [ax,h1,h2]=plotyy(distance*units('miles2km'),cyc_mph(:,2)*units('mph2kmph'),distance*units('miles2km'),mass_t_d_dep);
      if strcmp(vinf.units,'metric')
         ylabel('speed (km/h)')
         xlabel('distance (km)')
      else
         ylabel('speed (mph)')
         xlabel('distance (miles)')
      end
 
      %create the legend and explicitly state the handles to each line
      legend([h1 h2],'speed','cargo mass',0);
      
      %make the second axes current (the axes with a color of 'none') so that both lines are visible
      axes(ax(2))
      ylabel('cargo mass (kg)')
   
   
   end
      
   
   hold off
      
   %update current procedure description
   h2=findobj('tag','current_procedure_text');
   %grab the first comment lines from the file
   try
      fid=fopen([str,'.m']);
      num=0;
      rownum=1; %initialize row number for description
      while feof(fid)==0
         line=fgetl(fid);
         match=findstr(line,'%');
         num=length(match);
         if num>0
            testcondition=1;
            while testcondition>0
               description{rownum,1}=line;
               line=fgetl(fid);
               match=findstr(line,'%');
               testcondition=length(match);
               rownum=rownum+1;
            end
            break
         end   
      end   
      
      
      fclose(fid);
      description=strrep(description,'%','');
      set(h2,'string',description);
      
   end;%try
end;%if cycle_radiobutton is on





%TEST PROCEDURES section
if get(findobj('tag','test_radiobutton'),'value')==1
   str=gui_current_str('test_procedures');
   
   %functionality for cycle statistics information 
   set(findobj('tag','time'),'string','n/a')
   set(findobj('tag','distance'),'string','n/a')
   set(findobj('tag','max speed'),'string','n/a')
   set(findobj('tag','avg speed'),'string','n/a')
   set(findobj('tag','max accel'),'string','n/a')
   set(findobj('tag','max decel'),'string','n/a')
   set(findobj('tag','avg accel'),'string','n/a')
   set(findobj('tag','avg decel'),'string','n/a')
   set(findobj('tag','idle time'),'string','n/a')
   set(findobj('tag','no. of stops'),'string','n/a')
   set(findobj('tag','max up grade'),'string','n/a')
   set(findobj('tag','avg up grade'),'string','n/a')
   set(findobj('tag','max dn grade'),'string','n/a')
   set(findobj('tag','avg dn grade'),'string','n/a')
   
   h1=findobj('tag','statistics axes');
   axes(h1)
   cla
   title('')
   
   %plot trace
   h=findobj('tag','simulation_axes');
   axes(h)
   cla
   %delete all axes in simulation figure except for the base one
   handles=findobj(gcf,'type','axes');
   h1=findobj('tag','statistics axes');

   if ~isempty(handles)
      for i=1:length(handles)
         if handles(i)~=h & handles(i)~=h1
            delete(handles(i))
         end
      end
   end

   xlim('auto')
   ylim('auto')
   hold on
   title(strrep(str,'_','\_'));%the extra command inside of title is to deal with underscores
   xlabel('time(sec)')
   ylabel('speed(mph)')
   xlim([0 1]);
   ylim([0 1]);
   if strcmp(str,'TEST_CITY_HWY')
   		text(.1,.8,'This test runs the FTP-75 cycle and then');
       text(.1,.7,'the HWFET cycle and combines the results');
   elseif strcmp(str,'TEST_CITY_HWY_HYBRID')
   		text(.1,.8,'This test runs the FTP-75 cycle and then');
       text(.1,.7,'the HWFET cycle and combines the results for Hybrids');
    elseif strcmp(str,'TEST_FTP')
   		text(.1,.8,'This is the FTP test');
    elseif strcmp(str,'TEST_FTP_HYBRID')
   		text(.1,.8,'This is the FTP test for Hybrids');
    elseif strcmp(str,'TEST_J1711')
       text(.1,.8,'This test runs the SAE J1711 Test Procedure');
       text(.1,.7,'for hybrid vehicles.');
    elseif strcmp(str,'TEST_REAL_WORLD')
       text(.1,.8,'This test runs the Real World Test Procedure');
       text(.1,.7,'intended to capture real-world driving.  Based');
       text(.1,.6,'on CARB study of driving patterns.');
    elseif strcmp(str,'TEST_ACCEL')
       text(.1,.8,'This test runs an Acceleration Test');
    elseif strcmp(str,'TEST_GRADE')
       text(.1,.8,'This test runs a Gradeability Test');

    end
    
   hold off
   
   %update current procedure description
   h2=findobj('tag','current_procedure_text');
   %grab the first comment lines from the file
   try
      fid=fopen([str,'.m']);
      num=0;
      rownum=1; %initialize row number for description
      while feof(fid)==0
         line=fgetl(fid);
         match=findstr(line,'%');
         num=length(match);
         if num>0
            testcondition=1;
            while testcondition>0
               description{rownum,1}=line;
               line=fgetl(fid);
               match=findstr(line,'%');
               testcondition=length(match);
               rownum=rownum+1;
            end
            break
         end   
      end   
      
      
      fclose(fid);
      description=strrep(description,'%','');
      set(h2,'string',description);
      
   end;%try
end;%if test_radiobutton is on

%MULTI CYCLE section
if get(findobj('tag','multi_cycles_radiobutton'),'value')==1
   str='';
   
   %functionality for cycle statistics information 
   set(findobj('tag','time'),'string','n/a')
   set(findobj('tag','distance'),'string','n/a')
   set(findobj('tag','max speed'),'string','n/a')
   set(findobj('tag','avg speed'),'string','n/a')
   set(findobj('tag','max accel'),'string','n/a')
   set(findobj('tag','max decel'),'string','n/a')
   set(findobj('tag','avg accel'),'string','n/a')
   set(findobj('tag','avg decel'),'string','n/a')
   set(findobj('tag','idle time'),'string','n/a')
   set(findobj('tag','no. of stops'),'string','n/a')
   set(findobj('tag','max up grade'),'string','n/a')
   set(findobj('tag','avg up grade'),'string','n/a')
   set(findobj('tag','max dn grade'),'string','n/a')
   set(findobj('tag','avg dn grade'),'string','n/a')
   
   h1=findobj('tag','statistics axes');
   axes(h1)
   cla
   title('')
   
   %plot trace
   h=findobj('tag','simulation_axes');
   axes(h)
   cla
   %delete all axes in simulation figure except for the base one
   handles=findobj(gcf,'type','axes');
   h1=findobj('tag','statistics axes');

   if ~isempty(handles)
      for i=1:length(handles)
         if handles(i)~=h & handles(i)~=h1
            delete(handles(i))
         end
      end
   end

   xlim('auto')
   ylim('auto')
   hold on
   title(strrep(str,'_','\_'));%the extra command inside of title is to deal with underscores
   xlabel('time(sec)')
   ylabel('speed(mph)')
   xlim([0 1]);
   ylim([0 1]);
   
   text(.1,.8,'This runs Multiple Cycles with same initial conditions');
   text(.1,.7,'Use the Multiple Cycles pushbutton for setup');
    
   hold off
   
   %update current procedure description
   h2=findobj('tag','current_procedure_text');
   %grab the first comment lines from the file
   try
      fid=fopen('Multi_Cycles.m');
      num=0;
      rownum=1; %initialize row number for description
      while feof(fid)==0
         line=fgetl(fid);
         match=findstr(line,'%');
         num=length(match);
         if num>0
            testcondition=1;
            while testcondition>0
               description{rownum,1}=line;
               line=fgetl(fid);
               match=findstr(line,'%');
               testcondition=length(match);
               rownum=rownum+1;
            end
            break
         end   
      end   
      
      
      fclose(fid);
      description=strrep(description,'%','');
      set(h2,'string',description);
      
   end;%try
end;%if multi_cycle_radiobutton is on


close(waithandle)



% 7/7/99 ss: corrected spelling error 'intended' was 'intented' (real world test)
% 8/23/99 tm: added statements to build cycle grade vector if not defined
% 9/8/99 ss: added new plotting algorithm to include cyc_grade as a function of distance and time
% 9/9/99 ss: added the legend to include the grade or elevation depending on plot.
% 9/9/99:tm updated elevation_delta calc and elevation initialization
% 7/10/00 ss: changed all 'trace' to 'speed'
% 7/11/00 ss: updated for the statistics info on the simulation setup figure. (including units handling)
% 7/18/00 ss: used isfield where appropriate instead of the eval statement with test4exist
% 7/18/00 ss: added road grade checkbox check and updated workspace before plotting.
% 7/19/00 ss: used cumsum instead of a for loop for elevation calculation.
% 7/21/00 ss: updated elevation, grade vs. time calculations.
% 7/26/00 tm,ss: added and modified grade statistics, now four numbers reported (max_up and max_down grade, avg up and avg down grade)
% 8/10/00 ss: updated the test section to display text on graph for accel and grade test.
% 1/24/01 ss: added multi_cycles section
% 5/16/01 ss: removed setting value=1 for the description listbox.  No longer needed for proper functionality.
% 9/9/03 ss: fixed plotting for grade and cargo mass by loading in distance information for each grade 
%            and cargo mass point into the cyc_mph matrix (only for plotting)