function resp=mod_saved_files(filename)

load([filename,'.mat'])

vinf.cycle.ess2fuel_tol=1;
vinf.cycle.filter='off';
vinf.cycle.filter_value=3;
vinf.gradeability.speed=55;
vinf.road_grade.value=1.5;
vinf.parametric.var={'veh_mass','veh_CD','veh_FA'};
vinf.parametric.number_variables=1;
vinf.parametric.low=[eval(vinf.parametric.var{1});eval(vinf.parametric.var{2});eval(vinf.parametric.var{3})];
vinf.parametric.high=vinf.parametric.low+[400; .2; 2];
vinf.parametric.number=[3 3 3];

vinf.model='ADVISOR';

if isfield(vinf,'run_without_gui')
vinf=rmfield(vinf,'run_without_gui');
end

save([filename,'_mod.mat'])

resp=1;

return