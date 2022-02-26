function convert_battery_tables
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

if (strcmp(vinf.energy_storage.ver,'rint'))
    
    SaberPath=strrep(which('advisor.m'),'advisor.m','models\Saber\');

    ess_coulombic_eff_file = [SaberPath,'ess_coulombic_eff.ai_dat'];
    ess_max_ahr_cap_file = [SaberPath,'ess_max_ahr_cap.ai_dat'];
    ess_r_chg_file = [SaberPath,'ess_r_chg.ai_dat'];
    ess_r_dischg_file = [SaberPath,'ess_r_dischg.ai_dat'];
    ess_voc_file = [SaberPath,'ess_voc.ai_dat'];
    alter_rint_battery = [SaberPath,'alter_nrel_battery.scs'];
    
    %   Get required variables from workspace
    RequiredVars={'ess_description'
        'ess_soc'
        'ess_tmp'
        'ess_voc'
        'ess_max_ah_cap'
        'ess_r_dis'
        'ess_r_chg'
        'ess_coulombic_eff'
        'amb_tmp'
        'ess_module_num'
        'ess_max_volts'
        'ess_min_volts'
        'ess_init_soc'
        'ess_description'
    };
    
    for i=1:length(RequiredVars)
        try
            eval([RequiredVars{i},'=evalin(''base'',''',RequiredVars{i},''');']);
        end
    end
    
    num_soc = size(ess_soc);
    num_tmp=size(ess_tmp);
    
    fid = fopen(ess_voc_file,'wt');
    fprintf(fid,'#========================================================================\n');
    fprintf(fid,'#   VOC (open cell voltage) LOOKUP TABLE                                 \n');
    fprintf(fid,'#                                                                     \n');
    fprintf(fid,'#   Saber model parameters for battery table lookup model used in         \n');
    fprintf(fid,'#   NREL cosimulation of series and parallel hybrid vehicles          \n');
    fprintf(fid,'#                                                                     \n');
    fprintf(fid,['#   ',ess_description,'    \n']);
    fprintf(fid,['#   ',vinf.energy_storage.name,'.m         \n']);
    fprintf(fid,'#                                                                     \n');
    fprintf(fid,'#   SOC     Temperature (C)         VOC (volts)                  \n');
    fprintf(fid,'#========================================================================\n\n');
    
    %saber_motor_matrix=zeros(3,num_spds(:,2)*num_trqs(:,2));
    for i=1:num_soc(:,2)
        for j=1:num_tmp(:,2)
            data_row=[ess_soc(i),ess_tmp(j),ess_voc(j,i)];
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
    fprintf(fid,['#   ',ess_description,'    \n']);
    fprintf(fid,['#   ',vinf.energy_storage.name,'.m         \n']);
    fprintf(fid,'#                                                                     \n');
    fprintf(fid,'#   SOC     Temperature (C)         Resistance (Ohms)                  \n');
    fprintf(fid,'#========================================================================\n\n');
    
    for i=1:num_soc(:,2)
        for j=1:num_tmp(:,2)
            data_row=[ess_soc(i),ess_tmp(j),ess_r_dis(j,i)];
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
    fprintf(fid,['#   ',ess_description,'    \n']);
    fprintf(fid,['#   ',vinf.energy_storage.name,'.m         \n']);
    fprintf(fid,'#                                                                     \n');
    fprintf(fid,'#   SOC     Temperature (C)         Resistance (Ohms)                  \n');
    fprintf(fid,'#========================================================================\n\n');
    
    for i=1:num_soc(:,2)
        for j=1:num_tmp(:,2)
            data_row=[ess_soc(i),ess_tmp(j),ess_r_chg(j,i)];
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
    fprintf(fid,['#   ',ess_description,'    \n']);
    fprintf(fid,['#   ',vinf.energy_storage.name,'.m         \n']);
    fprintf(fid,'#                                                                     \n');
    fprintf(fid,'#   Temperature (C)      COULOMBIC EFFICIENCY                     \n');
    fprintf(fid,'#========================================================================\n\n');
    
    for i=1:num_tmp(:,2)    
        fprintf(fid,[num2str(ess_tmp(i)),'   ',num2str(ess_coulombic_eff(i)),'\n']);
    end
    
    fclose (fid);
    
    fid = fopen(ess_max_ahr_cap_file,'wt');
    fprintf(fid,'#========================================================================\n');
    fprintf(fid,'#   MAX Ahr CAPACITY  LOOKUP TABLE                                 \n');
    fprintf(fid,'#                                                                     \n');
    fprintf(fid,'#   Saber model parameters for battery table lookup model used in         \n');
    fprintf(fid,'#   NREL cosimulation of series and parallel hybrid vehicles          \n');
    fprintf(fid,'#                                                                     \n');
    fprintf(fid,['#   ',ess_description,'    \n']);
    fprintf(fid,['#   ',vinf.energy_storage.name,'.m         \n']);
    fprintf(fid,'#                                                                     \n');
    fprintf(fid,'#   Temperature (C)      MAX Ahr CAPACITY                     \n');
    fprintf(fid,'#========================================================================\n\n');
    
    for i=1:num_tmp(:,2)    
        fprintf(fid,[num2str(ess_tmp(i)),'   ',num2str(ess_max_ah_cap(i)),'\n']);
    end
    
    fclose (fid);
    
    fid = fopen(alter_rint_battery,'wt');
    fprintf(fid,'#========================================================================\n');
    fprintf(fid,'#                                                                        \n');
    fprintf(fid,'#   Saber model parameters for battery table lookup model used in         \n');
    fprintf(fid,'#   NREL cosimulation of series and parallel hybrid vehicles          \n');
    fprintf(fid,'#                                                                     \n');
    fprintf(fid,['#   ',ess_description,'    \n']);
    fprintf(fid,['#   ',vinf.energy_storage.name,'.m         \n']);
    fprintf(fid,'#   Used for the netlist form of the r_internal battery model            \n');
    fprintf(fid,'#========================================================================\n\n');
    
    fprintf(fid,'#   This parameter sets the initial ambient temperature (C) for         \n');
    fprintf(fid,'#   the battery.  This param will be altered each time step based upon  \n');
    fprintf(fid,'#   the underhood temperature                                           \n');
    if exist('amb_tmp')
        fprintf(fid,['alter /r_int_battery.r_int_battery_1/temp_input = ',num2str(amb_tmp),'\n\n']);
    else
        fprintf(fid,['alter /r_int_battery.r_int_battery_1/temp_input = 25 \n']);
    end
    
    fprintf(fid,'#   These parameters are altered ONCE at the beginning of the simulation. \n');
    fprintf(fid,['alter /r_int_battery.r_int_battery_1/ess_modnum = ',num2str(ess_module_num),'\n']);
    fprintf(fid,['alter /r_int_battery.r_int_battery_1/ess_maxvolts = ',num2str(ess_max_volts),'\n']);
    fprintf(fid,['alter /r_int_battery.r_int_battery_1/ess_minvolts = ',num2str(ess_min_volts),'\n']);
    if exist('ess_init_soc')
        fprintf(fid,['alter /r_int_battery.r_int_battery_1/ess_initsoc = ',num2str(ess_init_soc),'\n']);
    else
        fprintf(fid,['alter /r_int_battery.r_int_battery_1/ess_initsoc = 0.8 \n']);
    end
    fclose(fid);
    
%     disp('co-sim data conversion');
    disp('Done converting battery file for cosim');
%     disp([vinf.energy_storage.name,' - ',ess_description]);
    
else
    msgbox('convert_battery_tables routing used ONLY with rint battery model');
    disp('FAILED: Battery Conversion');
end    