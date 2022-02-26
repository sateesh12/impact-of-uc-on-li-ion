function batmodelControl(action)

if nargin==0
    batmodelFig;
    
    %set everything normalized
    h=findobj('type','uicontrol');
    set([h],'units','normalized')
    %_______set the figure size and location
    screensize=get(0,'screensize'); %this should be in pixels(the default)
    figsize=[(screensize(3)-504)/2 (screensize(4)-488)/2 504 488];
    set(gcf,'units','pixels','position',figsize,'visible','on');
    %_____________end set the figure size

    evalin('base','global binf;binf.bitrode=1;');

elseif nargin > 0
   
   global binf	%battery information
   
   switch action
   case 'Bitrode'
      if get(findobj('tag','bitrode box'),'value')
         binf.bitrode=1;
      else
         binf.bitrode=0;
      end
   case 'peukert'
      binf.test_type='peukert';
      select_data_files;
   case 'peukert results'
      binf.test_type='peukert';
      process_data('',1);
   case 'VOC'
      binf.test_type='VOC';
      select_data_files;
   case 'VOC results'
      binf.test_type='VOC';
      process_data('',1);
  case 'RC'
      binf.test_type='RC';
      select_data_files;
  case 'RC results'
      binf.test_type='RC';
      process_data('',1);
  case 'Rint'
      binf.test_type='Rint';
      select_data_files;
   case 'Rint results'
      binf.test_type='Rint';
      process_data('',1);
   case 'plot T variation'
      binf.test_type='Plot_T_Var';
      select_data_files;
  case 'ADVISOR RC model'
      binf.test_type='MakeFile';
      select_data_files;
  case 'ADVISOR model'
      binf.test_type='MakeFile';
      select_data_files;
   case 'validate'
      evalin('base','validate_rc;');
      %helpdlg('Validation of ADVISOR battery files is not yet working');
   case 'load'
      %load binf mat file
      [f p]=uigetfile('*.mat','Existing battery file');
      if f==0
         return
      end
      evalin('base','clear binf');
      evalin('base',['load ''' p f '''']);
      if binf.bitrode
         set(findobj('tag','bitrode box'),'value',1)
      else
         set(findobj('tag','bitrode box'),'value',0)
      end
   case 'change path'
      %load binf mat file
      [f p]=uigetfile('*.mat','Existing battery file');
      if f==0
         return
      end
      evalin('base','clear binf');
      evalin('base',['load ''' p f '''']);
      if binf.bitrode
         set(findobj('tag','bitrode box'),'value',1)
      else
         set(findobj('tag','bitrode box'),'value',0)
      end
      %change the path for 3 cases
      binf.peukert.path=p;
      binf.VOC.path=p;
      binf.Rint.path=p;
      binf.RC.path=p;
      %resave it
      evalin('base',['save ''' p f ''' binf']);
      disp(['Path successfully changed for ',f,' to ',p])
   case 'save'
      evalin('base','global binf;');
      %save binf to mat file
      [f p]=uiputfile('*.mat','Save to file');
      if f==0
         return
      end
      evalin('base',['save ''' p f ''' binf']);
   case 'exit'
      close(gcbf);
   end
end

%Revision history
%03/13/01: vhj created from batmodel, added RC calls, added RC path
%03/19/01: vhj call validate_rc in base workspace
%08/02/01: vhj set binf.bitrode during initial call