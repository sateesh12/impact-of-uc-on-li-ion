% script to initialize the fundamentally based model to desired starting SOC, write to dat files, 
% and create a vector of max power output of a battery as a function of SOC
% Note: evaluate script in base workspace to that variables are available and t_soc is saved

%Determine which model to run, how to write to dat files
if strcmp(vinf.energy_storage.name,'ESS_PB16_fund_optima_temp')
   optima=1;
   name='fund_byuop';	%Compiled version for Optima battery- critical parameters are hard coded
else
   optima=0;
   name='fund_byu';		%Compiled version of the generic model
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WRITE TO FILES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Writing dat files for fundamental battery model.');
%names of input files to be read by fortran code: input1.dat, input2.dat, input3.dat, and input4.dat
fi1=fopen('input1.dat','w'); 
fi2=fopen('input2.dat','w');
fi3=fopen('input3.dat','w');
fi4=fopen('input4.dat','w');

% input1.dat: physical parameters
fprintf(fi1,'%g,%g,%g,%g,%g,%g,',ess_aapb,ess_aapbo2,ess_acpb,ess_acpbo2,ess_aopb,ess_aopbo2);
fprintf(fi1,'\n%g,%g,%g,%g,%g,%g,',ess_ecnref,ess_ecpref,ess_fc,ess_pneg,ess_ppos,ess_rgas);
fprintf(fi1,'\n%g,%g,%g,%g,%g,%g,',ess_spb,ess_spbo2,ess_tpb,ess_tpbo2,ess_tsep,ess_tplus);
fprintf(fi1,'\n%g,%g,%g,%g,%g,%g,',ess_vo,ess_ve,ess_vpb,ess_vpbo2,ess_vpbso4,ess_ratio);
fprintf(fi1,'\n%g,%g,%g,%g,%g,',ess_uo2,ess_eco2rf,ess_aao2,ess_aco2,ess_fo2);
fprintf(fi1,'\n%g,%g,%g',ess_uh2,ess_ech2rf,ess_ach2);
fprintf(fi1,'\n%g,%g,%g,%g',ess_c2ref,ess_rkcsatn,ess_rkcsatp,ess_dUdT);

% input2.dat: numerical parameters
fprintf(fi2,'%g,%g,%g,%g,%g,%g,%g,%g,%g',ess_n,ess_npb,ess_npbo2,ess_nsep,ess_relax,ess_theta,ess_gexn,ess_gexp,ess_tstep);

if optima
   % input3.dat: battery characteristics
   fprintf(fi3,'%g,%g,%g,%g,%g,%g,',ess_esep,ess_egass,ess_rtop,ess_ncpmod,ess_nmppk,ess_cap);
else %generic case
   % input3.dat: battery characteristics
   fprintf(fi3,'%g,%g,%g,%g,%g,%g,%g,%g,%g,',ess_cacid,ess_htel,ess_elgel,ess_elpb,ess_elpbo2,ess_elsep,ess_gvolp,ess_gvoln);
   fprintf(fi3,'\n%g,%g,%g,%g,%g,%g,%g,',ess_epb,ess_epbo2,ess_esep,ess_egass,ess_qneg,ess_qpos,ess_rtop);
   fprintf(fi3,'\n%g,%g,%g',ess_ncpmod,ess_nmppk,ess_cap);
end

% input4.dat: limits
fprintf(fi4,'%g,%g,%g',ess_tcurmx,ess_vmax,ess_vmin);

fclose(fi1);
fclose(fi2);
fclose(fi3);
fclose(fi4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Battery Limits (series CS)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pwr_Crate=200; %C rate discharge in W
if optima
   %Maximum power, indexed by ess_max_p_soc
   ess_max_p=[
      0    		 0.0000    0.2000    1.9364    2.6516    3.2941    3.8910,...
      4.4616    4.6223    4.6918    4.7565    4.8176    4.8758    4.9314,...
      4.9849    5.0360    5.0823
   ]*1E3;
   ess_max_p_soc=[
      	0      	 0.0100    0.1222    0.1854    0.2489    0.3128    0.3771,...
         0.4417    0.5058    0.5693    0.6322    0.6947    0.7566    0.8181,...
         0.8791    0.9396    1.0000
   ];
else
   disp('Finding maximum power of battery for fundamental battery model.');
   % The battery model needs to run to obtain these maximum power outputs,
   % given certain limits (dictated by the motor)
   % syntax is [Pwr_r,Pwr_a,Volt,Curr,SOC,HeatGen]=fund_byu(Power, Time, flag status,Temp)
   
   % The max power is used in the series control strategy.
   % Liberal case (discharge at C rate, then require high P from the battery)
   eval([name,'(pwr_Crate,0,0,298);']) %initialize model
   t=0;soc=1;ess_max_p=[]; ess_max_p_soc=[];
   while soc>0.1;
      eval(['sys_maxp=',name,'(10000,t,1,298);']) %find max power available
      soc=sys_maxp(5);
      ess_max_p=[ess_max_p;sys_maxp(2)];	%record output power
      ess_max_p_soc=[ess_max_p_soc;sys_maxp(5)];	%record soc
      t=t+1000; %run at C/5 rate for 1000 sec (approx .06 SOC change)
      eval(['sys=',name,'(pwr_Crate/5,t,1,298);']);
      t=t+1;
      soc=sys(5);
   end
   ess_max_p=[ess_max_p; eps; 0]';	%add zero (or 0.01) soc<=>zero power case
   ess_max_p_soc=[ess_max_p_soc; 0.01; 0]';
   ess_max_p=sort(ess_max_p);
   ess_max_p_soc=sort(ess_max_p_soc);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize Batteries to ess_init_soc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Initializing fundamental battery model.');
dSOC_tol=.001; %tolerance around desired init SOC
if ess_init_soc==1
   eval([name,'(pwr_Crate,0,0,298);']); %call initialization routine
   t_soc=0;				%no offset for ess_init_soc=1
else
   %syntax is [Pwr_r,Pwr_a,Volt,Curr,SOC,HeatGen]=fund_byu(Power, Time, flag status,Temp)
   %initialize battery model [flag=0] (SOC is initialized to 1)
   eval(['sys_soc_init=',name,'(pwr_Crate,0,0,298);']); %call initialization routine
   soc=sys_soc_init(5); %get initial SOC (1)
   
   %guess time to reach initial soc
   t_soc=round(3500*(1-ess_init_soc));
   while soc>ess_init_soc+dSOC_tol | soc<ess_init_soc-dSOC_tol
      eval(['sys_soc_init=',name,'(pwr_Crate,t_soc,1,298);']);
      soc=sys_soc_init(5);
      if soc>ess_init_soc+dSOC_tol
         t_soc=t_soc+5;
      elseif soc<ess_init_soc-dSOC_tol
         eval(['sys_soc_init=',name,'(pwr_Crate,0,0,298);']);
         t_soc=t_soc-5;
      end
   end
end
t_soc=t_soc+1; 	%t_soc is an offset time to yield ess_init_soc at time=0

clear dSOC_tol pwr_Crate soc sys_soc_init;
clear fi1 fi2 fi3 fi4 t soc sys_maxp sys;
%clear consP consSOC libP libP2 libSOC;
disp('Initializations for fundamental battery model complete.  Running simulation.');

%Revision history
% 12/29/98: vhj created file
% 1/22/99: vhj calls most recent file nrel10s with temperature as an input
% 2/03/99: vhj added writing to dat files and max power output from ess_pb_fund
% 4/13/99: vhj updated variables, input files for nrel13cs, 
%					max power calc adjusted (mean of conservative and liberal outputs)
% 4/23/99: vhj updated with nrel14s
% 8/27/99: vhj updated series max p routine to use liberal case
% 9/20/99: vhj different input3.dat file for optima battery choice
%					name (e.g. fund_byu) replacs nrelxxcommand prompt displays.
%					max power already set for optima model
%9/21/99: vhj initialization for optima set--pwr_Crate defined always
%5/29/01: vhj added _temp to name of file referenced