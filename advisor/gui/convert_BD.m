function [new_bd_name,flag]=convert_BD(option,choice,bd_name)
%convert_BD: 	plugs the appropriate energy storage block, cs, and/or transmission 
% 			 		into the existing ADVISOR block diagram
%
%option: can be either ess, cs, (or trans)
%choice: for ess can be rc, saber, fund_gen, fund_opt, or nnet
%			for cs can be cost, fuzzy

new_bd_name=[bd_name '_' choice];
%Check to see if desired bd already exists
h=which([new_bd_name '.mdl']);
if ~isempty(h)	%new block diagram already exists-->use it
   flag=0; %flag=1 denotes that a new bd was created
   return
   
else
   flag=1;	%flag=1 denotes that a new bd was created
   %Open block diagram
   open_system(bd_name);
   
   switch option
   case 'ess'
      %Open ess options file
      ess_name='lib_energy_storage'; %name of file with all ess options
      %ess_name='advisor_ess_options'; %name of file with all ess options
      open_system(ess_name)
      %Delete the default energy storage block
      ess_mdl=find_system(bd_name,'Name',['energy' sprintf('\n') 'storage <ess>']);
      posn=get_param(find_system(bd_name,'Name',['energy' sprintf('\n') 'storage <ess>']),'Position');
      delete_block(ess_mdl{1});
      
      switch choice
      case 'fund_gen'	%Fundamental Battery Model, generic
         fund_gen_ess=find_system(ess_name,'Name',['energy storage <ess>' sprintf('\n') 'fundamental model']);
         add_block(fund_gen_ess{1},[bd_name '/energy' sprintf('\n') 'storage <ess>' sprintf('\n') 'fundamental model'],'Position',posn{1});
      case 'fund_opt'	%Fundamental Battery Model, optima hard coded parameters
         fund_opt_ess=find_system(ess_name,'Name',['energy storage <ess>' sprintf('\n') 'optima' sprintf('\n') 'fundamental model']);
         add_block(fund_opt_ess{1},[bd_name '/energy' sprintf('\n') 'storage <ess>' sprintf('\n') 'optima' sprintf('\n') 'fundamental model'],'Position',posn{1});
      case 'nnet' 	%Neural Net Battery Model
         nnet_ess=find_system(ess_name,'Name',['energy' sprintf('\n') 'storage <ess>' sprintf('\n') 'nnet']);
         add_block(nnet_ess{1},[bd_name '/energy' sprintf('\n') 'storage <ess>' sprintf('\n') 'nnet'],'Position',posn{1});
     case 'rc'  %RC battery model
         rc_ess=find_system(ess_name,'Name',['energy' sprintf('\n') 'storage <ess>' sprintf('\n') 'RC']);
         add_block(rc_ess{1},[bd_name '/energy' sprintf('\n') 'storage <ess>' sprintf('\n') 'RC'],'Position',posn{1});
     case 'saber'  %Saber co-simulation with batteries
         saber_ess=find_system(ess_name,'Name',['energy storage <ess>' sprintf('\n') 'Saber']);
         add_block(saber_ess{1},[bd_name '/energy storage <ess>' sprintf('\n') 'Saber'],'Position',posn{1});
     end
      close_system(ess_name);	%close file with options
      
   case 'cs'
      %Open Control Strategy options file
      cs_name='lib_controls'; %name of file with all control strategy options
      open_system(cs_name)
      %Delete the current control strategy block in the model
      cs_mdl=find_system(bd_name,'Name',['electric assist' sprintf('\n') 'control strategy' sprintf('\n') '<cs>']);
      posn=get_param(find_system(bd_name,'Name',['electric assist' sprintf('\n') 'control strategy' sprintf('\n') '<cs>']),'Position');
      delete_block(cs_mdl{1});
      
      switch choice
         
      case 'cost'
         %need to eliminate cs and engine on (vc)
      case 'fuzzy'
         % to change the current Parallel control block with the Fuzzy Control block
         cs_fuzzy=find_system(cs_name,'Name',['Fuzzy Logic' sprintf('\n') 'control strategy' sprintf('\n') '<cs>']);
         add_block(cs_fuzzy{1},[bd_name '/Fuzzy Logic' sprintf('\n') 'control strategy' sprintf('\n') '<cs>'],'Position',posn{1});
      end
      close_system(cs_name);	%close file with options
      
   case 'trans'
      
   end
   
   %Close the block diagram
   %new_bd_name=[bd_name '_' choice];
   save_system(bd_name,new_bd_name);
   close_system(new_bd_name,1);
end

%Revision history
%7/28/99: vhj file created
%8/25/99: vhj nnet ess working
%9/15/99: vhj renamed to convert_BD, accepts bd_name as input, added flag as an output
%9/21/99: vhj fundamental model complete (space error)
%03/27/01: vhj create BD for RC battery model
%01/02/02: vhj create BD for Saber battery cosim
%01/03/02: vhj corrected name for Saber battery cosim ess block