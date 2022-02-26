function WindowStickerFigControl(option)

global vinf

if nargin<1
   option='load';
end

switch option
   
case 'load'
   
   % setup constant coefficients
   ghg_p_gal=0; % tons of greanhouse gas emissions per gallon of gas [temporarily disabled tm:1/31/01]
   gas_price=1.65; % $/gal of gasoline
   hwy_weight=0.45; % highway fuel economy weighting factor for calculating composite value
   city_weight=0.55; % city fuel economy weighting factor for calculating composite value
   epa_hwy_factor=0.78; % EPA correction factor to translate from test to "real world" highway operation
   epa_city_factor=0.9; % EPA correction factor to translate from test to "real world" city operation
   annual_miles=15000; % annual miles driven per year
   
   % calculate values to display
   city_fuel=evalin('base','mpgge')*epa_city_factor;
   hwy_fuel=evalin('base','mpgge_hwy')*epa_hwy_factor;
   comp_fuel=1/((city_weight/city_fuel)+(hwy_weight/hwy_fuel));
   fuel_costs=1/(comp_fuel/annual_miles)*gas_price;
   ghg_value=1/(comp_fuel/annual_miles)*ghg_p_gal;
   
   % open figure window
   WindowStickerFig
   
   % update values
   if strcmp(vinf.units,'metric')
      set(findobj('tag','title_str'),'string','Fuel Consumption (L/100km)')
      set(findobj('tag','city_mpg_value'),'string',num2str(round(1/city_fuel*units('gpm2lp100km')*10)/10))
      set(findobj('tag','hwy_mpg_value'),'string',num2str(round(1/hwy_fuel*units('gpm2lp100km')*10)/10))
   else
      set(findobj('tag','city_mpg_value'),'string',num2str(round(city_fuel)))
      set(findobj('tag','hwy_mpg_value'),'string',num2str(round(hwy_fuel)))
   end
   set(findobj('tag','ghg_value'),'string',num2str(round(ghg_value)))
   set(findobj('tag','fuel_cost_value'),'string',num2str(round(fuel_costs)))
   
   % temporarily disable ghg info tm:01/31/01
   set(findobj('tag','ghg_value'),'visible','off')
   set(findobj('tag','ghg_units_label'),'visible','off')
   set(findobj('tag','ghg_str'),'visible','off')
   
   % center and make visible
   h0=gcf;
   set(h0,'units','pixels');
   position=get(h0,'position');
   screensize=get(0,'screensize');
   set(h0,'position', [(screensize(3)-position(3))/2  (screensize(4)-position(4))/2 ...
         position(3) position(4)])
   set(h0,'visible','on')
   set(h0,'windowstyle','normal')
   
end

%%% revision history
% 1/31/01:tm file created
% 1/31/01:tm switched city and hwy weighting factors - they were flip-flopped
%

