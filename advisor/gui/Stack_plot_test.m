% ----------------------------------------------------------------
%
% M-file: Stack_plot
%
% 
% Run: Stack_plot(choi)
% choi = 1, vary temperature
% choi = 2, vary pressure
% choi = 3, vary moisture level, same for anode and cathode
% 
%----------------------------------------------------------------------
function [choi] = Stack_plots(choi)

% Initial values
%-----------------
T_ref = 70+273.15;		    % [K]
p_ref = 2/ 1.01325; 		% [bar =>atm]
moist_ref = 0.85;			% Relative humidity [-]

% Initialization
%-------------------
ivec = [0.01:0.05:1.5];		% [A/cm2]
n = 0;		                % index in vectors for each calculated value
m = 0;		                % index in vectors for each calculated value
Vcell=[]; Pcell=[]; eta_ohm=[]; eta_act=[]; var_vec=[]; 
moist =[];Tcell=[];p=[];E=[];eta_fc=[];

% Calculations for variable temperature
%------------------------------------------
if choi == 1
   choi = 'vary temperature';
   Tvec = [5:5:95];	var_vec = Tvec;
   for j = 1:length(Tvec)
      
      m = m + 1;
      n = 0;
      for k = 1:length(ivec)
         
         n = n + 1;
         [icell(n)  Vcell(m,n)  E(m,n)  eta_ohm(m,n)  eta_act(m,n) Tcell(m)  p(m) moist(m) Pcell(m,n) eta_fc(m,n)]=...
            Stack_plot_KTH(ivec(k),Tvec(j),p_ref,moist_ref);
      end 
      FC.Lab.Temperature.Cell=T_ref-273.15;
      FC.Lab.P.a=p_ref*1.013;
      FC.Lab.P.c=p_ref*1.013;
      for k = 1:length(ivec)
          [eta_fcsyst]
      FC.Lab.Temperature.Cell=FC.Lab.Temperature.Cell+k;
      FC.Lab.P.a=FC.Lab.P.a+k;
      FC.Lab.P.c=FC.Lab.P.a+k;
      end
   
   figure(1), clf
   iTV = surf(icell, Tcell ,Vcell);
   xlabel('icell, A/cm2'),ylabel('T, oC'), zlabel('Vcell, V'), title('Cell Voltage, Current Density & Temperature')
   
   figure(2), clf
   iTP = surf(icell, Tcell, Pcell);
   xlabel('icell, [A/cm2]'),ylabel('T, [oC]'), zlabel('Power, [W/cm2]'),title('Power Density, Current Density & Temperature')
   
   figure(3),clf
   iTfc=surf(icell, Tcell, eta_fc);
   xlabel('icell, [A/cm2]'),ylabel('T, [oC]'),zlabel('Eta fc,[-]'),title('Fuel Cell Efficiency, Current Density & Temperature')
   
   figure(4), clf
  iTfcP=surf(Vcell, Pcell, eta_fc);
  xlabel('Vcell, [V]'),ylabel('Power density, [W/cm2]'),zlabel('Eta fc,[-]'), title('Fuel Cell Efficiency, Power Density & Cell Voltage')

end; % choi 1

n = 0; 
m = 0;

% Calculations for variable pressure
%------------------------------------
if choi == 2;
   choi = 'vary pressure';
   
   p_vec =[1:0.25:5]; var_vec = p_vec;
   for j = 1:length(p_vec)
      m = m + 1;
      n = 0;
      for k = 1:length(ivec)
         n = n + 1;
         [icell(n)  Vcell(m,n)  E(m,n)  eta_ohm(m,n)  eta_act(m,n) Tcell(m)  p(m) moist(m) Pcell(m,n) eta_fc(m,n)]=...
            Stack_plot_KTH(ivec(k), T_ref, p_vec(j) , moist_ref);
      end 
   end
 
   
   figure(5), clf
   surf(icell, p ,Vcell)
   xlabel('icell, A/cm2'),ylabel('p, bar'), zlabel('Vcell, V'), title('Springer, RH% = 85, T = 80oC')
   
   figure(6), clf
   surf(icell, p, E)
   xlabel('icell, A/cm2'),ylabel('p, bar'), zlabel('E, V'), title('Springer, RH% = 85, T = 80oC')
   
   figure(13), clf
   surf(icell,  p, eta_ohm)
   xlabel('icell, A/cm2'),ylabel('p, bar'), zlabel('eta_ohm, V'),title('Springer, RH% = 85, T = 80oC')
   
   figure(14), clf
   surf(icell, p, eta_act)
   xlabel('icell, A/cm2'),ylabel('p, bar'), zlabel('eta_act, V'),title('Springer, RH% = 85, T = 80oC')
   
   figure(15), clf
   surf(icell,p, Pcell)
   xlabel('icell, A/cm2'),ylabel('p, bar'), zlabel('Power, W/cm2'), title('Springer, RH% = 85, T = 80oC')
   
   figure(16),clf
   iTfc=surf(icell, p, eta_fc)
   xlabel('icell, [A/cm2]'),ylabel('p, [bar]'),zlabel('Etafc,[-]'),title('Fuel cell efficiency, RH=85%, T= 80oC')
end;	% choi 2

n = 0; 
m = 0;

% Calculations for variable moisture level
%---------------------------------------------
if choi == 3;
   choi = 'vary moisture level';
   
   moist_vec = [0.05:0.05:1]; var_vec = moist_vec;
   for j = 1:length(moist_vec)
      m = m + 1;
      n = 0;
      for k = 1:length(ivec)
         n = n + 1;
         [icell(n)  Vcell(m,n)  E(m,n)  eta_ohm(m,n)  eta_act(m,n) Tcell(m)  p(m) moist(m) Pcell(m,n)]=...
           Stack_plot_KTH(ivec(k), T_ref, p_ref , moist_vec(j));
      end 
   end
   moist = moist * 100; % => percent
   % fprintf(fid,)      
   % fwrite(fid, 
   
   figure(21), clf
   surf(icell, moist, Vcell)
   xlabel('icell, A/cm2'),ylabel('RH%'), zlabel('Vcell, V'), title('Springer, p = 2 bar, T = 70oC')
   
   figure(22), clf
   surf(icell, moist, E)
   xlabel('icell, A/cm2'),ylabel('RH%'), zlabel('E, V'), title('Springer, p = 2 bar, T = 70oC')
   
   figure(23), clf
   surf(icell,  moist, eta_ohm)
   xlabel('icell, A/cm2'),ylabel('RH%'), zlabel('eta_ohm, V'),title('Springer, p = 2 bar, T = 70oC')
   
   figure(24), clf
   surf(icell, moist, eta_act)
   xlabel('icell, A/cm2'),ylabel('RH%'), zlabel('eta_act, V'),title('Springer, p = 2 bar, T = 70oC')
   
   figure(25), clf
   surf(icell, moist, Pcell)
   title('Springer, p = 2 bar, T = 70oC')
   xlabel('icell, A/cm2'),ylabel('RH%'), zlabel('Power, W/cm2')
end;	% choi 3