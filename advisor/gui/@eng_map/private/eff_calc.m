
if ~exist('fc_fuel_map')
   %%%% DDC Data %%%%
   % (rad/s), speed range of the engine
   fc_map_spd_ddc=[1200 1400 1600 1800 2000 2100]*pi/30; 
   
   % (N*m), torque range of the engine
   fc_map_trq_ddc=[100 200 400 600 800 1000 1200 1400 1600 1800 2000]; 
   
   % (g/s), fuel use map indexed vertically by fc_map_spd and 
   % horizontally by fc_map_trq
   fc_fuel_map_gpkWh_ddc=[
   256 242	220	207	201.5	198.5	197	195.5	194.5	193.5 192.5
   290 261	220	207	200	195	192.5	190.5	189.5	189.5 189.5
   302 273	224	207	198	194.5	192	190.5	189.5	189.5 189.5
   326 288	228	209	200.5	196	193.5	191.5	191.5	191.5 191.5
   316 288	238	217	207.5	203	199.5	197.5	196.5	195.5 194.5
   312 290	244	222	210.5	204.5	202.5	199.5	198.5	198   197.5]; % (g/kW*hr)
   % fc_fuel_map elements  (1-6,1), (1,2), (5-6,9), (4-6,10), (1-6,11) 
   % have been estimated in order to complete the table.
   
   % (N*m), max torque curve of the engine indexed by fc_map_spd
   fc_max_trq_ddc=[1959 1883 1825 1761 1585 1510];
   fc_fuel_lhv_ddc=43.0*1000; % (J/g), lower heating value of the fuel
   
   
   %%%% Cummins Data %%%%
   % (rad/s), speed range of the engine
   fc_map_spd=[1100 1200 1300 1500 1600 1700 1800 1900 2000]*pi/30; 
   
   % (N*m), torque range of the engine
   fc_map_trq=[100:100:1700]; 
   
   % (g/s), fuel use map indexed vertically by fc_map_spd and 
   % horizontally by fc_map_trq
   fc_fuel_map_gpkWh_at_max_trq=[202 196 193 191 191 192 194 197 202];
   
   % (N*m), max torque curve of the engine indexed by fc_map_spd
   fc_max_trq=[1695 1695 1695 1566 1469 1383 1306 1195 1096]; 
   fc_fuel_lhv=43.0*1000; % (J/g), lower heating value of the fuel
   
   
   %%%%% Build new efficiency and fuel consumptions maps
   
   % find ddc max trqs corresponding to cummins spds
   fc_max_trq_ddc_new=interp1(fc_map_spd_ddc,fc_max_trq_ddc,fc_map_spd);
   fc_max_trq_ddc_new(1)=fc_max_trq_ddc_new(2)*0.99;
   
   % build ddc efficiency and fuel consumption maps
   [T,w]=meshgrid(fc_map_trq_ddc,fc_map_spd_ddc);
   fc_map_kW_ddc=T.*w/1000;
   fc_fuel_map_ddc=fc_fuel_map_gpkWh_ddc.*fc_map_kW_ddc/3600;
   fc_eff_map_ddc=fc_map_kW_ddc./(fc_fuel_map_ddc*fc_fuel_lhv_ddc/1000);
   
   % find ddc efficiency along the max trq curve corresponding to the cummins spds
   fc_eff_at_max_trq_ddc=[];
   for x=1:length(fc_map_spd)
      fc_eff_at_max_trq_ddc=[fc_eff_at_max_trq_ddc ...
            interp2(fc_map_spd_ddc,fc_map_trq_ddc,fc_eff_map_ddc',fc_map_spd(x),fc_max_trq_ddc_new(x))];
   end;
   fc_eff_at_max_trq_ddc(1)=fc_eff_at_max_trq_ddc(2)*0.9999;
   
   % calculate the efficiency along the max trq curve for the cummins data
   fc_eff_at_max_trq=(fc_max_trq.*fc_map_spd/1000)./...
      ((fc_fuel_map_gpkWh_at_max_trq.*(fc_max_trq.*fc_map_spd/1000)/3600)*fc_fuel_lhv/1000);
   
   % build a matrix of efficiencies for the ddc data indexed by cummins spds and 
   % fraction of max trq at the current speed
   fc_max_trq_frac=[0.05:0.05:1.0];
   fc_eff_map_ddc_new=[];
   for x=1:length(fc_map_spd)
      fc_eff_map_ddc_new=[fc_eff_map_ddc_new ...
            interp2(fc_map_spd_ddc,fc_map_trq_ddc,fc_eff_map_ddc',fc_map_spd(x),(fc_max_trq_frac*fc_max_trq_ddc_new(x)))];
   end;
   fc_eff_map_ddc_new=fc_eff_map_ddc_new';
   fc_eff_map_ddc_new(:,1)=fc_eff_map_ddc_new(:,2)*0.99;
   fc_eff_map_ddc_new(1,:)=fc_eff_map_ddc_new(2,:)*0.99;
   fc_eff_map_ddc_new(1,1)=fc_eff_map_ddc_new(2,2)*0.99;
   
   % generate new cummins efficiency map indexed by fc_max_trq_frac and cummins spds 
   % by scaling the ddc data by, (cummins eff at max trq/ddc eff at max trq)
   fc_eff_map_new=[];
   for x=1:length(fc_map_spd)
      fc_eff_map_new=[fc_eff_map_new; fc_eff_map_ddc_new(x,:)*(fc_eff_at_max_trq(x)/fc_eff_at_max_trq_ddc(x))];
   end;
   
   % generate new cummins efficiency map indexed by cummins trq and cummins spd vectors
   fc_eff_map_new_new=[];
   for x=1:length(fc_map_spd)
      fc_eff_map_new_new=[fc_eff_map_new_new ...
            interp2(fc_map_spd,(fc_max_trq_frac*fc_max_trq(x)),fc_eff_map_new',fc_map_spd(x),fc_map_trq)];
   end;
   fc_eff_map_new_new=fc_eff_map_new_new';
   
   % fill in gaps in the map
   for x=1:length(fc_map_spd)
      for y=1:length(fc_map_trq)
         if isnan(fc_eff_map_new_new(x,y))
            fc_eff_map_new_new(x,y)=fc_eff_map_new_new(x,y-1)*1.002;
         end;
      end;
   end;
   
   % generate the new fuel consumption and efficiency maps for the cummins data
   [T,w]=meshgrid(fc_map_trq,fc_map_spd);
   fc_map_kW=T.*w/1000;
   fc_fuel_map=1/fc_fuel_lhv./fc_eff_map_new_new.*fc_map_kW*1000;
   fc_eff_map=fc_eff_map_new_new;
   
   % check results
   if 1
      figure
      plot(fc_map_spd*30/pi,fc_max_trq)
      hold
      plot(fc_map_spd*30/pi,fc_max_trq,'rx')
      c=contour(fc_map_spd*30/pi,fc_map_trq,fc_eff_map'*100);
      clabel(c)
      
      [T,w]=meshgrid(fc_map_trq,fc_map_spd);
      fc_map_kW=T.*w/1000;
	   fc_fuel_map_gpkWh=fc_fuel_map./fc_map_kW*3600;

      figure
      plot(fc_map_spd*30/pi,fc_max_trq)
      hold
      plot(fc_map_spd*30/pi,fc_max_trq,'rx')
      c=contour(fc_map_spd*30/pi,fc_map_trq,fc_fuel_map_gpkWh',[191 192 193 194 196 197 202]);
      clabel(c)
      
      fc_eff_at_max_trq_new=[];
      for x=1:length(fc_map_spd)
         fc_eff_at_max_trq_new=[fc_eff_at_max_trq_new ...
               interp2(fc_map_spd,fc_map_trq,fc_eff_map',fc_map_spd(x),fc_max_trq(x))];
      end;
      eff_diff=fc_eff_at_max_trq-fc_eff_at_max_trq_new
      
      bsfc=[];
      for x=1:length(fc_map_spd) 
         bsfc=[bsfc interp2(fc_map_spd,fc_map_trq,...
               (fc_fuel_map./fc_map_kW*3600)',fc_map_spd(x),fc_max_trq(x))]; 
      end;
      bsfc_diff=fc_fuel_map_gpkWh_at_max_trq-bsfc
   end;
   
   % clean-up workspace
   clear *ddc *new *gpkWh T w x bsfc eff_diff  fc_eff_at_max_trq fc_max_trq_frac fc_map_kW
   
end;