function convert_battery_tables2
% Function to translate battery files from ADVISOR into a form
% readable in Saber using the saber include block.  
% 
% The purpose is to have an easily defineable block to
% change the motor file within a schematic.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     NOTE - Use with r internal battery model ONLY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global vinf

if (strcmp(vinf.energy_storage2.ver,'rint'))
    
    SaberPath=strrep(which('advisor.m'),'advisor.m','models\Saber\');

    ess_coulombic_eff_file = [SaberPath,'ess_coulombic_eff_2.ai_dat'];
    ess_max_ahr_cap_file = [SaberPath,'ess_max_ahr_cap_2.ai_dat'];
    ess_r_chg_file = [SaberPath,'ess_r_chg_2.ai_dat'];
    ess_r_dischg_file = [SaberPath,'ess_r_dischg_2.ai_dat'];
    ess_voc_file = [SaberPath,'ess_voc_2.ai_dat'];
    alter_rint_battery = [SaberPath,'alter_nrel_battery_2.scs'];
    
    %   Get required variables from workspace
    RequiredVars={'ess2_description'
        'ess2_soc'
        'ess2_tmp'
        'ess2_voc'
        'ess2_max_ah_cap'
        'ess2_r_dis'
        'ess2_r_chg'
        'ess2_coulombic_eff'
        'amb_tmp'
        'ess2_module_num'
        'ess2_max_volts'
        'ess2_min_volts'
        'ess2_init_soc'
        'ess2_description'
    };
    
    for i=1:length(RequiredVars)
        try
            eval([RequiredVars{i},'=evalin(''base'',''',RequiredVars{i},''');']);
        end
    end
    
    num_soc = size(ess2_soc);
    num_tmp=size(ess2_tmp);
    
    fid = fopen(ess_voc_file,'wt');
    fprintf(fid,'#========================================================================\n');
    fprintf(fid,'#   VOC (open cell voltage) LOOKUP TABLE                                 \n');
    fprintf(fid,'#                                                                     \n');
    fprintf(fid,'#   Saber model parameters for battery table lookup model used in         \n');
    fprintf(fid,'#   NREL cosimulation of series and parallel hybrid vehicles          \n');
    fprintf(fid,'#                                                                     \n');
    fprintf(fid,['#   ',ess2_description,'    \n']);
    fprintf(fid,['#   ',vinf.energy_storage2.name,'.m         \n']);
    fprintf(fid,'#                                                                     \n');
    fprintf(fid,'#   SOC     Temperature (C)         VOC (volts)                  \n');
    fprintf(fid,'#========================================================================\n\n');
    
    %saber_motor_matrix=zeros(3,num_spds(:,2)*num_trqs(:,2));
    for i=1:num_soc(:,2)
        for j=1:num_tmp(:,2)
            data_row=[ess2_soc(i),ess2_tmp(j),ess2_voc(j,i)];
            fprintf(fid,[num2str(data_row),'\n']);
        end
    end
    fclose (fid);
    
    
    fid = fopen(ess_r_dischg_file,'wt');
    fprintf(fid,'#========================================================================\n');
    fprintf(fid,'#   DISCHARGE RESISTANCE LOOKUP TABLE                                 \n');
    fprintf(fid,'#                                                                     \n');
    fprintf(fid,'#   Saber model parameters for battery table lookup model used in         \n');
    fprintf(fid,'#   NREL cosimulation of series and parallel hybrid vehicles          \n');
    fprintf(fid,'#                                                                     \n');
    fprintf(fid,['#   ',ess2_description,'    \n']);
    fprintf(fid,['#   ',vinf.energy_storage2.name,'.m         \n']);
    fprintf(fid,'#                                                                     \n');
    fprintf(fid,'#   SOC     Temperature (C)         Resistance (Ohms)                  \n');
    fprintf(fid,'#========================================================================\n\n');
    
    for i=1:num_soc(:,2)
        for j=1:num_tmp(:,2)
            data_row=[ess2_soc(i),ess2_tmp(j),ess2_r_dis(j,i)];
            fprintf(fid,[num2str(data_row),'\n']);
        end
    end
    fclose (fid);
    
    
    
    fid = fopen(ess_r_chg_file,'wt');
    fprintf(fid,'#========================================================================\n');
    fprintf(fid,'#   CHARGE RESISTANCE LOOKUP TABLE                                 \n');
    fprintf(fid,'#                                                                     \n');
    fprintf(fid,'#   Saber model parameters for battery table lookup model used in         \n');
    fprintf(fid,'#   NREL cosimulation of series and parallel hybrid vehicles          \n');
    fprintf(fid,'#                                                                     \n');
    fprintf(fid,['#   ',ess2_description,'    \n']);
    fprintf(fid,['#   ',vinf.energy_storage2.name,'.m         \n']);
    fprintf(fid,'#                                                                     \n');
    fprintf(fid,'#   SOC     Temperature (C)         Resistance (Ohms)                  \n');
    fprintf(fid,'#========================================================================\n\n');
    
    for i=1:num_soc(:,2)
        for j=1:num_tmp(:,2)
            data_row=[ess2_soc(i),ess2_tmp(j),ess2_r_chg(j,i)];
            fprintf(fid,[num2str(data_row),'\n']);
        end
    end
    fclose (fid);
    
    fid = fopen(ess_coulombic_eff_file,'wt');
    fprintf(fid,'#========================================================================\n');
    fprintf(fid,'#   COULOMBIC EFFICIENCY LOOKUP TABLE                                 \n');
    fprintf(fid,'#                                                                     \n');
    fprintf(fid,'#   Saber model parameters for battery table lookup model used in         \n');
    fprintf(fid,'#   NREL cosimulation of series and parallel hybrid vehicles          \n');
    fprintf(fid,'#                                                                     \n');
    fprintf(fid,['#   ',ess2_description,'    \n']);
    fprintf(fid,['#   ',vinf.energy_storage2.name,'.m         \n']);
    fprintf(fid,'#                                                                     \n');
    fprintf(fid,'#   Temperature (C)      COULOMBIC EFFICIENCY                     \n');
    fprintf(fid,'#========================================================================\n\n');
    
    for i=1:num_tmp(:,2)    
        fprintf(fid,[num2str(ess2_tmp(i)),'   ',num2str(ess2_coulombic_eff(i)),'\n']);
    end
    
    fclose (fid);
    
    fid = fopen(ess_max_ahr_cap_file,'wt');
    fprintf(fid,'#========================================================================\n');
    fprintf(fid,'#   MAX Ahr CAPACITY  LOOKUP TABLE                                 \n');
    fprintf(fid,'#                                                                     \n');
    fprintf(fid,'#   Saber model parameters for battery table lookup model used in         \n');
    fprintf(fid,'#   NREL cosimulation of series and parallel hybrid vehicles          \n');
    fprintf(fid,'#                                                                     \n');
    fprintf(fid,['#   ',ess2_description,'    \n']);
    fprintf(fid,['#   ',vinf.energy_storage2.name,'.m         \n']);
    fprintf(fid,'#                                                                     \n');
    fprintf(fid,'#   Temperature (C)      MAX Ahr CAPACITY                     \n');
    fprintf(fid,'#========================================================================\n\n');
    
    for i=1:num_tmp(:,2)    
        fprintf(fid,[num2str(ess2_tmp(i)),'   ',num2str(ess2_max_ah_cap(i)),'\n']);
    end
    
    fclose (fid);
    
    fid = fopen(alter_rint_battery,'wt');
    fprintf(fid,'#========================================================================\n');
    fprintf(fid,'#                                                                        \n');
    fprintf(fid,'#   Saber model parameters for battery table lookup model used in         \n');
    fprintf(fid,'#   NREL cosimulation of series and parallel hybrid vehicles          \n');
    fprintf(fid,'#                                                                     \n');
    fprintf(fid,['#   ',ess2_description,'    \n']);
    fprintf(fid,['#   ',vinf.energy_storage2.name,'.m         \n']);
    fprintf(fid,'#   Used for the netlist form of the r_internal battery model            \n');
    fprintf(fid,'#========================================================================\n\n');
    
    fprintf(fid,'#   This parameter sets the initial ambient temperature (C) for         \n');
    fprintf(fid,'#   the battery.  This param will be altered each time step based upon  \n');
    fprintf(fid,'#   the underhood temperature                                           \n');
    if exist('amb_tmp')
        fprintf(fid,['alter /r_int_battery.r_int_battery_2/temp_input = ',num2str(amb_tmp),'\n\n']);
    else
        fprintf(fid,['alter /r_int_battery.r_int_battery_2/temp_input = 25 \n']);
    end
    
    fprintf(fid,'#   These parameters are altered ONCE at the beginning of the simulation. \n');
    fprintf(fid,['alter /r_int_battery.r_int_battery_2/ess2_modnum = ',num2str(ess2_module_num),'\n']);
    fprintf(fid,['alter /r_int_battery.r_int_battery_2/ess2_maxvolts = ',num2str(ess2_max_volts),'\n']);
    fprintf(fid,['alter /r_int_battery.r_int_battery_2/ess2_minvolts = ',num2str(ess2_min_volts),'\n']);
    if exist('ess2_init_soc')
        fprintf(fid,['alter /r_int_battery.r_int_battery_2/ess2_initsoc = ',num2str(ess2_init_soc),'\n']);
    else
        fprintf(fid,['alter /r_int_battery.r_int_battery_2/ess2_initsoc = 0.8 \n']);
    end
    fclose(fid);
    
%     disp('co-sim data conversion');
    disp('Done converting battery 2 file for cosim');
%     disp([vinf.energy_storage.name,' - ',ess_description]);
    
else
    msgbox('convert_battery_tables routing used ONLY with rint battery model');
    disp('FAILED: Battery Conversion');
end    