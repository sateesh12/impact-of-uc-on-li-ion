% chkoutputs.m
%
% Defines variables representing component energy loss over the cycle.
% Computes average component efficiency, and displays second-by-second data.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('drivetrain')
   global vinf
   drivetrain=vinf.drivetrain.name;
end
if ~exist('fc_fuel_lhv')
   if gal>eps
      fc_fuel_lhv=input('Enter fuel lower heating value (reference gasoline is 42600 J/g):  ');
   else
      fc_fuel_lhv=42600;
   end
end
if ~exist('fc_description')
   fc_description=' ';
end;
if ~exist('gb_description')
   gb_description=' ';
end;

dt=t(length(t))-t(length(t)-1);	% compute time step using
% last and second-to-last values
% in stored time vector 't'

% if filename is defined and is either bd_s* or bd_p* OR
% there is nonzero motor output torque
if ( exist('filename') & ((filename(1:4)=='bd_s')|(filename(1:4)=='bd_p')) ) ...
      | ( exist('mc_trq_out_a') & (nnz(mc_trq_out_a)>0) )
   hybrid=1;
else
   hybrid=0;
end
% determine whether metric units are desired
eval('temp=vinf.units;,temp_exist=1;','temp_exist=0;')
if temp_exist & strcmp(vinf.units,'metric')
   temp_metric=1;
else
   temp_metric=0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPUTE AND DISPLAY S-BY-S DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% COMPUTE EFFICIENCIES %%%%%%%%%%%%

%%%%%% fc efficiency -------------------
if ~strcmp(drivetrain,'ev')
   if strcmp(drivetrain,'fuel_cell')
      fc_out_W=fc_pwr_out_a;
   else
      try
         fc_out_W=fc_brake_trq.*fc_spd_est;
      catch
         fc_out_W=fc_brake_trq.*fc_spd_out_a;
      end
   end
   galps=diff(gal);
   fc_in_W=[galps;galps(length(galps))]./dt*3.785*fc_fuel_lhv*fc_fuel_den;
   fc_eta=(fc_out_W./(eps+fc_in_W)).*(fc_in_W>eps).*(fc_out_W>0);
end

%%%%%% mc efficiency -------------------
if hybrid & exist('mc_ni_trq_out_a') & exist('mc_spd_est')
   try
      mc_out_W=mc_ni_trq_out_a.*mc_spd_est.*(mc_ni_trq_out_a>0);
   catch
      mc_out_W=mc_ni_trq_out_a.*mc_spd_out_a.*(mc_ni_trq_out_a>0);
   end
   
   mc_in_W=mc_pwr_in_a.*(mc_pwr_in_a>0);
   mc_eta=(mc_out_W./(eps+mc_in_W)).*(mc_in_W>eps).*(mc_out_W>0);
end

%%%%%% gearbox efficiency --------------
if exist('gb_trq_in_a')
   gb_pwr_in_a=gb_trq_in_a.*gb_spd_in_a;
   gb_pwr_out_a=gb_ni_trq_out_a.*gb_spd_out_a;
   gb_eta=(gb_pwr_out_a./(eps+gb_pwr_in_a)).*(gb_trq_in_r>0).*(gb_ni_trq_out_a>0);
end


if exist('ess_pwr_out_a') & exist('ess_pwr_loss_a')
   %%%%%% ess efficiency --------------
   ess_charge_eta=(ess_pwr_out_a+ess_pwr_loss_a)./(ess_pwr_out_a-eps).*(ess_pwr_out_a<0);
   ess_discharge_eta=ess_pwr_out_a./(ess_pwr_out_a+ess_pwr_loss_a+eps).*(ess_pwr_out_a>0);
   
   %%%%%% DISPLAY S-BY-S DATA %%%%%%%%%%%%%
   
   if ~exist('no_plots') % 02/22/00:tm added to prevent plots during TEST_CITY_HWY
      %%%%% ESS -----------
      figure
      plot(t,ess_discharge_eta,'x')
      xlabel('time (s)')
      ylabel('efficiency')
      title('Energy Storage System Efficiency (discharging)')
      set(gcf,'NumberTitle','off','Name','ess discharge eff.')
      figure
      plot(t,ess_charge_eta,'x')
      xlabel('time (s)')
      ylabel('efficiency')
      title('Energy Storage System Efficiency (charging)')
      set(gcf,'NumberTitle','off','Name','ess charge eff.')
   end
   
end

if ~exist('no_plots') % 02/22/00:tm added to prevent plots during TEST_CITY_HWY
   
   %%%%% gearbox --------------------------
   if exist('gb_trq_in_a')
      figure
      plot(t,gb_eta,'x')
      xlabel('time (s)')
      ylabel('efficiency')
      title('Gearbox Efficiency (driving only, not regen)')
      set(gcf,'NumberTitle','off','Name','drivetrain eff.')
   end
   
   %%%%% motor/controller -----------------
   if hybrid & exist('mc_eta')
      figure
      plot(t,mc_eta,'x')
      xlabel('time (s)')
      ylabel('efficiency')
      title('Motor/controller Efficiency (driving only, not regen)')
      set(gcf,'NumberTitle','off','Name','motor/controller eff.')
   end
   
   %%%%%% fuel converter ------------------
   if ~strcmp(drivetrain,'ev')
      figure
      plot(t,fc_eta,'x')
      xlabel('time (s)')
      ylabel('efficiency')
      title('Fuel Converter Efficiency')
      set(gcf,'NumberTitle','off','Name','fuel converter eff.')
   end
   
   %%%%%% trace, shortfall ----------------
   figure
   if temp_metric
      plot(t,(cyc_mph_r-mpha)*units('mph2kmph'))
      ylabel('vehicle speed (km/h)')
   else
      plot(t,cyc_mph_r-mpha)
      ylabel('vehicle speed (mph)')
   end
   xlabel('time (s)')
   title('Difference between requested and achieved speeds')
   set(gcf,'NumberTitle','off','Name','trace shortfall')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPUTE AND DISPLAY AVERAGE COMPONENT EFFICIENCIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% COMPUTE LOSSES AND EFFICIENCIES %

%%%%%% fuel converter ------------------
if ~strcmp(drivetrain,'ev')
   if strcmp(drivetrain,'fuel_cell')
      fc_out_Jmax=trapz(t,fc_pwr_out_a);
   else
      try
         fc_out_Jmax=trapz(t,fc_brake_trq.*fc_spd_est);
      catch
         fc_out_Jmax=trapz(t,fc_brake_trq.*fc_spd_out_a);
      end
      
   end
   %the following lines added temporarily until a method is picked for calculating engine eff
   % mpo 2002-06-04: commenting this out--note: brake torque now includes power to accessories
   % therefore, the calculation below is not correct
%    if exist('acc_mech_pwr_in_a')
%       acc_mech_load_J=trapz(t,acc_mech_pwr_in_a);
%    else
%       acc_mech_load_kj=0;
%    end
%    if strcmp(drivetrain,'fuel_cell') % added to handle fuel cell case, MC 10/8
%       fc_out_Jmax=trapz(t,fc_pwr_out_a);
%    else
%       fc_out_Jmax=trapz(t,fc_trq_out_a.*fc_spd_out_a.*(fc_trq_out_a>0)) + acc_mech_load_J;
%    end
  % end of additional lines
   fc_in_Jmax=max(gal)*3.785*fc_fuel_lhv*fc_fuel_den;
   fc_eta_avg=fc_out_Jmax./(fc_in_Jmax+eps).*(fc_in_Jmax>0);
end

%%%%%% transmission --------------------
if exist('gb_trq_in_a')
   gb_in_Jmax=trapz(t,gb_pwr_in_a.*(gb_pwr_in_a>0));
   gb_out_Jmax=trapz(t,gb_pwr_out_a.*(gb_pwr_out_a>0));
   gb_eta_avg=gb_out_Jmax./gb_in_Jmax;
end
% if a hybrid vehicle configuration, calculate hybrid vehicle-specific results
if hybrid & exist('ess_pwr_loss_a')
   %%%%%% motor efficiency ----------------------
   % mot_pwr_in_a  = actual power at the electrical connections 
   %    (+ive => input to inverter)
   % mot_pwr_out_a = actual mechanical power at the motor shaft 
   %    (+ive => output by motor)
   mot_pwr_in_a=mc_pwr_in_a;
   try
      mot_pwr_out_a=mc_trq_out_a.*mc_spd_est;
   catch
      mot_pwr_out_a=mc_trq_out_a.*mc_spd_out_a;
   end
   
   % inserted to make average motor and motor-as-generator efficiencies agree
   % with Energy Use Figure--overrides 'mc_spd_est' section above
   mot_pwr_out_a=mc_trq_out_a.*mc_spd_out_a;
      
   mot_in_J=trapz(t,mot_pwr_in_a.*(mot_pwr_in_a>0));		% Joules
   mot_out_J=trapz(t,mot_pwr_out_a.*(mot_pwr_out_a>0));
   reg_in_J=-trapz(t,mot_pwr_out_a.*(mot_pwr_out_a<0));
   reg_out_J=-trapz(t,mot_pwr_in_a.*(mot_pwr_in_a<0));
     
   eta_mot=mot_out_J/(mot_in_J+eps)*(mot_in_J>0);
   % motor efficiency when acting as a generator, below
   eta_mot_reg=reg_out_J/(reg_in_J+eps)*(reg_in_J>0); 
   %%%%%% ESS efficiency ------------------------
   % ess_pwr_out_a = actual electrical power output by the energy storage system
   dE_dt_stored=-ess_pwr_out_a-ess_pwr_loss_a;
   into_storage_J=trapz(t,dE_dt_stored.*(dE_dt_stored>0));
   out_of_storage_J=-trapz(t,dE_dt_stored.*(dE_dt_stored<0));
   to_terminals_J=-trapz(t,ess_pwr_out_a.*(ess_pwr_out_a<0));
   from_terminals_J=trapz(t,ess_pwr_out_a.*(ess_pwr_out_a>0));
   % discharge efficiency
   eta_ess_dis=from_terminals_J/(out_of_storage_J+eps)*(out_of_storage_J>0);
   % recharge efficiency
   eta_ess_chg=into_storage_J/(to_terminals_J+eps)*(to_terminals_J>0);		
   eta_ess_rt=eta_ess_dis*eta_ess_chg;			% round-trip efficiency
   
end

%%%%%% vehicle -------------------------------
dist=trapz(t,mpha)/3600;	% miles
if max(gal)>0
   if exist('mpg')
      mpgde=mpg*43000/fc_fuel_lhv*850/fc_fuel_den;   
      mpgge=mpg*42600/fc_fuel_lhv*749/fc_fuel_den;
   else
      mpgde=dist/max(gal)*43000/fc_fuel_lhv*850/fc_fuel_den;
      mpgge=dist/max(gal)*42600/fc_fuel_lhv*749/fc_fuel_den;
   end
else
   mpgde=Inf;
   mpgge=Inf;
end
if strcmp(drivetrain,'ev')
   dE_dt=ess_pwr_out_a+ess_pwr_loss_a; %total power obtained from batteries
   E_J=trapz(t,dE_dt.*(dE_dt>0)); %total energy used from batteries
   E_J=E_J/mean(ess_coulombic_eff); %accounts for coulombic losses
   mpgge=dist/E_J*42600*749/.264172; %42600=lhv of fuel(J/g), 749=density of fuel(g/l), .264172gal/l
end

if exist('emis')
   HCgpmi=trapz(t,emis(:,1)) / dist;
   COgpmi=trapz(t,emis(:,2)) / dist;
   NOxgpmi=trapz(t,emis(:,3)) / dist;
end

%%%%%% DISPLAY EFFICIENCIES %%%%%%%%%%%%%%%%%%
format compact
if temp_metric
   disp('Fuel Consumption: ')
   disp([num2str(units('gpm2lp100km')/mpgde),' L/100 km diesel equivalent'])
   disp([num2str(units('gpm2lp100km')/mpgge),' L/100 km gasoline equivalent'])
   disp(' ')
   
   if exist('emis')&nnz(emis)>0
      disp( 'emissions:    HC    CO    NOx  (g/km)')
      disp(['           ',num2str(HCgpmi/1.609),'  ',num2str(COgpmi/1.609),'  ',...
            num2str(NOxgpmi/1.609)])
   end
else
   disp('Fuel Economy: ')
   disp([num2str(mpgde),' mpg diesel equivalent'])
   disp([num2str(mpgge),' mpg gasoline equivalent'])
   disp(' ')
   
   if exist('emis')&nnz(emis)>0
      disp( 'emissions:    HC    CO    NOx  (g/mi)')
      disp(['           ',num2str(HCgpmi),'  ',num2str(COgpmi),'  ',...
            num2str(NOxgpmi)])
   end
end

eta_storage=[];

if ~strcmp(drivetrain,'ev')
   disp([num2str(fc_eta_avg*100),'%  :ENGINE average efficiency'])
	eta_storage=[eta_storage fc_eta_avg];
end

if exist('gb_trq_in_a')
   disp([num2str(gb_eta_avg*100),'%  :DRIVELINE average efficiency'])
	eta_storage=[eta_storage gb_eta_avg];
end

if hybrid & exist('eta_ess_dis')
   disp([num2str(eta_mot*100),'%  :MOTOR/INVERTER average motoring eff.'])
   disp([num2str(eta_mot_reg*100),'%  :MOTOR/INVERTER average generating eff.'])
   disp([num2str(eta_ess_dis*100),'%  :ESS average discharge eff.'])
   disp([num2str(eta_ess_chg*100),'%  :ESS average recharge eff.',])
   disp([num2str(eta_ess_rt*100),'%  :ESS average round-trip eff.'])
	eta_storage=[eta_storage eta_mot eta_mot_reg eta_ess_dis eta_ess_chg eta_ess_rt];
end

if ~exist('no_plots') % 02/22/00:tm added to prevent plots during TEST_CITY_HWY
   %-----added 10/1/98
   % use to check fuel converter
   if isfield(vinf,'fuel_converter')
      chkfc
   end
   
   %-------------added 10/1/98
   % subroutine to overlay shift diagrams, control strategy, engine efficiency map, and engine operating points
   if (exist('gb_gears_num') & gb_gears_num>1)
      chkshift
   end;
   
   %--------------added 10/1/98
   % use to check generator operation
   if isfield(vinf,'generator')
      chkgc
   end
   
   %------------added 10/1/98
   % use to check motor operation
   if exist('mc_map_spd')
      chkmc
   end
   %---------------------------
end

%-----------added 1/13/99
% use to plot energy usage
%chkpwr;
%-------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLEAN UP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear HCgpmi COgpmi NOxgpmi
clear fc_eta_avg gb_eta_avg
clear eta_mot eta_mot_reg eta_ess_dis eta_ess_chg eta_ess_rt
clear mpgde 
clear dE_dt_stored
clear from_terminals_J out_of_storage_J into_storage_J to_terminals_J
clear mot_out_J mot_in_J reg_out_J reg_in_J
clear gb_out_Jmax gb_in_Jmax
clear fc_out_Jmax fc_in_Jmax
clear gb_pwr_out_a gb_pwr_in_a gb_eta
clear mc_out_W mc_in_W mc_eta
clear fc_out_W fc_in_W fc_eta galps dt
clear hybrid temp*
clear drivetrain


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%05/11/98 (MC):variable names updated to work with A2k
%06/30/98 (MC):transmission and fuel converter efficiency computation changed to
%              ensure only positive values are displayed
%07/06/98 (MC):converted from outpchk.m;
%              motor efficiency measured
%07/13/98 (MC):added CVT variables
%07/16/98 (MC):enabled ESS efficiency calculation;
%              cleaned up intermediary & displayed variables
%07/17/98 (MC):gear ratio is now output instead of gear number
%08/17/98 (tm):added statements to overlay engine efficiency map on operating point map
%08/28/98 (MC):made FC sections work with fc_brake_trq, which does not include
%              inertia torque, rather than fc_trq_out_a, which does
%08/30/98 (MC):limits on ordinate of mc efficiency plot forced to be 0 and 1
%09/01/98 (MC):limits on ordinate of mc efficiency plot made automatic
%09/01/98 (MC):motor torque not including inertia (mc_ni_trq_out_a) used to
%              compute second-by-second efficiency
%09/01/98 (MC):separate references to CVT removed
%09/01/98 (MC):gearbox output torque not including inertia (gb_ni_trq_out_a)
%              used to compute second-by-second efficiency
%9/11/98:vh, fc effic only computed if drivetrain is not ev, effic and operating points plotted if not ev
% 9/11/98:vh, mpgge for ev added
% 9/15/98: included if statement for drivetrain definition to allow command prompt running of ADVISOR, clear drivetrain at end
% 10/15/98:tm chkcontrols incorporated into chkfc, display statement changed
% 10/15/98:tm introduced chkshift file
% 1/13/99:tm introduced chkpwr file
% 8/6/99: ss added if exist statement surrounding gb variables
% 9/16/99:mc removed sections to plot speed traces, emis, and overall gear ratio
%            clear temp* during CLEAN UP (not just temp itself)
% 9/20/99 :ss removed dist and mpgge from clear command.  called the units function for conversion factors.
% 9/23/99;tm modified for fuel cell vars
% 9/24/99:vhj updated ess stuff
% 10/7/99: ss updated engine efficiency calcs temporarily
% 10/8/99: mc added conditional to catch fuel cell case in temp update
% 10/11/99: mc added total motor output power calculation override to make 
%              consistent with Energy Use Figure
% 2/22/00:tm added if ~exist('no_plots') to prevent plots during TEST_CITY_HWY
% 1/31/01:tm updated the mpgge calcs to use mpg if it exists already
% 4/26/02:tm changed conditional on chkfc to if fuel_converter field exists from drivetrain type
% 9/9/02: ab added "exist" statements for outputs not available in Saber co-sim 
