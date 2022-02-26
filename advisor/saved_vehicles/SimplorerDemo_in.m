% SimplorerDemo_in.m  ADVISOR 2002  input file created: 15-Apr-2002 10:43:54

global vinf 

vinf.name='SimplorerDemo_in';
vinf.block_diagram.name='BD_PAR_SimplorerDemo';
vinf.drivetrain.name='custom';
vinf.fuel_converter.name='FC_SI41_emis';
vinf.fuel_converter.ver='ic';
vinf.fuel_converter.type='si';
vinf.torque_coupling.name='TC_DUMMY';
vinf.motor_controller.name='MC_AC75';
vinf.energy_storage.name='ESS_PB25';
vinf.energy_storage.ver='rint';
vinf.energy_storage.type='pb';
vinf.transmission.name='TX_5SPD';
vinf.transmission.ver='man';
vinf.transmission.type='man';
vinf.wheel_axle.name='WH_SMCAR';
vinf.wheel_axle.ver='Crr';
vinf.wheel_axle.type='Crr';
vinf.vehicle.name='VEH_SMCAR';
vinf.exhaust_aftertreat.name='EX_SI';
vinf.powertrain_control.name='PTC_PAR';
vinf.powertrain_control.ver='par';
vinf.powertrain_control.type='man';
vinf.accessory.name='ACC_HYBRID';
vinf.accessory.ver='Const';
vinf.accessory.type='Const';


% smlsmlkFile='c:\winnt\smlsmlk50.ini';
% if ~exist(smlsmlkFile)
%     smlsmlkDefaultFile=which('smlsmlk50.ini');
%     copyfile(smlsmlkDefaultFile,smlsmlkFile);
% end