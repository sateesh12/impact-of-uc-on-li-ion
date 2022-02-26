% chkinputs.m
% Displays labelled fuel converter and/or motor efficiency map(s).

if ~exist('fc_description')
   fc_description=' ';
end
if ~exist('gb_description')
   gb_description=' ';
end
if ~exist('mc_description')
   mc_description=' ';
end
if ~exist('ess_description')
   ess_description=' ';
end

chkfc

%%%%%% shift points %%%%%%%%%%%%%%%%%%%%%%%%%%
% if a discrete multi-speed transmission
if (exist('gb_gears_num') & gb_gears_num>1)
   
   
   % plot shift lines
   if exist('gb_gear1_dnshift_spd')
      plot(gb_gear1_dnshift_spd*60/2/pi,gb_gear1_dnshift_load.* ...
         interp1(fc_map_spd,fc_max_trq,gb_gear1_dnshift_spd),'y--')
      plot(gb_gear1_upshift_spd*60/2/pi, gb_gear1_upshift_load.* ...
         interp1(fc_map_spd,fc_max_trq,gb_gear1_upshift_spd),'y--')
   end
   if exist('gb_gear2_dnshift_spd')
      plot(gb_gear2_dnshift_spd*60/2/pi, gb_gear2_dnshift_load.* ...
         interp1(fc_map_spd,fc_max_trq,gb_gear2_dnshift_spd),'m--')
      plot(gb_gear2_upshift_spd*60/2/pi, gb_gear2_upshift_load.* ...
         interp1(fc_map_spd,fc_max_trq,gb_gear2_upshift_spd),'m--')
   end
   if exist('gb_gear3_dnshift_spd')
      plot(gb_gear3_dnshift_spd*60/2/pi, gb_gear3_dnshift_load.* ...
         interp1(fc_map_spd,fc_max_trq,gb_gear3_dnshift_spd),'r--')
      plot(gb_gear3_upshift_spd*60/2/pi, gb_gear3_upshift_load.* ...
         interp1(fc_map_spd,fc_max_trq,gb_gear3_upshift_spd),'r--')
   end
   if exist('gb_gear4_dnshift_spd')
      plot(gb_gear4_dnshift_spd*60/2/pi, gb_gear4_dnshift_load.* ...
         interp1(fc_map_spd,fc_max_trq,gb_gear4_dnshift_spd),'g--')
      plot(gb_gear4_upshift_spd*60/2/pi, gb_gear4_upshift_load.* ...
         interp1(fc_map_spd,fc_max_trq,gb_gear4_upshift_spd),'g--')
   end
   if exist('gb_gear5_dnshift_spd')
      plot(gb_gear5_dnshift_spd*60/2/pi, gb_gear5_dnshift_load.* ...
         interp1(fc_map_spd,fc_max_trq,gb_gear5_dnshift_spd),'c--')
      plot(gb_gear5_upshift_spd*60/2/pi, gb_gear5_upshift_load.* ...
         interp1(fc_map_spd,fc_max_trq,gb_gear5_upshift_spd),'c--')
   end
   
end

%%%%%% fuel converter maps %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% plot engine out CO emissions map and torque envelope
if exist('fc_co_map')&nnz(fc_co_map)>0
   if exist('fc_map_spd')
      figure
      plot(fc_map_spd*30/pi,fc_max_trq*fc_trq_scale,'k-')
      hold on
      plot(fc_map_spd*30/pi,fc_max_trq*fc_trq_scale,'kx')
      c=contour(fc_map_spd*30/pi*fc_spd_scale,fc_map_trq*fc_trq_scale,...
         fc_co_map',8);
      clabel(c)
      ylabel('Engine Torque (Nm)')
      xlabel('Engine Speed (rpm)')
      title(['Engine Out CO Emissions Map (g/s) - ',fc_description])
      set(gcf,'NumberTitle','off','Name','CO Emissions Map')
   else
      % fuel cell info
   end
   
end
%%%%%% plot engine out HC emissions map and torque envelope
if exist('fc_hc_map')&nnz(fc_hc_map)>0
   if exist('fc_map_spd')
      figure
      plot(fc_map_spd*30/pi,fc_max_trq*fc_trq_scale,'k-')
      hold on
      plot(fc_map_spd*30/pi,fc_max_trq*fc_trq_scale,'kx')
      c=contour(fc_map_spd*30/pi*fc_spd_scale,fc_map_trq*fc_trq_scale,...
         fc_hc_map',8);
      clabel(c)
      ylabel('Engine Torque (Nm)')
      xlabel('Engine Speed (rpm)')
      title(['Engine Out HC Emissions Map (g/s) - ',fc_description])
      set(gcf,'NumberTitle','off','Name','HC Emissions Map')
   else
      % fuel cell info
   end
   
end
%%%%%% plot engine out NOx emissions map and torque envelope
if exist('fc_nox_map')&nnz(fc_nox_map)>0
   if exist('fc_map_spd')
      figure
      plot(fc_map_spd*30/pi,fc_max_trq*fc_trq_scale,'k-')
      hold on
      plot(fc_map_spd*30/pi,fc_max_trq*fc_trq_scale,'kx')
      c=contour(fc_map_spd*30/pi*fc_spd_scale,fc_map_trq*fc_trq_scale,...
         fc_nox_map',8);
      clabel(c)
      ylabel('Engine Torque (Nm)')
      xlabel('Engine Speed (rpm)')
      title(['Engine Out NOx Emissions Map (g/s) - ',fc_description])
      set(gcf,'NumberTitle','off','Name','NOx Emissions Map')
   else
      % fuel cell info
   end
   
end;

%%%%%% plot engine out NOx emissions map and torque envelope
if exist('fc_pm_map')&nnz(fc_pm_map)>0
   if exist('fc_map_spd')
      figure
      plot(fc_map_spd*30/pi,fc_max_trq*fc_trq_scale,'k-')
      hold on
      plot(fc_map_spd*30/pi,fc_max_trq*fc_trq_scale,'kx')
      c=contour(fc_map_spd*30/pi*fc_spd_scale,fc_map_trq*fc_trq_scale,...
         fc_pm_map',8);
      clabel(c)
      ylabel('Engine Torque (Nm)')
      xlabel('Engine Speed (rpm)')
      title(['Engine Out PM Emissions Map (g/s) - ',fc_description])
      set(gcf,'NumberTitle','off','Name','NOx Emissions Map')
   else
      % fuel cell info
   end
   
end;

%%%%%% motor map %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('mc_eff_map') | exist('mc_inpwr_map')
   chkmc
end

%% energy storage system
if exist('ess_voc')
   chkess
end;

%% generator controller
if exist('gc_eff_map')&gc_eff_map<1.0
   chkgc
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DISPLAY VEHICLE-LEVEL DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(' ')
disp('                    Vehicle-level data')
disp('                    ------------------')
line1=sprintf('                    Test mass (kg): %0.0f',veh_mass);
line2=sprintf('1st rolling resistance coeff. (--): %0.4f',wh_1st_rrc);
line3=sprintf('2nd rolling resistance coeff. (--): %0.5f',wh_2nd_rrc);
line4=sprintf('   Coeff. of aerodynamic drag (--): %0.4f',veh_CD);
line5=sprintf('                Frontal area (m^2): %0.3f',veh_FA);
disp(line1)
disp(line2)
disp(line3)
disp(line4)
disp(line5)
disp(' ')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 07/06/98 (MC): renamed from inpchk.m;
%                added text output of vehicle-level data
%                enabled motor eff. plotting
% 07/13/98 (MC): modified conditional enabling shift-point plotting to account
%                for CVTs
% 07/14/98 (MC): corrected 'display...' section so that CD and FA are printed
%                with their headers
% 07/14/98 (MC): updated line 88 to avoid division by zero