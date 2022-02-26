function im=ImageInfo(drivetrain)
%function ImageInfo returns a cell array 'im' that contains the name of the component
% along with the position [x_lo x_hi y_lo y_hi] of that component in the image.
% the name of the component must match the one listed in optionlist.
%function created to be used with gui_select

switch drivetrain
case {'series','saber_ser'}
   
   im={
      'energy_storage'		,[112  156 31  119]
      'fuel_converter'		,[306  349 48  112]
      'generator'				,[208  239 94  115]
      'motor_controller'	,[193  225 29  76]
      'exhaust_aftertreat'	,[188  225 123  135]
      'transmission'			,[268  290 60 100]
		'wheel_axle'			,[61  117 2  25]
      'wheel_axle'			,[252  307 6  28]
      'wheel_axle'			,[63  118 134  157]
      'wheel_axle'			,[251  306 134  154]
      };
   
case {'parallel','saber_par'}
   
   im={
      'energy_storage'		,[109  153 31  118]
      'fuel_converter'		,[305  351 50  113]
      'motor_controller'	,[194  225 25  70]
      'exhaust_aftertreat'	,[190  229 120  133]
      'exhaust_aftertreat'	,[14  54 113  128]
      'transmission'			,[269  289 60  101]
      'wheel_axle'			,[62  118 1  24]
      'wheel_axle'			,[251  307 7  27]
      'wheel_axle'			,[63  119 135  158]
      'wheel_axle'			,[249  307 134  155]
      };

case {'conventional','saber_conv_sv','saber_conv_dv'}
   
   im={
      'fuel_converter'		,[306  350 48  112]
      'exhaust_aftertreat'	,[182  219 118  130]
      'exhaust_aftertreat'	,[24  62 118  132]
      'transmission'			,[269  290 60  101]
      'wheel_axle'			,[61  116 1  25]
      'wheel_axle'			,[252  307 7  27]
      'wheel_axle'			,[61  116 135  159]
      'wheel_axle'			,[252  308 134  154]
      };
   
case 'ev'
   
   im={
      'energy_storage'		,[141  186 35  125]
      'motor_controller'	,[215  247 27  75]
      'transmission'			,[271  290 60  101]
      'wheel_axle'			,[61  117 2  26]
      'wheel_axle'			,[254  310 7  28]
      'wheel_axle'			,[61  118 134  159]
      'wheel_axle'			,[254  310 134  154]
      };
   
case 'prius_jpn'
   
   im={
      'energy_storage'		,[100  144 33  120]
      'fuel_converter'		,[307  349 51  114]
      'generator'				,[174  196 91  122]
      'motor_controller'	,[175  205 31  78]
      'exhaust_aftertreat'	,[191  229 124  137]
      'transmission'			,[226  261 89  122]
      'wheel_axle'			,[253  308 11  30]
      'wheel_axle'			,[66  121 135  158]
      'wheel_axle'			,[253  308 135  154]
      };
   
case 'fuel_cell'
   
   im={
      'energy_storage'		,[131  179 48  140]
      'fuel_converter'		,[310  334 40  120]
      'motor_controller'	,[216  245 64  112]
      'transmission'			,[273  291 60  101]
      'wheel_axle'			,[62  117 1  25]
      'wheel_axle'			,[254  310 7  28]
      'wheel_axle'			,[61  117 134  158]
      'wheel_axle'			,[253  308 133  154]
      };
   
case 'parallel_sa'
   im={
      'energy_storage'		,[104  147 45  131]
      'fuel_converter'		,[304   336    40    83]
      'motor_controller'	,[307   333    83   119]
      'exhaust_aftertreat'	,[166   216    31    46]
      'exhaust_aftertreat'	,[13    69    27    43]
      'transmission'			,[272   291    69   103]
      'wheel_axle'			,[62   118     2    25]
      'wheel_axle'			,[62   118     2    25]
      'wheel_axle'			,[63   117   134   157]
      'wheel_axle'			,[253   307   132   153]
      };
   
case 'insight'
   im={
      'energy_storage'		,[104  147 45  131]
      'fuel_converter'		,[304   336    40    83]
      'motor_controller'	,[307   333    83   119]
      'exhaust_aftertreat'	,[166   216    31    46]
      'exhaust_aftertreat'	,[13    69    27    43]
      'transmission'			,[272   291    69   103]
      'wheel_axle'			,[62   118     2    25]
      'wheel_axle'			,[62   118     2    25]
      'wheel_axle'			,[63   117   134   157]
      'wheel_axle'			,[253   307   132   153]
      };
   
   
case 'custom'
   
   im={
      'wheel_axle'			,[62  117 1  25]
      'wheel_axle'			,[254  310 7  28]
      'wheel_axle'			,[61  117 134  158]
      'wheel_axle'			,[253  308 133  154]
      };
   
end

% 2/8/00 ss: created this file for use with gui_select.
% 7/17/00 ss: replaced gui options with optionlist in the comment section.
% 8/16/00 ss: added insight and parallel_sa cases
% 2/2/01: ss updated prius to prius_jpn