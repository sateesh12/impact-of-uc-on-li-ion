function run_condor

stamp=datestr(datenum(now),30);
origWork=pwd;
advisorRoot=strrep(which('advisor.m'),'\advisor.m','');
condorWork=[advisorRoot,'\condor'];
fullPath=[condorWork,'\',stamp];
eval(['cd ''',condorWork,''''])
eval(['!mkdir ',stamp])
eval(['!copy advisor_dist.sub "',stamp,'\advisor_dist.sub"'])
eval(['!copy advisor_dist.bat "',stamp,'\advisor_dist.bat"'])
eval(['cd ',stamp])
evalin('base','save mySimWks.mat')
[status,result]=dos('condor_submit advisor_dist.sub');

if status==0
    h=msgbox(result,'Condor Status');
else
    h=msgbox('Condor error','Condor Status');
end

eval(['cd ''',origWork,''''])

return
