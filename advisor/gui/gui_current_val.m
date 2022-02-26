function value=gui_current_val(str,popup)
%gui_current_val is a function that returns the integer number
%indicating the location of an option for a uicontrol such as a
%popupmenu.  The uicontrol option is 'value'.  This function 
%basically returns which row the desired option is located at 
%inside a vertical string array.

%   str should be one of the following strings:
%    (1) 'drivetrain'
%    (2) 'fuel_converter'
%    (3) 'generator'
%    (4) 'torque_coupling'
%    (5) 'motor_controller'
%    (6) 'energy_storage'
%    (7) 'gearbox'
%    (8) 'final_drive'
%    (9) 'wheel_axle'
%   (10) 'vehicle'
%   (11) 'exhaust_aftertreat'
%   (12) 'vehicle_control'
%	 (13)	'hybrid_control'
% 06/06/00 Added by Sylvain Pagerit (ANL-PSAT):
%			'powertrain_control'
%			'clutch_torq_conv'
%			'transmission'
%			'accessory_mechanical'
%			'accessory_electrical'
%			'energy_storage2'
%    		'motor_controller2'
%			'transmission2'
%    		'final_drive2'
%    		'wheel_axle2'
%			'transfert_case'
%			'starter'
% 07/21/00 Added by Sylvain Pagerit (ANL-PSAT):
%			'shift_law'
%			'pump'


%gain access to global variable necessary for this function
global vinf

if nargin == 1
   %List out all options for the component named str taking into accounte version and type   
   %test if there are a version and a type defined for this compo
   compo = eval(['vinf.',str]);
   
   if isfield(compo,'ver')
      version=compo.ver;
      
      if isfield(compo,'type')
         type=compo.type;
         str_options = optionlist('get',str,'junk',version,type);
      else
         str_options = optionlist('get',str,'junk',version);
      end
   else
   	str_options = optionlist('get',str);
   end

	%finds which row(hence value) of matrix 'str_options' that the 
	%uicontrol is on
	value=strmatch(eval(['vinf.',str,'.name']),str_options,'exact');

elseif nargin == 2		%called for the type and version popup menus
   %find the shortname of the component
   compo = compo_name(str);
   
   switch popup
   case 'type'
      version=eval(['vinf.' str '.ver']);
      
      %List out all options for the component type
		str_options = optionlist('get',[compo,'_type'],'junk',version);

	case 'ver'
   	%List out the string for the version
      str_options = get(findobj('tag',[compo,'_ver']),'string');
   end
      
   %finds which row(hence value) of matrix 'str_options' that the 
	%uicontrol is on
   value=strmatch(eval(['vinf.',str,'.',popup]),str_options,'exact');
   
end

%THE END

% 06/22/00 Sylvain Pagerit (ANL-PSAT): - take into account the version and the type of the component if they exist.
%													- add the version and type cases to return the value of the corresponding
%													popup menus
% 8/15/00 ss updated version and type area under nargin==1 and updated how str_options was found under case 'type'
