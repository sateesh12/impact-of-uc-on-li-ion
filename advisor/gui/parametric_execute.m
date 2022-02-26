function parametric_execute()

%
% Note: for series vehicles with no gas mileage (the possible case for no SOC correction),
% in order to plot the results, the mpg was taken to be zero. (e.g. line 219)


%%%%%%%%%%%
%Parametric Study for Advisor with 3 possible variables
%%%%%%%%%%%

global vinf;
drivetrain=vinf.drivetrain.name;
numVars=vinf.parametric.number_variables;	%number of variables
total_steps=0;
deltaSOC_tol=vinf.cycle.SOCtol/100;	%tolerance for zero delta SOC correction, given by user in %
max_zero_delta_iter=vinf.cycle.SOCiter;  % maximum number of zero delta soc iterations

%Total number of steps
if numVars==1, final_steps=vinf.parametric.number(1);
elseif numVars==2, final_steps=vinf.parametric.number(1)*vinf.parametric.number(2);
else final_steps=vinf.parametric.number(1)*vinf.parametric.number(2)*vinf.parametric.number(3);
end

%create a waitbar for user
hwait=waitbar(0,'Simulation in progress.  See command window for updates.');	
try
   waitbar(.1)
end

%%%%%%%%%%%%
%single variable parametric study
%%%%%%%%%%%%
if numVars==1	
   %save the original values so that they can be reset after the paramatric run	
   for i=1:numVars
      default(i)=evalin('base',vinf.parametric.var{i});
   end;%for i=1:numVars
   
   for i=1:numVars
      name(i)=vinf.parametric.var(i);
      minimum(i)=vinf.parametric.low(i);
      maximum(i)=vinf.parametric.high(i);
      num(i)=vinf.parametric.number(i);
      
      var(i)=minimum(i);	%initialize parameter to min value
      step(i)=(maximum(i)-minimum(i))/(num(i)-1); %calculate value step size
   end; %i=1:1:1
   final_steps=num(1);
   
   %Loop through all parameter values
   for i1=1:1:num(1)	%loop for parameter 1
      gui_edit_var('modify',name{1},num2str(var(1)))
      
      evalin('base',name{1}) % debug statement
      
      %if acceleration box is checked, run acceleration test
      if strcmp(vinf.acceleration.run,'on')	
         accel_test;	%0-60, 40-60 acceleration test
         Accel_0_60(i1)=evalin('base','accel_time_0_60'); 
         Accel_40_60(i1)=evalin('base','accel_time_40_60');
         Accel_0_85(i1)=evalin('base','accel_time_0_85');
         Feet_5sec(i1)=evalin('base','feet_5sec');
         Max_accel_ft_s2(i1)=evalin('base','max_accel_ft_s2');
      end
      
      %if gradeability box is checked, run gradeability test
      if strcmp(vinf.gradeability.run,'on')	
         Grade(i1)=grade_test(vinf.gradeability.speed); 	%gradeability test at prescribed mph
      end
      
      if strcmp(vinf.cycle.soc,'off')
         gui_run_simulation;		%run basic simulation for chosen cycle, get mileage and emissions
         evalin('base','gui_post_process');
         
      elseif strcmp(vinf.cycle.socmenu,'linear') %linear SOC correction
         evalin('base','ess_init_soc=cs_lo_soc-.01;'); %evaluate low SOC first
         evalin('base','clear mpg hc_gpm co_gpm nox_gpm pm_gpm'); %clear variables left from last run
         gui_run_simulation;
         evalin('base','gui_post_process');
         if evalin('base','exist(''mpg'')')
            mpg(1)=evalin('base','mpg');
            gpm(1)=1/mpg(1);
         else	%for series case with no gas mileage, the gallons per mile is zero
            gpm(1)=0;
         end
         hc(1)=evalin('base','hc_gpm');
         co(1)=evalin('base','co_gpm');
         nox(1)=evalin('base','nox_gpm');
         pm(1)=evalin('base','pm_gpm');
         deltaSOC(1)=evalin('base','ess_soc_hist(end)-ess_soc_hist(1)');
         
         if abs(deltaSOC(1))>deltaSOC_tol %doesn't run another simulation if low init SOC gives zero delta
            %run the simulation with the hi soc value
            evalin('base','ess_init_soc=cs_hi_soc+.01;');
            gui_run_simulation;
            evalin('base','clear mpg hc_gpm co_gpm nox_gpm pm_gpm'); %clear variables left from first run
            evalin('base','gui_post_process');
            if evalin('base','exist(''mpg'')')
               mpg(2)=evalin('base','mpg');
               gpm(2)=1/mpg(2);
            else	%for series case with no gas mileage, the gallons per mile is zero
               gpm(2)=0;
            end
            hc(2)=evalin('base','hc_gpm');
            co(2)=evalin('base','co_gpm');
            nox(2)=evalin('base','nox_gpm');
            pm(2)=evalin('base','pm_gpm');
            deltaSOC(2)=evalin('base','ess_soc_hist(end)-ess_soc_hist(1)');
            
            %interpolate to find value at zero delta soc
            GPMile=interp1(deltaSOC,gpm,0);
            MilesPerG=1/GPMile;
            hc_emis=interp1(deltaSOC,hc,0);
            co_emis=interp1(deltaSOC,co,0);
            nox_emis=interp1(deltaSOC,nox,0);
            pm_emis=interp1(deltaSOC,pm,0);
            
            %assign the linear corrected results in base
            assignin('base','mpg',MilesPerG);
            assignin('base','hc_gpm',hc_emis);
            assignin('base','co_gpm',co_emis);
            assignin('base','nox_gpm',nox_emis);
            assignin('base','pm_gpm',pm_emis);
            
            %if linear did not work because positive delta SOC was not achieved
            if isnan(MilesPerG)
               evalin('base','mpg=0;mpgge=0;hc_gpm=0;co_gpm=0;nox_gpm=0;pm_gpm=0;');
               if evalin('base','warn_index>1')
                  evalin('base','warn_index=warn_index-1;');%overwrite the 'linear is on' warning
               end
               evalin('base','warnings{warn_index}=''SOC correct linear did not work.  Fuel Converter too small to charge batteries on this cycle.'';');
               evalin('base','warn_index=warn_index+1;');
            end
            
         end	%SOC linear case
         
      elseif strcmp(vinf.cycle.socmenu,'zero delta')	%Zero Delta SOC correction
         evalin('base','ess_init_soc=(cs_lo_soc+cs_hi_soc)/2;'); %take the average as the starting point
         clear InitSOC DeltaSOCpar min_positive_index min_negative_index;
         old_pos=0; old_neg=0;
         for i=1:max_zero_delta_iter
            gui_run_simulation; %run the simulation
            InitSOC(i)=evalin('base','ess_init_soc'); %record initial SOC value
            DeltaSOCpar(i)=evalin('base','ess_soc_hist(end)-ess_soc_hist(1)'); %record Delta SOC
            if abs(DeltaSOCpar(i))<deltaSOC_tol	%break the for loop if reach tolerance goal
               disp(['Delta SOC Tolerance of ',num2str(deltaSOC_tol),' met.']);
               disp(['Number of runs: ',num2str(i),', DeltaSOC: ',num2str(DeltaSOCpar(i)),', Initial_SOC: ',num2str(InitSOC(i))]);
               break;
            end %if <tolerance
            
            %reset the initial SOC
            if i>1
               min_index=find(DeltaSOCpar==min(DeltaSOCpar)); %find minimum deltaSOC index
               if DeltaSOCpar(min_index)<0
                  negative_DeltaSOCpar=abs(DeltaSOCpar(DeltaSOCpar<0));
                  min_negative_index=find(DeltaSOCpar==-1*min(negative_DeltaSOCpar));
                  positive_DeltaSOCpar=DeltaSOCpar(DeltaSOCpar>0); %new vector with only positive delta SOC's
                  if ~ isempty(positive_DeltaSOCpar)
                     min_positive_index=find(DeltaSOCpar==min(positive_DeltaSOCpar));
                  end %if ~ isempty
               end %if DeltaSOCpar<0
            end %if i>1
            if exist('min_positive_index') & exist('min_negative_index')
               if min_positive_index~=old_pos | min_negative_index~=old_neg
                  DSOC(1)=DeltaSOCpar(min_negative_index);
                  SOC_init(1)=InitSOC(min_negative_index);
                  DSOC(2)=DeltaSOCpar(min_positive_index);
                  SOC_init(2)=InitSOC(min_positive_index);
                  SOC=interp1(DSOC,SOC_init,0,'linear'); %interpolate to find next starting SOC
                  old_pos=min_positive_index;
                  old_neg=min_negative_index;
               else %case where points closest to zero are not changing
                  min_delta_index=find(abs(DeltaSOCpar)==min(abs(DeltaSOCpar))); %find index for minimum Delta SOC
                  if i~=min_delta_index & sign(DeltaSOCpar(i))==sign(DeltaSOCpar(min_delta_index)) & abs((DeltaSOCpar(i)-DeltaSOCpar(min_delta_index)))<0.01
                     factor=.5/(i-max(min_negative_index,min_positive_index));
                  else
                     factor=.5/(i-max(min_negative_index,min_positive_index));
                  end % if i~=min_delta...
                  SOC=InitSOC(min_positive_index)+factor*(InitSOC(min_negative_index)-InitSOC(min_positive_index));
               end %if min_pos_index..
               
            else %case where only one sign of deltaSOC
               min_delta_index=find(abs(DeltaSOCpar)==min(abs(DeltaSOCpar))); %find index for minimum Delta SOC
               factor=1*(i-min_delta_index+1);
               SOC=InitSOC(min_delta_index)+factor*DeltaSOCpar(min_delta_index);
            end %if exist(min_pos..)
            
            assignin('base','ess_init_soc',SOC); 
            disp(['Run number: ',num2str(i),', DeltaSOC: ',num2str(DeltaSOCpar(i)),', Initial_SOC: ',num2str(InitSOC(i))]);
         end %for loop i=1:10
         
         %pick best run of all runs to display
         min_delta_index=find(abs(DeltaSOCpar)==min(abs(DeltaSOCpar))); %find index for minimum Delta SOC
         if min_delta_index~=i
            assignin('base','ess_init_soc',InitSOC(min_delta_index));
            gui_run_simulation;
         end
         
         evalin('base','gui_post_process');
      end %SOC on (linear or delta) or off
      
      %Record metrics
      if evalin('base',['exist(''mpg'')'])
         MilesPG(i1) = evalin('base','mpg');
         MPGGE(i1) = evalin('base','mpgge');
      else
         MilesPG(i1)=0; %this is for series when no gas mileage exists, set to zero
      end
      if evalin('base',['exist(''ess_soc_hist'')']) & strcmp(vinf.cycle.soc,'off')
         DeltaSOC(i1)=evalin('base','ess_soc_hist(end)')-evalin('base','ess_soc_hist(1)');
      elseif evalin('base',['exist(''ess_soc_hist'')']) & strcmp(vinf.cycle.soc,'on')
         if strcmp(vinf.cycle.socmenu,'zero delta')
            DeltaSOC(i1)=evalin('base','ess_soc_hist(end)')-evalin('base','ess_soc_hist(1)');
         elseif strcmp(vinf.cycle.socmenu,'linear')
            DeltaSOC(i1)=0; %for SOC correct linear, the DeltaSOC is zero
         end
      end
      if evalin('base',['exist(''nox_gpm'')']) %if emissions data exists
         NOx(i1)=evalin('base','nox_gpm'); 
         CO(i1)=evalin('base','co_gpm');
         HC(i1)=evalin('base','hc_gpm');
         PM(i1)=evalin('base','pm_gpm');
      end
      
      var(1)=var(1)+step(1);	%increment parameter
      total_steps=total_steps+1;
      disp(['Steps Completed: ',int2str(total_steps),' out of ',int2str(final_steps)]);
      waitbar(total_steps/final_steps);
   end; %i=1:1:num(1)
   
   %reset the defaults
   for i=1:numVars
      gui_edit_var('modify',vinf.parametric.var{i},num2str(default(i)))
   end;%end for i=1:numVars
   
   %%%%%
   %Two variable parametric study
   %%%%%
elseif numVars==2		
   for i=1:numVars
      default(i)=evalin('base',vinf.parametric.var{i});
   end;%for i=1:numVars
   
   for i=1:numVars
      name(i)=vinf.parametric.var(i);
      minimum(i)=vinf.parametric.low(i);
      maximum(i)=vinf.parametric.high(i);
      num(i)=vinf.parametric.number(i);
      
      var(i)=minimum(i);	%initialize parameter to min value
      step(i)=(maximum(i)-minimum(i))/(num(i)-1); %calculate value step size
   end; %i=1:1:2
   final_steps=num(1)*num(2);	%total number of steps
   
   for i1=1:1:num(1)	%loop for parameter 1

       gui_edit_var('modify',name{1},num2str(var(1)))
      
      evalin('base',name{1}) % debug statement
      
      var(2)=minimum(2);
      for i2=1:1:num(2)		%loop for parameter 2

          gui_edit_var('modify',name{2},num2str(var(2)))
         evalin('base',name{2}) % debug statement
         
         if strcmp(vinf.acceleration.run,'on')	%if acceleration box is checked, run acceleration test
            accel_test;	%0-60, 40-60 acceleration test
            Accel_0_60(i1,i2)=evalin('base','accel_time_0_60'); 
            Accel_40_60(i1,i2)=evalin('base','accel_time_40_60');
            Accel_0_85(i1,i2)=evalin('base','accel_time_0_85');
            Feet_5sec(i1,i2)=evalin('base','feet_5sec');
            Max_accel_ft_s2(i1,i2)=evalin('base','max_accel_ft_s2');
         end
         
         if strcmp(vinf.gradeability.run,'on')	%if gradeability box is checked, run gradeability test
            Grade(i1,i2)=grade_test(vinf.gradeability.speed); 	%gradeability test at prescribed mph
         end
         
         if strcmp(vinf.cycle.soc,'off')
            gui_run_simulation;		%run basic simulation for chosen cycle, get mileage and emissions
            evalin('base','gui_post_process');
            
         elseif strcmp(vinf.cycle.socmenu,'linear') %linear SOC correction
            evalin('base','ess_init_soc=cs_lo_soc-.01;');
            evalin('base','clear mpg hc_gpm co_gpm nox_gpm pm_gpm'); %clear variables left from last run
            gui_run_simulation;
            evalin('base','gui_post_process');
            if evalin('base','exist(''mpg'')')
               mpg(1)=evalin('base','mpg');
               gpm(1)=1/mpg(1);
            else	%for series case with no gas mileage, the gallons per mile is zero
               gpm(1)=0;
            end
            hc(1)=evalin('base','hc_gpm');
            co(1)=evalin('base','co_gpm');
            nox(1)=evalin('base','nox_gpm');
            pm(1)=evalin('base','pm_gpm');
            deltaSOC(1)=evalin('base','ess_soc_hist(end)-ess_soc_hist(1)');
            
            if abs(deltaSOC(1))>deltaSOC_tol %doesn't run another simulation if low init SOC gives zero delta
               %run the simulation with the hi soc value
               evalin('base','ess_init_soc=cs_hi_soc+.01;');
               gui_run_simulation;
               evalin('base','clear mpg hc_gpm co_gpm nox_gpm pm_gpm'); %clear variables left from first run
               evalin('base','gui_post_process');
               if evalin('base','exist(''mpg'')')
                  mpg(2)=evalin('base','mpg');
                  gpm(2)=1/mpg(2);
               else	%for series case with no gas mileage, the gallons per mile is zero
                  gpm(2)=0;
               end
               hc(2)=evalin('base','hc_gpm');
               co(2)=evalin('base','co_gpm');
               nox(2)=evalin('base','nox_gpm');
               pm(2)=evalin('base','pm_gpm');
               deltaSOC(2)=evalin('base','ess_soc_hist(end)-ess_soc_hist(1)');
               
               %interpolate to find value at zero delta soc
               GPMile=interp1(deltaSOC,gpm,0);
               MilesPerG=1/GPMile;
               hc_emis=interp1(deltaSOC,hc,0);
               co_emis=interp1(deltaSOC,co,0);
               nox_emis=interp1(deltaSOC,nox,0);
               pm_emis=interp1(deltaSOC,pm,0);
               
               %assign the linear corrected results in base
               assignin('base','mpg',MilesPerG);
               assignin('base','hc_gpm',hc_emis);
               assignin('base','co_gpm',co_emis);
               assignin('base','nox_gpm',nox_emis);
               assignin('base','pm_gpm',pm_emis);
               
               %if linear did not work because positive delta SOC was not achieved
               if isnan(MilesPerG)
                  evalin('base','mpg=0;mpgge=0;hc_gpm=0;co_gpm=0;nox_gpm=0;pm_gpm=0;');
                  if evalin('base','warn_index>1')
                     evalin('base','warn_index=warn_index-1;');%overwrite the 'linear is on' warning
                  end
                  evalin('base','warnings{warn_index}=''SOC correct linear did not work.  Fuel Converter too small to charge batteries on this cycle.'';');
                  evalin('base','warn_index=warn_index+1;');
               end
            end	%SOC linear case
            
         elseif strcmp(vinf.cycle.socmenu,'zero delta')	%Zero Delta SOC correction
            evalin('base','ess_init_soc=(cs_lo_soc+cs_hi_soc)/2;'); %take the average as the starting point
            clear InitSOC DeltaSOCpar min_positive_index min_negative_index;
            old_pos=0; old_neg=0;
            for i=1:max_zero_delta_iter
               gui_run_simulation; %run the simulation
               InitSOC(i)=evalin('base','ess_init_soc'); %record initial SOC value
               DeltaSOCpar(i)=evalin('base','ess_soc_hist(end)-ess_soc_hist(1)'); %record Delta SOC
               if abs(DeltaSOCpar(i))<deltaSOC_tol	%break the for loop if reach tolerance goal
                  disp(['Delta SOC Tolerance of ',num2str(deltaSOC_tol),' met.']);
                  disp(['Number of runs: ',num2str(i),', DeltaSOC: ',num2str(DeltaSOCpar(i)),', Initial_SOC: ',num2str(InitSOC(i))]);
                  break;
               end %if <tolerance
               
               %reset the initial SOC
               if i>1
                  min_index=find(DeltaSOCpar==min(DeltaSOCpar)); %find minimum deltaSOC index
                  if DeltaSOCpar(min_index)<0
                     negative_DeltaSOCpar=abs(DeltaSOCpar(DeltaSOCpar<0));
                     min_negative_index=find(DeltaSOCpar==-1*min(negative_DeltaSOCpar));
                     positive_DeltaSOCpar=DeltaSOCpar(DeltaSOCpar>0); %new vector with only positive delta SOC's
                     if ~ isempty(positive_DeltaSOCpar)
                        min_positive_index=find(DeltaSOCpar==min(positive_DeltaSOCpar));
                     end %if ~ isempty
                  end %if DeltaSOCpar<0
               end %if i>1
               if exist('min_positive_index') & exist('min_negative_index')
                  if min_positive_index~=old_pos | min_negative_index~=old_neg
                     DSOC(1)=DeltaSOCpar(min_negative_index);
                     SOC_init(1)=InitSOC(min_negative_index);
                     DSOC(2)=DeltaSOCpar(min_positive_index);
                     SOC_init(2)=InitSOC(min_positive_index);
                     SOC=interp1(DSOC,SOC_init,0,'linear'); %interpolate to find next starting SOC
                     old_pos=min_positive_index;
                     old_neg=min_negative_index;
                  else %case where points closest to zero are not changing
                     min_delta_index=find(abs(DeltaSOCpar)==min(abs(DeltaSOCpar))); %find index for minimum Delta SOC
                     if i~=min_delta_index & sign(DeltaSOCpar(i))==sign(DeltaSOCpar(min_delta_index)) & abs((DeltaSOCpar(i)-DeltaSOCpar(min_delta_index)))<0.01
                        factor=.5/(i-max(min_negative_index,min_positive_index));
                     else
                        factor=.5/(i-max(min_negative_index,min_positive_index));
                     end % if i~=min_delta...
                     SOC=InitSOC(min_positive_index)+factor*(InitSOC(min_negative_index)-InitSOC(min_positive_index));
                  end %if min_pos_index..
                  
               else %case where only one sign of deltaSOC
                  min_delta_index=find(abs(DeltaSOCpar)==min(abs(DeltaSOCpar))); %find index for minimum Delta SOC
                  factor=1*(i-min_delta_index+1);
                  SOC=InitSOC(min_delta_index)+factor*DeltaSOCpar(min_delta_index);
               end %if exist(min_pos..)
               
               assignin('base','ess_init_soc',SOC); 
               disp(['Run number: ',num2str(i),', DeltaSOC: ',num2str(DeltaSOCpar(i)),', Initial_SOC: ',num2str(InitSOC(i))]);
            end %for loop i=1:10
            
            %pick best run of all runs to display
            min_delta_index=find(abs(DeltaSOCpar)==min(abs(DeltaSOCpar))); %find index for minimum Delta SOC
            if min_delta_index~=i
               assignin('base','ess_init_soc',InitSOC(min_delta_index));
               gui_run_simulation;
            end
            
            evalin('base','gui_post_process');
         end %SOC on (linear or delta) or off
         
         %Record metrics in base workspace
         if evalin('base','exist(''mpg'')')
            MilesPG(i1,i2) = evalin('base','mpg');
            MPGGE(i1,i2) = evalin('base','mpgge');
         else
            MilesPG(i1,i2)=0; %this is for series when no gas mileage exists, set to zero
         end
         if evalin('base',['exist(''ess_soc_hist'')']) & strcmp(vinf.cycle.soc,'off')
            DeltaSOC(i1,i2)=evalin('base','ess_soc_hist(end)')-evalin('base','ess_soc_hist(1)');
         elseif evalin('base',['exist(''ess_soc_hist'')']) & strcmp(vinf.cycle.soc,'on')
            if strcmp(vinf.cycle.socmenu,'zero delta')
               DeltaSOC(i1,i2)=evalin('base','ess_soc_hist(end)')-evalin('base','ess_soc_hist(1)');
            elseif strcmp(vinf.cycle.socmenu,'linear')
               DeltaSOC(i1,i2)=0; %for SOC correct linear, the DeltaSOC is zero
            end
         end
         if evalin('base',['exist(''nox_gpm'')'])
            NOx(i1,i2)=evalin('base','nox_gpm');
            CO(i1,i2)=evalin('base','co_gpm');
            HC(i1,i2)=evalin('base','hc_gpm');
            PM(i1,i2)=evalin('base','pm_gpm');
         end
         
         var(2)=var(2)+step(2);	%increment parameter
         total_steps=total_steps+1;  %track progress on matlab screen
         disp(['Steps Completed: ',int2str(total_steps),' out of ',int2str(final_steps)]); 
         waitbar(total_steps/final_steps);   
      end; %i2=1:1:num(2)
      var(1)=var(1)+step(1);	%increment parameter
   end; %i1=1:1:num(1)
   %reset the defaults
   for i=1:numVars
      gui_edit_var('modify',vinf.parametric.var{i},num2str(default(i)))
   end;%end for i=1:numVars
   
   %%%%%  
   %Three Variable Parametric Study
   %%%%%   
elseif numVars==3	
   for i=1:numVars
      default(i)=evalin('base',vinf.parametric.var{i});
   end;%for i=1:numVars
   
   for i=1:numVars
      name(i)=vinf.parametric.var(i);
      minimum(i)=vinf.parametric.low(i);
      maximum(i)=vinf.parametric.high(i);
      num(i)=vinf.parametric.number(i);
      
      var(i)=minimum(i);	%initialize parameter to min value
      step(i)=(maximum(i)-minimum(i))/(num(i)-1); %calculate value step size
   end; %i=1:1:3
   final_steps=num(1)*num(2)*num(3);
   
   for i1=1:1:num(1)	%loop for parameter 1
      gui_edit_var('modify',name{1},num2str(var(1)))
      
      evalin('base',name{1}) % debug statement
      
      var(2)=minimum(2);
      for i2=1:1:num(2)	%loop for parameter 2
         gui_edit_var('modify',name{2},num2str(var(2)))
         evalin('base',name{2}) % debug statement
         
         var(3)=minimum(3);
         for i3=1:1:num(3)	%loop for parameter 3
            gui_edit_var('modify',name{3},num2str(var(3)))
            evalin('base',name{3}) % debug statement
            
            if strcmp(vinf.acceleration.run,'on') 	%if acceleration box is checked, run acceleration test
               accel_test;	%0-60, 40-60 acceleration test
               Accel_0_60(i1,i2,i3)=evalin('base','accel_time_0_60'); 
               Accel_40_60(i1,i2,i3)=evalin('base','accel_time_40_60');
               Accel_0_85(i1,i2,i3)=evalin('base','accel_time_0_85');
               Feet_5sec(i1,i2,i3)=evalin('base','feet_5sec');
               Max_accel_ft_s2(i1,i2,i3)=evalin('base','max_accel_ft_s2');
            end
            
            if strcmp(vinf.gradeability.run,'on')	%if gradeability box is checked, run gradeability test
               Grade(i1,i2,i3)=grade_test(vinf.gradeability.speed); 	%gradeability test at prescribed speed mph
            end
            
            if strcmp(vinf.cycle.soc,'off')
               gui_run_simulation;		%run basic simulation for chosen cycle, get mileage and emissions
               evalin('base','gui_post_process');
               
            elseif strcmp(vinf.cycle.socmenu,'linear') %linear SOC correction
               evalin('base','ess_init_soc=cs_lo_soc-.01;');
               evalin('base','clear mpg hc_gpm co_gpm nox_gpm pm_gpm'); %clear variables left from last run
               gui_run_simulation;
               evalin('base','gui_post_process');
               if evalin('base','exist(''mpg'')')
                  mpg(1)=evalin('base','mpg');
                  gpm(1)=1/mpg(1);
               else	%for series case with no gas mileage, the gallons per mile is zero
                  gpm(1)=0;
               end
               hc(1)=evalin('base','hc_gpm');
               co(1)=evalin('base','co_gpm');
               nox(1)=evalin('base','nox_gpm');
               pm(1)=evalin('base','pm_gpm');
               deltaSOC(1)=evalin('base','ess_soc_hist(end)-ess_soc_hist(1)');
               
               if abs(deltaSOC(1))>deltaSOC_tol %doesn't run another simulation if low init SOC gives zero delta
                  %run the simulation with the hi soc value
                  evalin('base','ess_init_soc=cs_hi_soc+.01;');
                  gui_run_simulation;
                  evalin('base','clear mpg hc_gpm co_gpm nox_gpm pm_gpm'); %clear variables left from first run
                  evalin('base','gui_post_process');
                  if evalin('base','exist(''mpg'')')
                     mpg(2)=evalin('base','mpg');
                     gpm(2)=1/mpg(2);
                  else	%for series case with no gas mileage, the gallons per mile is zero
                     gpm(2)=0;
                  end
                  hc(2)=evalin('base','hc_gpm');
                  co(2)=evalin('base','co_gpm');
                  nox(2)=evalin('base','nox_gpm');
                  pm(2)=evalin('base','pm_gpm');
                  deltaSOC(2)=evalin('base','ess_soc_hist(end)-ess_soc_hist(1)');
                  
                  %interpolate to find value at zero delta soc
                  GPMile=interp1(deltaSOC,gpm,0);
                  MilesPerG=1/GPMile;
                  hc_emis=interp1(deltaSOC,hc,0);
                  co_emis=interp1(deltaSOC,co,0);
                  nox_emis=interp1(deltaSOC,nox,0);
                  pm_emis=interp1(deltaSOC,pm,0);
                  
                  %assign the linear corrected results in base
                  assignin('base','mpg',MilesPerG);
                  assignin('base','hc_gpm',hc_emis);
                  assignin('base','co_gpm',co_emis);
                  assignin('base','nox_gpm',nox_emis);
                  assignin('base','pm_gpm',pm_emis);
                  
                  %if linear did not work because positive delta SOC was not achieved
                  if isnan(MilesPerG)
                     evalin('base','mpg=0;mpgge=0;hc_gpm=0;co_gpm=0;nox_gpm=0;pm_gpm=0;');
                     if evalin('base','warn_index>1')
                        evalin('base','warn_index=warn_index-1;');%overwrite the 'linear is on' warning
                     end
                     evalin('base','warnings{warn_index}=''SOC correct linear did not work.  Fuel Converter too small to charge batteries on this cycle.'';');
                     evalin('base','warn_index=warn_index+1;');
                  end
               end	%SOC linear case
               
            elseif strcmp(vinf.cycle.socmenu,'zero delta')	%Zero Delta SOC correction
               evalin('base','ess_init_soc=(cs_lo_soc+cs_hi_soc)/2;'); %take the average as the starting point
               clear InitSOC DeltaSOCpar min_positive_index min_negative_index;
               old_pos=0; old_neg=0;
               for i=1:max_zero_delta_iter
                  gui_run_simulation; %run the simulation
                  InitSOC(i)=evalin('base','ess_init_soc'); %record initial SOC value
                  DeltaSOCpar(i)=evalin('base','ess_soc_hist(end)-ess_soc_hist(1)'); %record Delta SOC
                  if abs(DeltaSOCpar(i))<deltaSOC_tol	%break the for loop if reach tolerance goal
                     disp(['Delta SOC Tolerance of ',num2str(deltaSOC_tol),' met.']);
                     disp(['Number of runs: ',num2str(i),', DeltaSOC: ',num2str(DeltaSOCpar(i)),', Initial_SOC: ',num2str(InitSOC(i))]);
                     break;
                  end %if <tolerance
                  
                  %reset the initial SOC
                  if i>1
                     min_index=find(DeltaSOCpar==min(DeltaSOCpar)); %find minimum deltaSOC index
                     if DeltaSOCpar(min_index)<0
                        negative_DeltaSOCpar=abs(DeltaSOCpar(DeltaSOCpar<0));
                        min_negative_index=find(DeltaSOCpar==-1*min(negative_DeltaSOCpar));
                        positive_DeltaSOCpar=DeltaSOCpar(DeltaSOCpar>0); %new vector with only positive delta SOC's
                        if ~ isempty(positive_DeltaSOCpar)
                           min_positive_index=find(DeltaSOCpar==min(positive_DeltaSOCpar));
                        end %if ~ isempty
                     end %if DeltaSOCpar<0
                  end %if i>1
                  if exist('min_positive_index') & exist('min_negative_index')
                     if min_positive_index~=old_pos | min_negative_index~=old_neg
                        DSOC(1)=DeltaSOCpar(min_negative_index);
                        SOC_init(1)=InitSOC(min_negative_index);
                        DSOC(2)=DeltaSOCpar(min_positive_index);
                        SOC_init(2)=InitSOC(min_positive_index);
                        SOC=interp1(DSOC,SOC_init,0,'linear'); %interpolate to find next starting SOC
                        old_pos=min_positive_index;
                        old_neg=min_negative_index;
                     else %case where points closest to zero are not changing
                        min_delta_index=find(abs(DeltaSOCpar)==min(abs(DeltaSOCpar))); %find index for minimum Delta SOC
                        if i~=min_delta_index & sign(DeltaSOCpar(i))==sign(DeltaSOCpar(min_delta_index)) & abs((DeltaSOCpar(i)-DeltaSOCpar(min_delta_index)))<0.01
                           factor=.5/(i-max(min_negative_index,min_positive_index));
                        else
                           factor=.5/(i-max(min_negative_index,min_positive_index));
                        end % if i~=min_delta...
                        SOC=InitSOC(min_positive_index)+factor*(InitSOC(min_negative_index)-InitSOC(min_positive_index));
                     end %if min_pos_index..
                     
                  else %case where only one sign of deltaSOC
                     min_delta_index=find(abs(DeltaSOCpar)==min(abs(DeltaSOCpar))); %find index for minimum Delta SOC
                     factor=1*(i-min_delta_index+1);
                     SOC=InitSOC(min_delta_index)+factor*DeltaSOCpar(min_delta_index);
                  end %if exist(min_pos..)
                  
                  assignin('base','ess_init_soc',SOC); 
                  disp(['Run number: ',num2str(i),', DeltaSOC: ',num2str(DeltaSOCpar(i)),', Initial_SOC: ',num2str(InitSOC(i))]);
               end %for loop i=1:10
               
               %pick best run of all runs to display
               min_delta_index=find(abs(DeltaSOCpar)==min(abs(DeltaSOCpar))); %find index for minimum Delta SOC
               if min_delta_index~=i
                  assignin('base','ess_init_soc',InitSOC(min_delta_index));
                  gui_run_simulation;
               end
               
               evalin('base','gui_post_process');
            end %SOC on (linear or delta) or off
            
            %Record metrics
            if evalin('base',['exist(''mpg'')'])
               MilesPG(i1,i2,i3) = evalin('base','mpg');
               MPGGE(i1,i2,i3) = evalin('base','mpgge');
            else
               MilesPG(i1,i2,i3)=0; %this is for series when no gas mileage exists, set to zero
            end
            if evalin('base',['exist(''ess_soc_hist'')']) & strcmp(vinf.cycle.soc,'off')
               DeltaSOC(i1,i2,i3)=evalin('base','ess_soc_hist(end)')-evalin('base','ess_soc_hist(1)');
            elseif evalin('base',['exist(''ess_soc_hist'')']) & strcmp(vinf.cycle.soc,'on')
               if strcmp(vinf.cycle.socmenu,'zero delta')
                  DeltaSOC(i1,i2,i3)=evalin('base','ess_soc_hist(end)')-evalin('base','ess_soc_hist(1)');
               elseif strcmp(vinf.cycle.socmenu,'linear')
                  DeltaSOC(i1,i2,i3)=0; %for SOC correct linear, the DeltaSOC is zero
               end
            end
            if evalin('base',['exist(''nox_gpm'')'])
               NOx(i1,i2,i3)=evalin('base','nox_gpm');
               CO(i1,i2,i3)=evalin('base','co_gpm');
               HC(i1,i2,i3)=evalin('base','hc_gpm');
               PM(i1,i2,i3)=evalin('base','pm_gpm');
            end
            
            var(3)=var(3)+step(3); 	%increment parameter
            total_steps=total_steps+1;
            disp(['Steps Completed: ',int2str(total_steps),' out of ',int2str(final_steps)]);
            waitbar(total_steps/final_steps);
         end; %i3=1:1:num(3)
         var(2)=var(2)+step(2);	%increment parameter
      end; %i2=1:1:num(2)	
      var(1)=var(1)+step(1);	%increment parameter
   end; %i1=1:1:num(1)
   %reset the defaults
   for i=1:numVars
      gui_edit_var('modify',vinf.parametric.var{i},num2str(default(i)))
   end;%end for i=1:numVars
end; %numVars=1,2,3

%%%%%%%%%%%%%%%%%%%%%%%%%
%Place Parametric Results into base workspace for future access
%%%%%%%%%%%%%%%%%%%%%%%%%
%Units for metric:
%str={'Litersp100km';'LpkmGE';'DeltaSOC';'NOx';'CO';'HC';'PM';...
%      'Accel_0_97';'Accel_64_97';'Accel_0_137';'Meters_5sec';...
%      'Max_accel_m_s2';['Grade_',num2str(round(vinf.gradeability.speed/0.62137)),'kph'];};

if exist('MilesPG') 
   %U.S.
   assignin('base','MilesPG',MilesPG); 
   assignin('base','MPGGE',MPGGE);
   %Metric
   [si,sj,sk]=size(MilesPG);
   Litersp100km=zeros(size(MilesPG));
   for i=1:si
       for j=1:sj
           for k=1:sk
               %disp(['i:',num2str(i),' j:',num2str(j),' k:',num2str(k)]);
               assignin('base','i',i); 
               assignin('base','j',j); 
               assignin('base','k',k); 
               if MilesPG(i,j,k)>0
                   evalin('base','Litersp100km(i,j,k)=1/1.056710*4*.62137*100./MilesPG(i,j,k);'); 
                   evalin('base','LpkmGE(i,j,k)=1/1.056710*4*.62137*100./MPGGE(i,j,k);'); 
               else
                   evalin('base','Litersp100km(i,j,k)=0;'); 
                   evalin('base','LpkmGE(i,j,k)=0;'); 
               end
           end
       end
   end
end
if exist('DeltaSOC') 
   assignin('base','DeltaSOC',DeltaSOC); 
end
if exist('NOx')
   %U.S.
   assignin('base','NOx',NOx);
   assignin('base','CO',CO);
   assignin('base','HC',HC);
   assignin('base','PM',PM);
   %Metric
   assignin('base','NOx_gpkm',NOx*.62137);
   assignin('base','CO_gpkm',CO*.62137);
   assignin('base','HC_gpkm',HC*.62137);
   assignin('base','PM_gpkm',PM*.62137);
end
if strcmp(vinf.acceleration.run,'on')
   %U.S.
   assignin('base','Accel_0_60',Accel_0_60);
   assignin('base','Accel_40_60',Accel_40_60);
   assignin('base','Accel_0_85',Accel_0_85);
   assignin('base','Feet_5sec',Feet_5sec);
   assignin('base','Max_accel_ft_s2',Max_accel_ft_s2);
   %Metric
   assignin('base','Accel_0_97',Accel_0_60);
   assignin('base','Accel_64_97',Accel_40_60);
   assignin('base','Accel_0_137',Accel_0_85);
   assignin('base','Meters_5sec',Feet_5sec*.3048);
   assignin('base','Max_accel_m_s2',Max_accel_ft_s2*.3048);
end
if strcmp(vinf.gradeability.run,'on')
   %U.S.
   assignin('base',['Grade_',num2str(vinf.gradeability.speed),'mph'],Grade);%variable will be Grade_xxmph where xx is dependent on
   %Metric
   assignin('base',['Grade_',num2str(round(vinf.gradeability.speed/0.62137)),'kph'],Grade);%variable will be Grade_xxmph where xx is dependent on
end

%warnings for zero delta
if strcmp(vinf.cycle.soc,'on')& strcmp(vinf.cycle.socmenu,'zero delta')
   if max(abs(DeltaSOC))<.005
      evalin('base','warnings{warn_index}=''Zero DeltaSOC tolerance of 0.5% met.'';');
   else%tolerance exceeded
      evalin('base',['warnings{warn_index}=''Zero DeltaSOC tolerance of 0.5% not met.  Maximum DeltaSOC was ',num2str(round(1000*(max(abs(DeltaSOC))))/10),'%.'';']);
   end
   evalin('base','warn_index=warn_index+1;');
end

close(hwait);		%close the waitbar
parametric_gui; %pull up the parametric gui interface 

% Revision history
% 7/98-vh, file created
% 8/4/98-valerie updated file
% 8/10/98-valerie, added SOC correction functionality
% 8/10/98-valerie, set deltaSOC to zero for linear SOC correction
% 8/13/98-valerie, clear mpg, emiss. for linear SOC correct before running 2nd time
% 8/13/98-vh, changed SOC algorithm
% 8/13/98-vh, MilesPerG for linear case (avoid variable name conflict
% 8/19/98-vh, DeltaSOCpar for zero delta case (avoid variable name conflict)
% 8/19/98-vh, added zero delta tolerance warning, changed SOC algorithm
% 9/9/98-vh, added warning if linear SOC did not work (mpg, emis set to zero)
% 9/14/98-vh, SOC linear now has top point at hi limit +.01
% 9/16/98-vh, updated all grade_test to grade_test(55) due to grade_test.m changing
% 5/05/99: vhj added PM
% 6/11/99: vhj added mpgge
% 9/20/99: vhj new variables for metric units
% 9/22/99: vhj updated SOC tol and iter to be user defined
% 9/24/99: vhj record mpgge as calculated from gui_post_process (for EV)
% 11/02/99:tm replaced assignin('base',name{1},var{1}) with gui_edit_var('modify',name{1},num2str(var{1}) so that variable relationships are properly handled ie. veh_mass gets updated
% 01/17/01: vhj eliminated 'divide by zero warning' when converting MilesPG to metric Litersp100km
% 02/14/03: ab deleted old commented out code