function str_list=gui_options(name)

%gui_options    ADVISOR list of available gui_options 
%
%str_list=gui_options(name) returns the available options in the vertical
%		cell array {str_list} for a particular item described by the 
%		character string stored in the variable (name)
%
%	name should be one of the following strings:

%
global vinf

switch name
    case 'real world input vars'
       drivetrain=vinf.drivetrain.name;
       evalin('base','load RW_inputvars.mat;');
       if strcmp(drivetrain,'series')
          str_list=evalin('base','str_list_ser');
       elseif strcmp(drivetrain,'parallel')
          str_list=evalin('base','str_list_par');
       elseif strcmp(drivetrain,'conventional')
          str_list=evalin('base','str_list_conv');
       elseif strcmp(drivetrain,'fuel_cell')
          str_list=evalin('base','str_list_fc');
       elseif strcmp(drivetrain,'ev')
          str_list=evalin('base','str_list_ev');
       elseif strcmp(drivetrain,'prius_jpn')
          str_list=evalin('base','str_list_prius');
       end
    case 'real world output vars'
       if strcmp(vinf.units,'us')
          str_list={...
                'cum_soak_dur',...	%vs. pct_trips
                'cum_trip_mi',...	%vs. pct_trips
                'cum_trip_mph',...	%vs. pct_trips
                'cum_starts_perday',...	%vs. pct_days
                'trip_tot_emis_hc',...		%vs. i (trip #)
                'trip_tot_emis_co',...		%vs. i (trip #)
                'trip_tot_emis_nox',...	%vs. i (trip #)
                'trip_tot_emis_pm',...		%vs. i (trip #)
             };
       else
          str_list={...
                'cum_soak_dur',...	%vs. pct_trips
                'cum_trip_km',...	%vs. pct_trips
                'cum_trip_kph',...	%vs. pct_trips
                'cum_starts_perday',...			%vs. pct_days
                'trip_tot_emis_hc_gpkm',...		%vs. i (trip #)
                'trip_tot_emis_co_gpkm',...		%vs. i (trip #)
                'trip_tot_emis_nox_gpkm',...		%vs. i (trip #)
                'trip_tot_emis_pm_gpkm',...		%vs. i (trip #)
             };
       end
       %*****end of input options***************               
otherwise
      str_list='Error';
end

%Revision history
%last modified 5/14/98 by Sam Sprik:  created the function
%					5/22/98 by Sam Sprik:  added options and components
%													and changed some names
%					6/1/98 by Sam Sprik:	  added description and information
%cut trailing blank spaces
% 08/28/98:vh added PTC_EV to list
% 9/14/98:vh, changed battery names
% 2/24/98:tm added heavy vehicle and tech target based files to the lists
% 3/15/99:ss reordered and deleted fc_ci224(now is fc_si224)
% 6/17/99:vhj added real world vars
% 8/6/99: ss removed peukert from input plot list
% 8/26/99:ss added ACC_PRIUS
% 9/16/99: vhj added cum_trip_km and cum_trip_kph to real world output vars
% 9/20/99: vhj added ESS_PB16_fund_optima, ESS_PB16_fund_generic, moved ESS_PB12_nnet
% 9/22/99: vhj added prius var list for real world
% 9/23/99: vhj new options for RW metric, updated EX list (VICC)
% 1/3/00: ss added FC_PRIUS_ANL_DATA
% 1/3/00: tm added 'custom' to drivetrain list and 'GC_ETA100' to generator list
% 1/3/00: ss added ESS_Prius_pack_Temp.m
% 2/2/01: ss updated prius to prius_jpn
% 5/31/00: ss added PTC_PAR_BAL and ESS_LI7
% 7/5/00: ss updated CYC_FUDS to CYC_UDDS
% 7/5/00: ss added CYC_* names CYC_IM240 and CYC_LA92
% 7/5/00: ss added 4 ovonic batteries.  ESS_NIMH28_OVONIC, ESS_NIMH45_OVONIC, ESS_NIMH60_OVONIC, ESS_NIMH90_OVONIC
% 7/5/00: ss added FC_SI63_emis (new file)
% 7/6/00: ss added MC_PM100_UQM motor to list
% 7/11/00:tm added insight and parallel_sa to drivetrain list
% 7/11/00:tm added PTC_PAR_CVT to list
% 7/17/00:ss changed most of the functionality(all except RW items) from gui_options to optionlist.  Most items have been
%         deleted from this file.

