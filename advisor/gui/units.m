function conv_factor=units(option)

%This function created on 9/14/99 by ss of NREL.
%It is used to return a conversion factor based on what the vinf.units variable is set to.
%It returns either a 1 or the conversion factor.

global vinf

if strcmp(vinf.units,'metric')
  switch option
   case 'mph2kmph'
      conv_factor=1/.62137;
   case 'gpm2lp100km'
      conv_factor=1/1.056710*4*.62137*100;
   case 'mpg2kmpl' % tm used in cs_setup
      conv_factor=1.60934/3.78541;
	case 'miles2km'
      conv_factor=1/.62137;
   case 'gpm2gpkm' %grams/mile to grams/km
      conv_factor=.62137;
   case 'ft2m'
      conv_factor=0.3048;
   case 'kmph2mph' %this is used in the simulation setup figure when entering gradeability in km/h need to convert to mph
      conv_factor=1/1.6093;
   otherwise
   end
 
else
   conv_factor=1;
end

% 9/14/99 ss created.
%9/15/99 ss updated
