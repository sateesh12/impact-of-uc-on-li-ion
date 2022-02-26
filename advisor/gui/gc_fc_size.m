function temp_stuff(component_type)
%component_type can be generator or fuel_converter

global vinf

fc_map_trq=evalin('base','fc_map_trq');
fc_map_spd=evalin('base','fc_map_spd');
fc_fuel_map=evalin('base','fc_fuel_map');
fc_trq_scale=evalin('base','fc_trq_scale');
fc_spd_scale=evalin('base','fc_spd_scale');
fc_max_trq=evalin('base','fc_max_trq');
gc_map_trq=evalin('base','gc_map_trq');
gc_trq_scale=evalin('base','gc_trq_scale');
gc_map_spd=evalin('base','gc_map_spd');
gc_spd_scale=evalin('base','gc_spd_scale');
gc_eff_map=evalin('base','gc_eff_map');
gc_max_trq=evalin('base','gc_max_trq');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute locus of best efficiency points
%

%
% compute engine efficiency map for use in genset control
%
[T,w]=meshgrid(fc_map_trq,fc_map_spd);
fc_outpwr_map_kW=T.*w/1000;
fc_fuel_map_gpkWh=fc_fuel_map./(fc_outpwr_map_kW+eps)*3600;
% if zero speed is in map, replace associated data with nearest BSFC*4
if min(fc_map_spd)<eps
   fc_fuel_map_gpkWh(1,:)=fc_fuel_map_gpkWh(2,:)*4;
end
% if zero torque is in map, replace associated data with nearest BSFC*4
if min(fc_map_trq)<eps
   fc_fuel_map_gpkWh(:,1)=fc_fuel_map_gpkWh(:,2)*4;
end

%
% compute allowable genset torques and speeds
% (these are limited by the max torque envelopes of the FC and GC, and by the
% extents of their maps)
%
temp1=min([max(fc_map_trq)*fc_trq_scale max(gc_map_trq)*gc_trq_scale]);
temp2=max([min(fc_map_trq)*fc_trq_scale min(gc_map_trq)*gc_trq_scale]);
genset_map_trq=[temp2:(temp1-temp2)/10:temp1];

temp1=min([max(fc_map_spd)*fc_spd_scale max(gc_map_spd)*gc_spd_scale]);
temp2=max([min(fc_map_spd)*fc_spd_scale min(gc_map_spd)*gc_spd_scale]);
genset_map_spd=[temp2:(temp1-temp2)/10:temp1];

temp1=interp1(fc_map_spd*fc_spd_scale,fc_max_trq*fc_trq_scale,genset_map_spd);
temp2=interp1(gc_map_spd*gc_spd_scale,gc_max_trq*gc_trq_scale,genset_map_spd);
genset_max_trq=min([temp1;temp2]);

if ~isempty(genset_map_trq) & ~isempty(genset_map_spd) & ~isempty(genset_max_trq) %added for special cases where temp1 and temp2 might be the same value (rare occurence)
    % compute genset BSFC map
    temp1=interp2(gc_map_trq*gc_trq_scale,gc_map_spd'*gc_spd_scale,gc_eff_map,...
        genset_map_trq,genset_map_spd');
    temp2=interp2(fc_map_trq*fc_trq_scale,fc_map_spd'*fc_spd_scale,...
        fc_fuel_map_gpkWh,genset_map_trq,genset_map_spd');
    genset_BSFC_map=temp2./(temp1+eps);
    
    % Define power vector
    genset_max_pwr=max(genset_map_spd.*...
        (min([genset_max_trq;ones(size(genset_max_trq))*max(genset_map_trq)])));
    %genset_max_pwr=min(max(genset_map_spd.*genset_max_trq),...
    % max(genset_map_spd)*max(genset_map_trq));
    genset_min_pwr=min(genset_map_spd)*min(genset_map_trq);
    cs_pwr=[genset_min_pwr:(genset_max_pwr-genset_min_pwr)/10:genset_max_pwr];
    
    % Loop on power
    for pwr_index=2:length(cs_pwr-1)
        
        % consider every integer speed in the map
        spds=[ceil(min(genset_map_spd)):floor(max(genset_map_spd))];
        
        % determine corresponding torque to produce the current power
        trqs1=cs_pwr(pwr_index)./(spds+eps);
        
        % make sure all torques are on the map
        trqs2=min(trqs1,max(genset_map_trq));
        trqs2=max(trqs2,min(genset_map_trq));
        
        % compute BSFCs corresponding to spd/trq points
        BSFCs=interp2(genset_map_spd,genset_map_trq,genset_BSFC_map',spds,trqs2);
        
        % correct BSFCs to disallow points beyond the engine's or generator's
        % (continuous) operating range
        BSFCs=BSFCs + (trqs1 > interp1(fc_map_spd*fc_spd_scale,...
            fc_max_trq*fc_trq_scale,spds)) * 10000 ...
            + (trqs1 > interp1(gc_map_spd*gc_spd_scale,gc_max_trq*gc_trq_scale,...
            spds)) * 10000;
        
        if any(isnan(BSFCs))
            flag=1;%error('Error in PTC_SERFO: couldn''t compute genset eff. map')
        else 
            flag=0;
        end
        
    end % for pwr_index=...
else
    flag=1;
end %if ~isempty(.......

if flag
   msg={'The selected fuel converter is incompatable with the current generator.  ', ' ', 'Please select the desired option:  ','  1) Allow ADVISOR to resize generator appropriately,', '  2) Let me choose/modify the generator.'};
   
   button=questdlg(msg,'Mismatched Component Warning','Option 1','Option 2', 'Option 2');
   
   if strcmp(button,'Option 1')
      % match gc spd and trq range to that of the fc 
      assignin('base','gc_spd_scale',round(evalin('base','max(fc_map_spd*fc_spd_scale)/max(gc_map_spd)')*1000)/1000);
      assignin('base','gc_trq_scale',min(max(round(evalin('base',...
         'max(fc_max_trq*fc_trq_scale)/gc_max_trq(min(find(fc_max_trq==max(fc_max_trq))))')*1000)/1000,0.1),50));
      if ~strcmp(vinf.drivetrain.name,'fuel_cell')&evalin('base','exist(''gc_trq_scale'')')
         gc_trq_scale=evalin('base','gc_trq_scale');
         gc_spd_scale=evalin('base','gc_spd_scale');
         gc_max_pwr=vinf.generator.def_max_pwr*gc_spd_scale*gc_trq_scale;
         set(findobj('tag','gc_max_pwr'),'string',num2str((gc_max_pwr)));
         gui_edit_var('gc_max_pwr')
      end
      
   else
      if strcmp(component_type,'fuel_converter')
         % restore to previous file name
         eval(['vinf.fuel_converter.name=vinf.fuel_converter.prev_name;'])
         % update the gui
         update_vinf_ver_type('fuel_converter')
         version=vinf.fuel_converter.ver;
         type=vinf.fuel_converter.type;
         set(findobj('tag','fc_type'),'value',optionlist('value','fc_type',type,version,type))
         set(findobj('tag','fuel_converter'),'string',optionlist('get',component_type,'junk',version,type))
         set(findobj('tag','fuel_converter'),'value',optionlist('value',component_type,vinf.fuel_converter.name,version,type))
         evalin('base',['run ',vinf.fuel_converter.name]);
      elseif strcmp(component_type, 'generator')
         %restore to previous file name
         eval(['vinf.generator.name=vinf.generator.prev_name;'])
         % update the gui
         set(findobj('tag','generator'),'value',optionlist('value','generator',vinf.generator.name))
         evalin('base',['run ',vinf.generator.name]);
      end
   end
   
end

return

% 7/17/00 ss: changed all gui options to optionlist.
% 8/19/00 ss: updated call to optionlist for fuel converter.
% 8/17/01 ss: added if ~isempty for special case when temp1=temp2 (very rare but happens for CI330 and GC_ETA92) 