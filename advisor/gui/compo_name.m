function comp = compo_name(compo)
%return the shortname of a component if compo is the full name and
%return the full name of a component if compo is the short name.
%it is useful to access gui components which are defined with the shortname
% 06/27/00 Created by Sylvain Pagerit (ANL-PSAT)

compo_list = optionlist('get','component_titles');

if nargin == 0;
   comp = compo_list;
else
   switch compo
   case 'drivetrain'
      comp = 'drv';
   case 'powertrain_control'
      comp = 'ptc';
   case 'vehicle'
      comp = 'veh';
   case 'fuel_converter'
      comp = 'fc';
   case 'exhaust_aftertreat'
      comp = 'ex';
   case 'energy_storage'
      comp = 'ess';
   case 'motor_controller'
      comp = 'mc';
   case 'generator'
      comp = 'gc';
   case 'clutch_torque_conv'
      comp = 'cpl';
   case 'transmission'
      comp = 'tx';
   case 'shift_law'
      comp = 'sft';
   case  'pump'
      comp = 'pump';
   case 'torque_coupling'
      comp = 'tc';
   case 'final_drive'
      comp = 'fd';
   case 'wheel_axle'
      comp = 'wh';
   case 'accessory'
      comp='acc';
   case 'accessory_mechanical'
      comp = 'accmech';
   case 'accessory_electrical'
      comp = 'accelec';
   case 'energy_storage2'
      comp = 'ess2';
   case 'motor_controller2'
      comp = 'mc2';
   case 'transmission2'
      comp = 'tx2';
   case 'final_drive2'
      comp = 'fd2';
   case 'wheel_axle2'
      comp = 'wh2';
   case 'transfert_case'
      comp = 'trc';
   case 'starter'
      comp = 'str';
   case 'saber_cosim'
      comp = 'scs';
      
   case 'drv';
      comp = 'drivetrain';
   case 'ptc';
      comp = 'powertrain_control';
   case 'veh';
      comp = 'vehicle';
   case 'fc';
      comp = 'fuel_converter';
   case 'ex';
      comp = 'exhaust_aftertreat';
   case 'ess';
      comp = 'energy_storage';
   case 'mc';
      comp = 'motor_controller';
   case 'gc';
      comp = 'generator';
   case 'cpl';
      comp = 'clutch_torque_conv';
   case 'tx';
      comp = 'transmission';
   case 'sft'
      comp = 'shift_law';
   case 'tc';
      comp = 'torque_coupling';
   case 'fd';
      comp = 'final_drive';
   case 'wh';
      comp = 'wheel_axle';
   case 'acc'
      comp='accessory';
   case 'accmech';
      comp = 'accessory_mechanical';
   case 'accelec';
      comp = 'accessory_electrical';
   case 'ess2';
      comp = 'energy_storage2';
   case 'mc2';
      comp = 'motor_controller2';
   case 'tx2';
      comp = 'transmission2';
   case 'fd2';
      comp = 'final_drive2';
   case 'wh';
      comp = 'wheel_axle2';
   case 'trc';
      comp = 'transfert_case';
   case 'str';
      comp = 'starter';
  case 'scs'
      comp = 'saber_cosim';
      
   otherwise
      comp = compo;
   end
end

return

% 06/27/00 Created by Sylvain Pagerit (ANL-PSAT)
% 8/15/00 ss added case 'acc' and 'accessory'
%02/14/01: vhj added saber cosim case