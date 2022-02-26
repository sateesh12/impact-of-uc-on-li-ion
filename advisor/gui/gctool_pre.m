function gctool_pre()
% create *.dat file for gctool

% make vinf global
global vinf

advisor_path=strrep(which('advisor.m'),'\advisor.m','');
gctool_path=vinf.gctool.fullpath(1:end-1);

if ~vinf.gctool.user_defined
   
   % open file for reading and writing
   fid=fopen([advisor_path,'\gctool\gctool_model.dat'],'wt');
   
   % write user input to file
   fprintf(fid,'//***\n//\n');
   fprintf(fid,'double power_req=%.3e;\n',vinf.gctool.dv.value(1));
   
   switch vinf.gctool.model.name
   case 'Hydrogen PEM'
      pem_h2(fid,0);
   case 'Steam Reformed Methanol PEM'
      pem_meth(fid,0);
   case 'POX Reformed Gasoline PEM'
      pem_gas(fid,0);
   otherwise
      disp('ERROR: Unknown fuel cell type.')
   end
   
   % print the task convergence status
   switch vinf.gctool.model.name
   case 'Hydrogen PEM'
      fprintf(fid,'printf("\\ntask_info=%%.0f",task_1.it);\n');
      fprintf(fid,'printf("\\nfc_mass=%%.3e",hx_rej.weight+pefc.weight);\n');
   case 'Steam Reformed Methanol PEM'
      fprintf(fid,'printf("\\ntask_info=%%.0f",task_1.it);\n');
      fprintf(fid,'printf("\\nfc_mass=%%.3e",hx_rej.weight+hx_cool.weight+hx_preh.weight+pefc.weight);\n');
   case 'POX Reformed Gasoline PEM'
      fprintf(fid,'printf("\\ntask_info=%%.0f",task_main.it);\n');
      fprintf(fid,'printf("\\nfc_mass=%%.3e",pefc_1.weight);\n');
   otherwise
      disp('ERROR: Unknown fuel cell type.')
   end
   
   % add advisor results info
   fprintf(fid,'printf("\\n//ADVISOR RESULTS");\n');
   switch vinf.gctool.model.name
   case 'Hydrogen PEM'
      % varied params
      fprintf(fid,'printf("\\ndouble water_tank_t=%%.3e;",water_tank.t);\n');
      fprintf(fid,'printf("\\ndouble water_tank_m=%%.3e;",water_tank.m);\n');
      % component params
      fprintf(fid,'printf("\\ndouble hx_rej_sarea=%%.3e;",hx_rej.surfarea);\n');
      fprintf(fid,'printf("\\ndouble pefc_area=%%.3e;",pefc.area);\n');
   case 'Steam Reformed Methanol PEM'
      % varied params
      fprintf(fid,'printf("\\ndouble wat_q=%%.3e;",wat.q);\n');
      fprintf(fid,'printf("\\ndouble water_tank_t=%%.3e;",water_tank.t);\n');
      fprintf(fid,'printf("\\ndouble sp_fuel_sr=%%.3e;",sp_fuel.sr);\n');
      fprintf(fid,'printf("\\ndouble water_tank_m=%%.3e;",water_tank.m);\n');
      % component params
      fprintf(fid,'printf("\\ndouble hx_preh_sarea=%%.3e;",hx_preh.surfarea);\n');
      fprintf(fid,'printf("\\ndouble hx_cool_sarea=%%.3e;",hx_cool.surfarea);\n');
      fprintf(fid,'printf("\\ndouble hx_rej_sarea=%%.3e;",hx_rej.surfarea);\n');
      fprintf(fid,'printf("\\ndouble cond_1_area=%%.3e;",cond_1.area);\n');
      fprintf(fid,'printf("\\ndouble pefc_area=%%.3e;",pefc.area);\n');
   case 'POX Reformed Gasoline PEM'
      % varied params
      fprintf(fid,'printf("\\ndouble wat_q=%%.3e;",wat.q);\n');
      fprintf(fid,'printf("\\ndouble wat_m=%%.3e;",wat.m);\n');
      fprintf(fid,'printf("\\ndouble water_tank_t=%%.3e;",water_tank.t);\n');
      % component params
      fprintf(fid,'printf("\\ndouble hx_air_sarea=%%.3e;",hx_air.surfarea);\n');
      fprintf(fid,'printf("\\ndouble hx_cool_sarea=%%.3e;",hx_cool.surfarea);\n');
      fprintf(fid,'printf("\\ndouble hx_rej_sarea=%%.3e;",hx_rej.surfarea);\n');
      fprintf(fid,'printf("\\ndouble hx_vap_sarea=%%.3e;",hx_vap.surfarea);\n');
      fprintf(fid,'printf("\\ndouble hx_wat_sarea=%%.3e;",hx_wat.surfarea);\n');
      fprintf(fid,'printf("\\ndouble hx_cond_sarea=%%.3e;",hx_cond.surfarea);\n');
      fprintf(fid,'printf("\\ndouble pefc_1_area=%%.3e;",pefc_1.area);\n');
   otherwise
      disp('ERROR: Unknown fuel cell type.')
   end
   
   fclose(fid);
   
   str=[advisor_path,'\gui\GCToolsBatch.exe',' ',gctool_path,' ',advisor_path,'\gctool\gctool_model.dat',' ',advisor_path,'\gctool\gctool_model.out'];
   state=0;
   %eval(['[state,msg]=dos(''',str,''');']);
   state=execute(str);
   
   if ~state
      fid=fopen([advisor_path,'\gctool\gctool_model.out'],'rt');
      while ~feof(fid)
         str=fgets(fid);
         eff_section=findstr(str,'efflhv=');
         task_section=findstr(str,'task_info=');
         mass_section=findstr(str,'fc_mass=');
         advisor_results_section=findstr(str,'ADVISOR')&findstr(str,'RESULTS');
         if ~isempty(advisor_results_section)
            i=0;
            str={};
            while ~feof(fid)
               i=i+1;
               str{i}=fgets(fid);
            end
         elseif ~isempty(eff_section)
            x1=findstr(str,'efflhv=')+7;
            vinf.gctool.peak_eff=str2num(str(x1:end));
         elseif ~isempty(mass_section)
            x1=findstr(str,'fc_mass=')+8;
            vinf.gctool.fc_mass=str2num(str(x1:end));
         elseif ~isempty(task_section)
            x1=findstr(str,'task_info=')+10;
            task_flag=str2num(str(x1:end));
            if task_flag~=1000
               h=warndlg('Error: GCtool did not converge');
               uiwait(h);
               fclose(fid);
               return
               disp('Error: GCtool did not converge')
            end
         end
      end
      if fid<=0
         disp('Error: unable to open output file')
      else
         fclose(fid);
      end
      
      % open file for reading and writing
      fid=fopen([advisor_path,'\gctool\gctool_model.dat'],'wt');
      
      % write user input to file
      fprintf(fid,'//***\n//\n');
      fprintf(fid,'double power_req=%.3e;\n',vinf.gctool.dv.value(1));
      
      % write design mode results to file
      for i=1:length(str)
         fprintf(fid,[str{i}]);
      end
      
      % write original dat file
      switch vinf.gctool.model.name
      case 'Hydrogen PEM'
         pem_h2(fid,1);
      case 'Steam Reformed Methanol PEM'
         pem_meth(fid,1);
      case 'POX Reformed Gasoline PEM'
         pem_gas(fid,1);
      otherwise
         disp('ERROR: Unknown fuel cell type.')
      end
      
      % add advisor results info
      fprintf(fid,'printf("\\n");\n');
      fprintf(fid,'printf("\\nADVISOR RESULTS");\n');
      
      switch vinf.gctool.model.name
      case 'Hydrogen PEM'
         fprintf(fid,'printf("\\nfuel_m=%%.3e;",fuel.fl.m);\n');
         fprintf(fid,'printf("\\npwr_out_a=%%.3e;",pows.prod-pows.cons);\n');
         fprintf(fid,'printf("\\ntask_info=%%.3e;",task_1.it);\n');
      case 'Steam Reformed Methanol PEM'
         fprintf(fid,'printf("\\nfuel_m=%%.3e;",fuel.fl.m);\n');
         fprintf(fid,'printf("\\npwr_out_a=%%.3e;",pows.prod-pows.cons);\n');
         fprintf(fid,'printf("\\ntask_info=%%.3e;",task_1.it);\n');
      case 'POX Reformed Gasoline PEM'
         fprintf(fid,'printf("\\nfuel_m=%%.3e;",fuel.fl.m);\n');
         fprintf(fid,'printf("\\npwr_out_a=%%.3e;",pows.prod-pows.cons);\n');
         fprintf(fid,'printf("\\ntask_info=%%.3e;",task_main.it);\n');
      otherwise
         disp('ERROR: Unknown fuel cell type.')
      end
      
      fclose(fid);
   else
      disp('ERROR: GCtool run failed.')
   end
   
else
   % open file for reading
   fid=fopen([vinf.gctool.filename_path,vinf.gctool.filename],'rt')
   
   i=0;
   str={};
   while ~feof(fid)
      i=i+1;
      str{i}=fgets(fid);
   end
   fclose(fid);
   
   % open file for writing
   fid=fopen([advisor_path,'\gctool\gctool_model.dat'],'wt');
   
   % write user input to file
   %fprintf(fid,'//***\n//\n');
   %fprintf(fid,'double power_req=%.3e;\n',vinf.gctool.dv.value(1));
   
   % write original file
   i=0;
   while i<length(str)
      i=i+1;
      % make sure pows function is called and mfrac constraint exists
      %if findstr(str{i},'cons(')
      %   fprintf(fid,'pows.c;\n');
      %   fprintf(fid,'cons(mfrac,pows.prod-pows.cons-power_req)\n');
      %end
      str{i}=strrep(str{i},'\n','\\n');
      str{i}=strrep(str{i},'%','%%');
      fprintf(fid,str{i});
   end
   
   % add advisor results info
   fprintf(fid,'printf("\\n");\n');
   fprintf(fid,'printf("\\nADVISOR RESULTS");\n');
   %fprintf(fid,'gass.sat(fuel.fl,hl,hv);');
   %fprintf(fid,'\n');
   %fprintf(fid,'gass.hv(fuel.fl,lhv,hhv); ');
   %fprintf(fid,'\n');
   %fprintf(fid,'heatinlhv=fuel.fl.m*(hl-hv+lhv);');
   %fprintf(fid,'\n');
   fprintf(fid,'printf("\\nfuel_lhv=%%.3e;",heatinlhv);\n');
   fprintf(fid,'printf("\\nfuel_den=%%.3e;",fuel.fl.r);\n');
   %fprintf(fid,'efflhv=(pows.prod-pows.cons)/heatinlhv;');
   %fprintf(fid,'\n');
   fprintf(fid,'printf("\\npeak_eff=%%.3e;",efflhv);\n');
   fprintf(fid,'printf("\\npwr_out_a=%%.3e;",pows.prod-pows.cons);\n');
   % close file
   fclose(fid);
   
   str=[advisor_path,'\gui\GCToolsBatch.exe',' ',gctool_path,' ',advisor_path,'\gctool\gctool_model.dat',' ',advisor_path,'\gctool\gctool_model.out'];
   state=0;
   state=execute(str);
   %eval(['[state,msg]=dos(''',str,''');']);

   fid=fopen([advisor_path,'\gctool\gctool_model.out'],'rt');
   while fid>0&~feof(fid)
      str=fgets(fid);
      advisor_results_section=findstr(str,'ADVISOR')&findstr(str,'RESULTS');
      if advisor_results_section
         while ~feof(fid)
            str=fgets(fid);
            if findstr(str,'fuel_lhv')
               x1=findstr(str,'=')+1;
               x2=findstr(str,';')-1;
               fuel_lhv=str2num(str(x1:x2));
            elseif findstr(str,'fuel_den')   
               x1=findstr(str,'=')+1;
               x2=findstr(str,';')-1;
               fuel_den=str2num(str(x1:x2));
            elseif findstr(str,'peak_eff')   
               x1=findstr(str,'=')+1;
               x2=findstr(str,';')-1;
               peak_eff=str2num(str(x1:x2));
            elseif findstr(str,'pwr_out_a')   
               x1=findstr(str,'=')+1;
               x2=findstr(str,';')-1;
               peak_pwr=str2num(str(x1:x2));
            end
            if exist('fuel_den')&exist('fuel_lhv')&exist('peak_eff')&exist('peak_pwr')
               vinf.gctool.fuel_den=fuel_den;
               vinf.gctool.fuel_lhv=fuel_lhv;
               vinf.gctool.peak_eff=peak_eff;
               vinf.gctool.dv.value(1)=peak_pwr;
               break;
            end
         end
      end
   end
   if fid<=0
      disp('ERROR: unable to open file');
   else
      fclose(fid);
   end
   
   % open file for reading
   fid=fopen([vinf.gctool.filename_path,vinf.gctool.filename],'rt');
   i=0;
   str={};
   while ~feof(fid)
      i=i+1;
      str{i}=fgets(fid);
   end
   fclose(fid);
   
   % open file for writing
   fid=fopen([advisor_path,'\gctool\gctool_model.dat'],'wt');
   
   % write user input to file
   %fprintf(fid,'//***\n//\n');
   %fprintf(fid,'double power_req=%.3e;\n',vinf.gctool.dv.value(1));
   
   % write original file
   i=0;
   while i<length(str)
      i=i+1;
      % make sure pows function is called and mfrac constraint exists
      %if findstr(str{i},'cons(')
      %   fprintf(fid,'pows.c;\n');
      %   fprintf(fid,'cons(mfrac,pows.prod-pows.cons-power_req)\n');
      %end
      str{i}=strrep(str{i},'\n','\\n');
      str{i}=strrep(str{i},'%','%%');
      fprintf(fid,str{i});
   end
   
   % add advisor results info
   fprintf(fid,'printf("\\n");\n');
   fprintf(fid,'printf("\\nADVISOR RESULTS");\n');
   fprintf(fid,'printf("\\nfuel_m=%%.3e;",fuel.fl.m);\n');
   fprintf(fid,'printf("\\npwr_out_a=%%.3e;",pows.prod-pows.cons);\n');
   
   % close file
   fclose(fid);
end

disp('GCtool *.dat file created.')

return

function pem_h2(fid,mode)
%fprintf(fid,'//*********************************************************************************');
%fprintf(fid,'\n');
%fprintf(fid,'// simple pem system with pure hydrogen as fuel');
%fprintf(fid,'\n');
%fprintf(fid,'//');
%fprintf(fid,'\n');
fprintf(fid,'modstack mods={conffile="tmp/pem_h2.conf";};');
fprintf(fid,'\n');
fprintf(fid,'gas air={id="GAS", t=300, p=1.0, m=4.989e-3*28.0, v=20.0, comp[O2]=0.21, comp[N2]=0.79, humid=0.5;};');
fprintf(fid,'\n');
fprintf(fid,'gas fuel={id="GAS", t=300.0,  p=2.0,  m=0.33e-3*32.042, v=20.0,  comp[H2]=1.0;};');
fprintf(fid,'\n');
fprintf(fid,'gas air_rej={id="GAS", t=300, p=1.0, m=5.0, v=5.0, comp[O2]=0.21, comp[N2]=0.79, humid=0.5;};');
fprintf(fid,'\n');
fprintf(fid,'gas air_int={id="GAS", t=300, p=1.0, m=1.0, v=5.0, comp[O2]=0.21, comp[N2]=0.79, humid=0.5;};');  
fprintf(fid,'\n');
fprintf(fid,'pump pump_water={pres=2.0, eff=0.75;};');
fprintf(fid,'\n');
fprintf(fid,'gas wat={id="STM", t=0.0, q=0.45, p=2.0, m=0.4e-3*18, v=5.0, comp[H2O]=1.0;};');
fprintf(fid,'\n');
fprintf(fid,'gas water_tank={id="STM", t=323, p=1.0, m=0.627, v=5.0, comp[H2O]=1.0;};');
fprintf(fid,'\n');
fprintf(fid,'gas h2o={id="STM", comp[H2O]=1.0;};');
fprintf(fid,'\n');
fprintf(fid,'gas h2oa={id="STM", comp[H2O]=1.0;};');
fprintf(fid,'\n');
fprintf(fid,'hx  hx_rej={t_hot=323, ufc=30;};');
fprintf(fid,'\n');
fprintf(fid,'sp  sp_h2o={sr=-1, ssr[H2Oc]=1.0;};');
fprintf(fid,'\n');
fprintf(fid,'sp  sp_cond={sr=-1, ssr[H2Oc]=1.0;};');
fprintf(fid,'\n');
fprintf(fid,'mx  mx_cond, mx_h2o;');
fprintf(fid,'\n');
fprintf(fid,'gt gt_1={mode="d", pres=1.0, eff=0.80;};');
fprintf(fid,'\n');
fprintf(fid,'cp cp_air={mode="d", pres=3.0, eff=0.80, nstages=2;};');
fprintf(fid,'\n');
fprintf(fid,'cp fan_int={pres=1.005, eff=0.80;};');
fprintf(fid,'\n');
fprintf(fid,'cp fan_rej={pres=1.005, eff=0.80;};');
fprintf(fid,'\n');
fprintf(fid,'cp cp_anode={pres=3.0, eff=0.80;};'); 
fprintf(fid,'\n');
fprintf(fid,'pem pefc={mode="d", curden=0.575, celltemp=353, fuelutil=1.00, option="ms";};');
fprintf(fid,'\n');
fprintf(fid,'task task_1={acc=1e-3, prt=2, del=1e-4, maxit=15;};'); 
fprintf(fid,'\n');
fprintf(fid,'gass.noform[CH4]=1.0; gass.noform[CH3OH]=1.0; gass.noform[C8H18]=1; gass.prt=0;');
fprintf(fid,'\n');
fprintf(fid,'double heatinhhv,heatinlhv,effhhv,efflhv,lhv,hhv,mfrac=0.8650861,prod;'); 
fprintf(fid,'\n');
fprintf(fid,'gass.lowtemp = 1.0000e+02;  mfrac=0.7314398;');
fprintf(fid,'\n');
if mode
   % override design mode settings   
   fprintf(fid,'\n');
   fprintf(fid,'//override design mode settings');
   fprintf(fid,'\n');
   fprintf(fid,'pefc.mode="u";');
   fprintf(fid,'\n');
   fprintf(fid,'hx_rej.mode="o";');
   fprintf(fid,'\n');
   fprintf(fid,'pefc.area=pefc_area;');
   fprintf(fid,'\n');
   fprintf(fid,'hx_rej.surfarea=hx_rej_sarea;');
   fprintf(fid,'\n');
   fprintf(fid,'water_tank.t=water_tank_t;');
   fprintf(fid,'\n');
   fprintf(fid,'water_tank.m=water_tank_m;');
   fprintf(fid,'\n');
   fprintf(fid,'task_1.prt=0;');
   fprintf(fid,'\n');
end
fprintf(fid,'\n');
fprintf(fid,'while (task_1.c)');
fprintf(fid,'\n');
fprintf(fid,'  {');
fprintf(fid,'\n');
if ~mode
   fprintf(fid,'   vary(water_tank.m, 0.929, 0.03,2.5);');
   fprintf(fid,'\n');
   fprintf(fid,'   vary(water_tank.t, 323.96, 300, 600);');
   fprintf(fid,'\n');
end
fprintf(fid,'   vary(mfrac, 0.847, 0.05, 1.2);');
fprintf(fid,'\n');
fprintf(fid,'  '); 
fprintf(fid,'\n');
fprintf(fid,'   fuel.m=mfrac*0.8648e-3*2.0;');
fprintf(fid,'\n');
fprintf(fid,'   air.m=1.06*mfrac*4.000e-3*28.0;');
fprintf(fid,'\n');
fprintf(fid,'   hx_rej.t_hot=water_tank.t;');
fprintf(fid,'\n');
fprintf(fid,'   ');   
fprintf(fid,'\n');
fprintf(fid,'   fuel.c;  pefc.ain;');
fprintf(fid,'\n');
fprintf(fid,'   air.c; cp_air.c; pefc.c; sp_h2o.c; gt_1.c; sp_cond.c;'); 
fprintf(fid,'\n');
fprintf(fid,'   sp_h2o.s; h2o.cont; mx_h2o.s;');
fprintf(fid,'\n');
fprintf(fid,'   water_tank.c; pump_water.c; pefc.cool; mx_h2o.c;');
fprintf(fid,'\n');
fprintf(fid,'   hx_rej.h; mx_cond.s;'); 
fprintf(fid,'\n');
fprintf(fid,'   sp_cond.s; h2oa.cont; mx_cond.c; water_tank.cycl;');
fprintf(fid,'\n');
fprintf(fid,'   air_int.c; fan_int.c; cp_air.cool;');
fprintf(fid,'\n');
fprintf(fid,'   air_rej.c; fan_rej.c; hx_rej.c;');
fprintf(fid,'\n');
fprintf(fid,'   pows.c;');
fprintf(fid,'\n');
fprintf(fid,'   prod=pows.prod-pows.cons;');
fprintf(fid,'\n');
if ~mode
   fprintf(fid,'   cons(water_tank.m, pefc.flcool.t-348.0);');
   fprintf(fid,'\n');
   fprintf(fid,'   cons(water_tank.t, water_tank.fl.t-gt_1.fl.t);');
   fprintf(fid,'\n');
end
fprintf(fid,'   cons(mfrac, pows.prod-pows.cons-power_req);');
fprintf(fid,'\n');
fprintf(fid,'  }');
fprintf(fid,'\n');
fprintf(fid,'mods.print; gass.print; gass.mprint; pows.print; // mods.rdat;');
fprintf(fid,'\n');
fprintf(fid,'gass.hv(fuel.fl,lhv,hhv);');
fprintf(fid,'\n');
fprintf(fid,'heatinhhv=fuel.fl.m*hhv;');
fprintf(fid,'\n');
fprintf(fid,'effhhv=(pows.prod-pows.cons)/heatinhhv;');
fprintf(fid,'\n');
fprintf(fid,'heatinlhv=fuel.fl.m*lhv;');
fprintf(fid,'\n');
fprintf(fid,'efflhv=(pows.prod-pows.cons)/heatinlhv;');
fprintf(fid,'\n');
fprintf(fid,'printf("\\nprod=%%.3e",prod);');
fprintf(fid,'\n');
fprintf(fid,'printf("\\nhhv=%%.3e lhv=%%.3e ",hhv,lhv);');
fprintf(fid,'\n');
fprintf(fid,'printf("\\nheatinhhv=%%.3e effhhv=%%.3e \\nheatinlhv=%%.3e efflhv=%%.3e", heatinhhv,effhhv,heatinlhv,efflhv);');
fprintf(fid,'\n');
fprintf(fid,'\n');
return
function pem_meth(fid,mode)
%fprintf(fid,'//*********************************************************');
%fprintf(fid,'\n');
%fprintf(fid,'//  simple methanol steam reform PEM system');
%fprintf(fid,'\n');
%fprintf(fid,'//');
%fprintf(fid,'\n');
fprintf(fid,'modstack mods={conffile="tmp/pemmsf.conf";');
fprintf(fid,'\n');
fprintf(fid,'  caption="Simple methanol steam reformed\\nPEM fuel cell system";};');
fprintf(fid,'\n');
fprintf(fid,'gas air={id="GAS"; t=300, p=1.0, m=4.989e-3*28.0, v=20.0, comp[O2]=0.21, comp[N2]=0.79, humid=0.5;};');
fprintf(fid,'\n');
fprintf(fid,'gas fuel={id="THR-CH4O", t=300.0,  p=1.0, m=0.33e-3*32.042, v=20.0, comp[CH3OH]=1.0, frozen=1;};');
fprintf(fid,'\n');
fprintf(fid,'gas air_cond={id="GAS", t=300, p=1.0, m=1.0, v=5.0, comp[O2]=0.21, comp[N2]=0.79, humid=0.5;};');  
fprintf(fid,'\n');
fprintf(fid,'gas air_rej={id="GAS", t=300, p=1.0, m=5.0, v=5.0, comp[O2]=0.21, comp[N2]=0.79, humid=0.5;};'); 
fprintf(fid,'\n');
fprintf(fid,'gas air_int={id="GAS", t=300, p=1.0, m=1.0, v=5.0, comp[O2]=0.21, comp[N2]=0.79, humid=0.5;};  ');
fprintf(fid,'\n');
fprintf(fid,'gas ch3oh={id="GAS", comp[CH3OH]=1.0;};');
fprintf(fid,'\n');
fprintf(fid,'pump pump_fuel={pres=3.0, eff=0.75;};');  
fprintf(fid,'\n');
fprintf(fid,'pump pump_water={pres=2.0, eff=0.75;};');
fprintf(fid,'\n');
fprintf(fid,'gas wat={id="STM", t=0.0, q=0.45, p=2.0, m=0.4e-3*18, v=5.0, comp[H2O]=1.0;};');
fprintf(fid,'\n');
fprintf(fid,'gas water_tank={id="STM", t=323, p=1.0, m=0.627, v=5.0, comp[H2O]=1.0;};');
fprintf(fid,'\n');
fprintf(fid,'gas h2o={id="STM", comp[H2O]=1.0;};');
fprintf(fid,'\n');
fprintf(fid,'hx  hx_preh={t_cold=343, ufh=1000;};');
fprintf(fid,'\n');
fprintf(fid,'hx  hx_rej={t_hot=323, ufc=30, ufh=1000;};');
fprintf(fid,'\n');
fprintf(fid,'hx  hx_cool={t_hot=353, ufh=30.0, ufh=1000;};');
fprintf(fid,'\n');
fprintf(fid,'sp  sp_air={sr=0.26719; sr=0.16;};');
fprintf(fid,'\n');
fprintf(fid,'sp  sp_prox={sr=1.0-0.063/3.656;};');
fprintf(fid,'\n');
fprintf(fid,'sp  sp_wat;');
fprintf(fid,'\n');
fprintf(fid,'sp  sp_shif={sr=0.0256/1.0256; sr=0.07;};');
fprintf(fid,'\n');
fprintf(fid,'sp  sp_fuel={sr=0.0;};');
fprintf(fid,'\n');
fprintf(fid,'sp  sp_anode={sr=0.0;};');
fprintf(fid,'\n');
fprintf(fid,'sp  sp_h2o={sr=-1, ssr[H2Oc]=1.0;};');
fprintf(fid,'\n');
fprintf(fid,'mx  mx_burn, mx_fuel,  mx_cath, mx_shif, mx_prox, mx_cond, mx_anode, mx_h2o={};');
fprintf(fid,'\n');
fprintf(fid,'cond cond_1={texit=323.0, u=15.0;};');
fprintf(fid,'\n');
fprintf(fid,'gt gt_1={mode="d", pres=1.0, eff=0.80;};');
fprintf(fid,'\n');
fprintf(fid,'cp cp_air={mode="d", pres=3.0, eff=0.80, nstages=2;};');
fprintf(fid,'\n');
fprintf(fid,'cp cp_anode={pres=3.0, eff=0.80;};');  
fprintf(fid,'\n');
fprintf(fid,'cp fan_cond={pres=1.005, eff=0.80;};');
fprintf(fid,'\n');
fprintf(fid,'cp fan_int={pres=1.005, eff=0.80;};');
fprintf(fid,'\n');
fprintf(fid,'cp fan_rej={pres=1.005, eff=0.80;};'); 
fprintf(fid,'\n');
fprintf(fid,'reform form={texit=523.15;};');
fprintf(fid,'\n');
fprintf(fid,'pem pefc={mode="d", curden=0.575, curden=0.7; area=19.116, celltemp=353, fuelutil=0.90; option="vs"; voltact=0.7;};');
fprintf(fid,'\n');
fprintf(fid,'task task_1={acc=1e-3, prt=2, del=1e-4, maxit=15;};');
fprintf(fid,'\n');
fprintf(fid,'gass.noform[CH4]=1; gass.noform[CH3OH]=1; gass.noform[CH3OHc]=0;');
fprintf(fid,'\n');
fprintf(fid,'gass.noform[C8H18]=1; gass.noform[C2H5OH]=1;');
fprintf(fid,'\n');
fprintf(fid,'double heatinhhv,heatinlhv,effhhv,efflhv,hl,hv,lhv,hhv,mfrac=1.0,rpm=1;');
fprintf(fid,'\n');
if mode
   % override design mode settings   
   fprintf(fid,'\n');
   fprintf(fid,'//override design mode settings');
   fprintf(fid,'\n');
   fprintf(fid,'hx_rej.mode="o"; hx_rej.surfarea=hx_rej_sarea;');
   fprintf(fid,'\n');
   fprintf(fid,'hx_preh.mode="o"; hx_preh.surfarea=hx_preh_sarea;');
   fprintf(fid,'\n');
   fprintf(fid,'hx_cool.mode="o"; hx_cool.surfarea=hx_cool_sarea;');
   fprintf(fid,'\n');
   fprintf(fid,'pefc.mode="u"; pefc.area=pefc_area; pefc.option="ms";');
   fprintf(fid,'\n');
   fprintf(fid,'sp_fuel.sr=sp_fuel_sr;');
   fprintf(fid,'\n');
   fprintf(fid,'water_tank.t=water_tank_t; water_tank.m=water_tank_m;');
   fprintf(fid,'\n');
   fprintf(fid,'wat.q=wat_q;');
   fprintf(fid,'\n');
   fprintf(fid,'task_1.prt=0;');
   fprintf(fid,'\n');
end
fprintf(fid,'\n');
fprintf(fid,'while (task_1.c)');
fprintf(fid,'\n');
fprintf(fid,'  {');
fprintf(fid,'\n');
if ~mode
   fprintf(fid,'   vary(wat.q,0.6468,-0.20,1.5);');
   fprintf(fid,'\n');
   fprintf(fid,'   vary(water_tank.m, 0.7955, 0.05,2.5);');
   fprintf(fid,'\n');
   fprintf(fid,'   vary(water_tank.t, 325.659, 305, 340);');
   fprintf(fid,'\n');
   fprintf(fid,'   vary(sp_fuel.sr, 0.10178, 0.0, 0.25);');
   fprintf(fid,'\n');
end
fprintf(fid,'   vary(mfrac, 1, 0.05, 5);');
fprintf(fid,'\n');
fprintf(fid,'   ');
fprintf(fid,'\n');
fprintf(fid,'   cond_1.texit=water_tank.t;');
fprintf(fid,'\n');
fprintf(fid,'   fuel.m=mfrac*0.33e-3*32.042;');
fprintf(fid,'\n');
fprintf(fid,'   air.m=mfrac*4.6e-3*28.0;');
fprintf(fid,'\n');
fprintf(fid,'   wat.m=mfrac*0.33e-3*1.4*18.0153*(1-sp_fuel.sr)/(1.0-sp_shif.sr);');
fprintf(fid,'\n');
fprintf(fid,'   gt_1.rpm=rpm; cp_air.rpm=rpm;'); 
fprintf(fid,'\n');
fprintf(fid,'   air.c; cp_air.c; sp_air.c;'); 
fprintf(fid,'\n');
fprintf(fid,'   sp_prox.c; mx_prox.s;');
fprintf(fid,'\n');
fprintf(fid,'   wat.c; sp_shif.c; form.s;');
fprintf(fid,'\n');
fprintf(fid,'   fuel.c;  pump_fuel.c; hx_preh.c; sp_fuel.c; form.c;  mx_shif.s;');
fprintf(fid,'\n');
fprintf(fid,'   sp_shif.s; mx_shif.c; mx_prox.c; hx_cool.h; pefc.ain;');
fprintf(fid,'\n');
fprintf(fid,'   sp_prox.s; pefc.c; sp_h2o.c; mx_cath.s; ');
fprintf(fid,'\n');
fprintf(fid,'   sp_air.s; mx_burn.s;  ');
fprintf(fid,'\n');
fprintf(fid,'   sp_fuel.s; ch3oh.cont; mx_fuel.s;');
fprintf(fid,'\n');
fprintf(fid,'   pefc.a; cp_anode.c; ');
fprintf(fid,'\n');
fprintf(fid,'   sp_anode.c; mx_burn.c; mx_fuel.c;');  
fprintf(fid,'\n');
fprintf(fid,'   form.h;  mx_cath.c; mx_anode.s;');
fprintf(fid,'\n');
fprintf(fid,'   sp_anode.s; mx_anode.c; gt_1.c; cond_1.c;');
fprintf(fid,'\n');
fprintf(fid,'   sp_h2o.s; h2o.cont; mx_h2o.s;');
fprintf(fid,'\n');
fprintf(fid,'   water_tank.c; pump_water.c; pefc.cool; mx_h2o.c;');   
fprintf(fid,'\n');
fprintf(fid,'   sp_wat.sr=wat.m/mx_h2o.fl.m; sp_wat.c; ');
fprintf(fid,'\n');
fprintf(fid,'   hx_rej.t_hot=water_tank.t;');
fprintf(fid,'\n');
fprintf(fid,'   hx_preh.h; hx_rej.h; mx_cond.s;');
fprintf(fid,'\n');
fprintf(fid,'   cond_1.s; mx_cond.c; water_tank.cycl;');
fprintf(fid,'\n');
fprintf(fid,'   sp_wat.s; hx_cool.c; wat.cycl;');
fprintf(fid,'\n');
fprintf(fid,'   air_int.c; fan_int.c; cp_air.cool;');
fprintf(fid,'\n');
fprintf(fid,'   air_cond.c; fan_cond.c; cond_1.cool; air_rej.c; fan_rej.c; hx_rej.c; pows.c;');
fprintf(fid,'\n');

if ~mode
   fprintf(fid,'   cons(wat.q,wat.d.h/wat.fl.h);');
   fprintf(fid,'\n');
   fprintf(fid,'   cons(water_tank.m, pefc.flcool.t-348.0);');
   fprintf(fid,'\n');
   fprintf(fid,'   cons(water_tank.t, water_tank.d.m);');
   fprintf(fid,'\n');
   fprintf(fid,'   cons(sp_fuel.sr, form.flh.t-627);');
   fprintf(fid,'\n');
end
fprintf(fid,'   cons(mfrac, pows.prod-pows.cons-power_req);');
fprintf(fid,'\n');
fprintf(fid,'  }');
fprintf(fid,'\n');
fprintf(fid,'mods.print; gass.print; gass.mprint; pows.print;');
fprintf(fid,'\n');
fprintf(fid,'gass.sat(fuel.fl,hl,hv);');
fprintf(fid,'\n');
fprintf(fid,'gass.hv(fuel.fl,lhv,hhv); ');
fprintf(fid,'\n');
fprintf(fid,'heatinhhv=fuel.fl.m*(hl-hv+hhv);');
fprintf(fid,'\n');
fprintf(fid,'effhhv=(pows.prod-pows.cons)/heatinhhv;');
fprintf(fid,'\n');
fprintf(fid,'heatinlhv=fuel.fl.m*(hl-hv+lhv);');
fprintf(fid,'\n');
fprintf(fid,'efflhv=(pows.prod-pows.cons)/heatinlhv;');
fprintf(fid,'\n');
fprintf(fid,'printf("\\nhhv=%%.3e lhv=%%.3e ",hhv,lhv);');
fprintf(fid,'\n');
fprintf(fid,'printf("\\nheatinhhv=%%.3e effhhv=%%.3e \\nheatinlhv=%%.3e efflhv=%%.3e",heatinhhv,effhhv,heatinlhv,efflhv);');
fprintf(fid,'\n');
fprintf(fid,'\n');
return

function pem_gas(fid,mode)

fid2=fopen('pem_gas.dat','rt');
i=0;
str={};
while ~feof(fid2)
   i=i+1;
   str{i}=fgets(fid2);
end
fclose(fid2);

i=0;
while i<length(str)
   i=i+1;
   if findstr(str{i},'//')
      if (findstr(str{i},'override')&findstr(str{i},'design')&findstr(str{i},'mode')&findstr(str{i},'settings'))
         fprintf(fid,'\n');
         fprintf(fid,'//override design mode settings');
         if mode
            % override design mode settings   
            fprintf(fid,'\n');
            fprintf(fid,'hx_rej.mode="o"; hx_rej.surfarea=hx_rej_sarea;');
            fprintf(fid,'\n');
            fprintf(fid,'hx_wat.mode="o"; hx_wat.surfarea=hx_wat_sarea;');
            fprintf(fid,'\n');
            fprintf(fid,'hx_vap.mode="o"; hx_vap.surfarea=hx_vap_sarea;');
            fprintf(fid,'\n');
            fprintf(fid,'hx_cond.mode="o"; hx_cond.surfarea=hx_cond_sarea;');
            fprintf(fid,'\n');
            fprintf(fid,'hx_air.mode="o"; hx_air.surfarea=hx_air_sarea;');
            fprintf(fid,'\n');
            fprintf(fid,'hx_cool.mode="o"; hx_cool.surfarea=hx_cool_sarea;');
            fprintf(fid,'\n');
            fprintf(fid,'pefc_1.mode="u"; pefc_1.area=pefc_1_area; pefc_1.option="ms";');
            fprintf(fid,'\n');
            fprintf(fid,'water_tank.t=water_tank_t;');
            fprintf(fid,'\n');
            fprintf(fid,'wat.q=wat_q;');
            fprintf(fid,'\n');
            fprintf(fid,'wat.m=wat_m;');
            fprintf(fid,'\n');
            fprintf(fid,'task_main.prt=0;');
            fprintf(fid,'\n');
         end
      elseif (findstr(str{i},'varied')&findstr(str{i},'parameters'))
         if ~mode
            while isempty(findstr(str{i},'//end'))
               write_to_file(fid,str{i});
               i=i+1;
            end
            write_to_file(fid,str{i});
         else
            while isempty(findstr(str{i},'//end'))
               write_to_file(fid,['//',str{i}]);
               i=i+1;
            end
            write_to_file(fid,str{i});
         end
      elseif findstr(str{i},'constraints')
         if ~mode
            while isempty(findstr(str{i},'//end'))
               write_to_file(fid,str{i});
               i=i+1;
            end
            write_to_file(fid,str{i});
         else
            while isempty(findstr(str{i},'//end'))
               write_to_file(fid,['//',str{i}]);
               i=i+1;
            end
            write_to_file(fid,str{i});
         end
      else
         write_to_file(fid,str{i});
      end
   else
      write_to_file(fid,str{i});
   end
end

function write_to_file(fid,string)
string=strrep(string,'%','%%');
string=strrep(string,'\n','\\n');
fprintf(fid,string);
return

return

% Revision History
% tm:9/8/99 file created
% 9/22/99:tm added functionality for pem_h2 and pem_gas
% 2/8/01:tm updated advisor path info
