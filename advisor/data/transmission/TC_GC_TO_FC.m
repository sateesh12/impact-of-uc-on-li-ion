% TC_GC_TO_FC
% ADVISOR data file:  TC_GC_TO_FC.m
%
% Data source:
%
% Data confirmation:
%
% Notes:
% Defines lossless belt drive with a generator-to-engine speed ratio 
%
% Created on: 14-Jun-2002
% By:  AB, NREL, aaron_brooker@nrel.gov
%
% Revision history at end of file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FILE ID INFO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tc_description='lossless belt drive';
tc_version=2003; % version of ADVISOR for which the file was generated
tc_proprietary=0; % 0=> non-proprietary, 1=> proprietary, do not distribute
tc_validation=0; % 0=> no validation, 1=> data agrees with source data, 
% 2=> data matches source data and data collection methods have been verified
disp(['Data loaded: TC_GC_TO_FC - ',tc_description])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DATA		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set the pulley ratio
%
tc_gc_to_fc_ratio=1;



% ReqVars={'gc_map_spd'
%     'gc_map_trq'
%     'gc_eff_map'
%     'fc_map_spd'
%     'fc_map_trq'
%     'fc_eff_map'};
% 
% %   Test that required vars exist
% for i=1:length(ReqVars)
%     UndefinedVars=[];
%     if evalin('base',['~exist(''',ReqVars{i},''');'])
%         UndefinedVars=[UndefinedVars;ReqVars{i}];
%     else
%         VarValue=evalin('base',ReqVars{i});
%         eval([ReqVars{i},'=VarValue;']);
%     end
% end

% Set the pulley ratio to match max speed of generator and max speed of fuel converter
%
% tc_gc_to_fc_ratio=0.99*max(gc_map_spd*gc_spd_scale)/max(fc_map_spd*fc_spd_scale); % (--)


% Set the pulley ratio to operate the generator and fuel converter at their most efficient points
%   ***NOTE:    Although it may result in the best component efficiencies, it may not result in the best
%               vehicle system efficiency (i.e. it may be better to run a smaller fc at a less efficient
%               higher power if the weight savings result in a better overall system efficiency)
%
% if isempty(UndefinedVars)
%     
%     gc_map_spd=evalin('base','gc_map_spd;');
%     
%     %   Find max efficiencies for each speed in map
%     [GCEffValues,GCEffTrqIndices]=max(gc_eff_map,[],2);
%     [FCEffValues,FCEffTrqIndices]=max(fc_eff_map,[],2);
%     
%     %   Find max overall efficiency
%     [FCMaxEff,FCEffSpdIndex]=max(FCEffValues);
%     FCMaxEffSpd=fc_map_spd(FCEffSpdIndex);
%     
%     [GCMaxEff,GCEffSpdIndex]=max(GCEffValues);
%     
%     %   Get max generator efficiency speed (if multiple exist) that is closest to max fc eff spd
%     if sum(GCEffValues == GCMaxEff) > 1
%         gc_spd_indices=find(GCEffValues == GCMaxEff);
%         
%         GCSpd2FCSpdDiff=gc_map_spd(gc_spd_indices)-FCMaxEffSpd;
%         [GC2FCMaxEffSpdDiff,GCMaxEffSubIndex]=min(abs(GCSpd2FCSpdDiff));
%         
%         GCEffSpdIndex=gc_spd_indices(GCMaxEffSubIndex);
%         GCMaxEffSpd=gc_map_spd(GCEffSpdIndex);
%     else
%         [GCMaxEffSpd,GCEffSpdIndex]=max(GCEffValues);
%         GCMaxEffSpd=gc_map_spd(GCEffSpdIndex);
%     end  
%     
%     %   View plot 
%     if 0
%         figure;
%         axes;
%         contour(fc_map_spd,fc_map_trq,transpose(fc_eff_map));
%         hold on;
%         [FCEffTrqValues,FCEffTrqIndices]=max(fc_eff_map);
%         [FCMaxEff,FCMaxEffTrqIndex]=max(FCEffTrqValues);
%         
%         FCMaxEffTrq=fc_map_trq(FCMaxEffTrqIndex);
%         plot(FCMaxEffSpd,FCMaxEffTrq,'o');
%         
%         figure;
%         axes;
%         contour(gc_map_spd,gc_map_trq,transpose(gc_eff_map));
%         [GCEffTrqValues,GCEffTrqIndices]=max(gc_eff_map);
%         [GCMaxEff,GCMaxEffTrqIndex]=max(GCEffTrqValues);
%         GCMaxEffTrq=gc_map_trq(GCMaxEffTrqIndex);
%         hold on;
%         plot(GCMaxEffSpd,GCMaxEffTrq,'o');
%     end
%     
%     tc_gc_to_fc_ratio=GCMaxEffSpd/fc_map_spd(FCEffSpdIndex);
%     
% else
%     disp(['tc_gc_to_fc_ratio not properly set due to missing variables: ',UndefinedVars]);
%     tc_gc_to_fc_ratio=1;
% end
% 
% assignin('base','tc_gc_to_fc_ratio',tc_gc_to_fc_ratio);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REVISION HISTORY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 6/6/02 ab:created