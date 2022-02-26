function [tx_eff_map, tx_map_spd, tx_map_trq] = tx_eff_mapper(gb_vars,w,T,gear_ratio)
% function [tx_eff_map, tx_map_spd, tx_map_trq] = tx_eff_mapper(gb_vars,w,T,gb_ratio)
% from TX_VW
% gb_vars.gb_loss_input_spd_coeff=0.614307976;
% gb_vars.gb_loss_output_spd_coeff=5.530953616;
% gb_vars.gb_loss_input_trq_coeff=-0.861652506;
% gb_vars.gb_loss_output_trq_coeff=0.229546756;
% gb_vars.gb_loss_output_pwr_coeff=0.023981187;
% gb_vars.gb_loss_const=-92.07523029;
%
% output_shaft_speed sweep
% w.vals
%
% output_shaft_torque sweep
% T.vals
%
% eff_map = (Pwr_input-Pwr_loss)/Pwr_input for powered case
% eff_map = (pwr_output-Pwr_loss)/pwr_output for regen case
%
% to plot after a run: 
% figure, [c,h] = contour(tx_map_trq, tx_map_spd, tx_eff_map(:,:,1),[0:0.05:1]); clabel(c,h), colorbar

tx_eff_map=0;
w_list = w.vals;
T_list = T.vals;
for m=1:length(gear_ratio)
   for i=1:length(w_list)
      for j=1:length(T_list)
        pwr_output = w_list(i)*abs(T_list(j));
        tx_eff_map(i,j,m)= (pwr_output)/(P_loss(gb_vars, w_list(i), T_list(j), pwr_output,gear_ratio(m))+pwr_output+eps);
        if T_list(j)<0
           tx_eff_map(i,j,m) = (pwr_output-P_loss(gb_vars, w_list(i), abs(T_list(j)), pwr_output,gear_ratio(m)))/(pwr_output+eps);
        end
        if tx_eff_map(i,j,m)<0
           tx_eff_map(i,j,m)=0;
           %disp(['Warning! An attempt to calculate an efficiency below zero was detected! [',num2str(i),',',num2str(j),',',num2str(m),']']);
        elseif tx_eff_map(i,j,m)>1
           tx_eff_map(i,j,m)=1;
           %disp(['Warning! An attempt to calculate an efficiency above 100% was detected! [',num2str(i),',',num2str(j),',',num2str(m),']']);
        end      
     end
  end
end

tx_map_spd = w_list;
tx_map_trq = T_list;

function pwr_loss = P_loss(gb_vars,output_shaft_speed, output_shaft_torque, output_shaft_power,gear_ratio)

gb_loss_input_spd_coeff= gb_vars.gb_loss_input_spd_coeff;
gb_loss_output_spd_coeff= gb_vars.gb_loss_output_spd_coeff;
gb_loss_input_trq_coeff= gb_vars.gb_loss_input_trq_coeff;
gb_loss_output_trq_coeff= gb_vars.gb_loss_output_trq_coeff;
gb_loss_output_pwr_coeff= gb_vars.gb_loss_output_pwr_coeff;
gb_loss_const= gb_vars.gb_loss_const;

pwr_loss = (gb_loss_input_spd_coeff * gear_ratio + gb_loss_output_spd_coeff)...
		* output_shaft_speed...
	 + (gb_loss_input_trq_coeff / gear_ratio + gb_loss_output_trq_coeff)...
		* output_shaft_torque...
	 + gb_loss_output_pwr_coeff * output_shaft_power +...
	 + gb_loss_const;