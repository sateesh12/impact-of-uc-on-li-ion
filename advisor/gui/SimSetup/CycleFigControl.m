%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name of the file      : CycleFigControl.m                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description           :                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by            : Sylvain Pagerit ANL - PSAT (08/31/00)      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Other necessary files :                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data provided by      :                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modified by           : SS-NREL for ADVISOR USE (1/25/01) see      %
%                         comments at end of file                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remarks : Designed by ANL for PSAT 4.0                             %
% This file modified for use in ADVISOR 3.1                          %
% NREL appreciates the efforts put forth by ANL for this function    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function CycleFigControl(option, pop_menu)

%this function is for control of the Multi Cycles Choice Figure 

global vinf

if nargin == 0
    
    h_wait = waitbar(0,'Loading the Cycle Window...');
    waitbar(.1)
    
    
    CycleFigHandle = CycleFig;
    
    set(CycleFigHandle, 'windowstyle','modal'); %don't allow user to go to another window
    
    waitbar(.3)
    
    %assume TripBuilder called unless vinf.multi_cycles.run=='on'  
    %set the name for the figure
    if strcmp('on',vinf.multi_cycles.run)
        vinf.trip.run='off';
        set(CycleFigHandle, 'Name', ['Multi Cycles Process--', advisor_ver('info')])
        mode = 'multi_cycles';
        
    else
        vinf.trip.run='on';
        set(CycleFigHandle, 'Name', ['Trip Building--', advisor_ver('info')])
        set(findobj('string','Ok'),'string','Save \ Ok','FontSize',8)
        mode = 'trip';
        
    end
    
    waitbar(.4)
    
    %set everything normalized and set the figure size and center it
    h = findobj('type', 'uicontrol');
    g = findobj('type', 'axes');
    
    set([h; g], 'units', 'normalized');
    
    set(CycleFigHandle, 'units', 'pixels', 'position', vinf.gui_size);
    
    clean_cycle_axes
    
    waitbar(.5)
    
    %list of cycles available with 'none' as the first one
    list_cycle = [{'none'};optionlist('get','cycles')];
    
    if eval(['isfield(vinf.',mode,',''name'')'])
        
        select_cycles = eval(['vinf.',mode,'.name']);
        num_select_cycles = eval(['vinf.',mode,'.number']);
        
        number_of_cycles = length(select_cycles);
        
        for i = 1:number_of_cycles
            
            set(findobj('tag', ['num_cycle', num2str(i)]), 'string', num2str(num_select_cycles{i}));
            
            set(findobj('tag', ['cycle', num2str(i)]), 'string', list_cycle);
            set(findobj('tag', ['cycle', num2str(i)]), 'value', 1 + optionlist('value','cycles',select_cycles{i}));	%+1 because of 'none'
        end
    else
        
        number_of_cycles = 0;
    end
    
    waitbar(.7)
    
    for i = 1+number_of_cycles:8
        
        set(findobj('tag', ['num_cycle', num2str(i)]), 'string', '1');
        set(findobj('tag', ['num_cycle', num2str(i)]), 'enable', 'off');
        
        set(findobj('tag', ['cycle', num2str(i)]), 'string', list_cycle);
        set(findobj('tag', ['cycle', num2str(i)]), 'value', 1);
        set(findobj('tag', ['cycle', num2str(i)]), 'enable', 'off');
    end
    
    set(findobj('tag', ['num_cycle', num2str(number_of_cycles+1)]), 'enable', 'on');
    set(findobj('tag', ['cycle', num2str(number_of_cycles+1)]), 'enable', 'on');
    
    waitbar(.8)
    
    CycleFigControl('cycle',['cycle', num2str(number_of_cycles+1)]);
    
    waitbar(.9)
    
    set(CycleFigHandle,'Visible','on')
    
    waitbar(1)
    close(h_wait)
    
else
    
    switch option
    case 'cycle'
        
        h_wait = waitbar(0,'Plotting...');
        waitbar(0.05,h_wait)
        
        %get the number of the cycle
        num_pop = pop_menu(end);
        
        %Remove undefined axes and titles
        clean_cycle_axes
        
        waitbar(0.1,h_wait)
        
        %Choose the algorithm depending on the mode (Multi Cycles or Trip)
        if strcmp(vinf.trip.run,'on')
            
            evalin('base','clear cyc* vc_key_on');
            
            num_plot = 1;
            
            for i = 1:8
                
                waitbar(0.1 + i * 0.6/ 8,h_wait)
                
                cycle = gui_current_str(['cycle',num2str(i)]);
                
                if strcmp(cycle,'none')
                    break
                end
                
                num_cycle = get(findobj('tag',['num_cycle',num2str(i)]), 'string');
                
                if i == 1
                    title_cycle = [cycle,' x ',num_cycle];
                else
                    title_cycle = [title_cycle,' + ',cycle,' x ',num_cycle];
                end
                
                for j = 1:str2num(num_cycle)
                    
                    
                    %run to make variables available
                    %remember i and j because they sometimes get cleared (ex. CYC_NREL2VAIL)
                    ij=[i j];
                    eval(cycle);
                    i=ij(1);
                    j=ij(2);
                    
                    
                    % build cycle grade vector if not defined tm:8/23/99
                    if size(cyc_grade,2) < 2
                        cyc_grade = [0 cyc_grade; 1 cyc_grade]; 
                     end
                     
                    % build cycle cargo-mass vector if not defined mpo:19-July 2001
                    if size(cyc_cargo_mass,2) < 2
                        cyc_cargo_mass = [0 cyc_cargo_mass; 1 cyc_cargo_mass]; 
                    end
                    
                    if evalin('base','exist(''cyc_mph'')')
                       % <!-- begin mpo addition 20 July 2001
                       if evalin('base','cyc_mph(1,1)~=0')
                          evalin('base','cyc_mph(:,1)=cyc_mph(:,1)-cyc_mph(1,1);'); % set to zero so as not to duplicate
                          % ...datapoints
                       end
                       if cyc_mph(1,1)~=0
                          cyc_mph(:,1)=cyc_mph(:,1)-cyc_mph(1,1);
                       end
                       % end mpo addition -->
                       
                        t_max_cycle = evalin('base','max(cyc_mph(:,1))');
                        t_max_key_on = evalin('base','max(vc_key_on(:,1))');
                        t_max_grade = evalin('base','max(cyc_grade(:,1))');
                        % note--cargo-mass specified over distance:
                        %d_max_cargo_mass = evalin('base','max(cyc_cargo_mass(:,1))'); 
                        
                        %step = cyc_grade(2,1) - cyc_grade(1,1);
                        step = 1; % time step between appended cycles--hardcoded at this time
                        
                        cyc_mph_tmp = evalin('base','cyc_mph');
                        vc_key_on_tmp = evalin('base','vc_key_on');
                        cyc_grade_tmp = evalin('base','cyc_grade');
                        cyc_cargo_mass_tmp = evalin('base','cyc_cargo_mass');
                        
                        cyc_mph = [[cyc_mph_tmp(:,1); (cyc_mph(:,1) + t_max_cycle + step)],...
                                [cyc_mph_tmp(:,2); cyc_mph(:,2)]];
                        
                        vc_key_on = [[vc_key_on_tmp(:,1); (vc_key_on(:,1) + t_max_key_on + step)],...
                                [vc_key_on_tmp(:,2); vc_key_on(:,2)]];
                        
                        cyc_grade = [0 0;1 0]; %no grade support for now
                        cyc_cargo_mass = [0 0;1 0]; %no variable cargo-mass support for now
                    end
                    
                    assignin('base','cyc_mph',cyc_mph);
                    assignin('base','vc_key_on',vc_key_on);
                    assignin('base','cyc_grade',cyc_grade);
                    assignin('base','cyc_cargo_mass',cyc_cargo_mass);
                end
            end
        else
            
            for i = 1:8
                cycle = gui_current_str(['cycle',num2str(i)]);
                
                waitbar(0.1 + i * 0.2 / 8,h_wait)
                
                if strcmp(cycle,'none')
                    num_plot = i - 1;
                    break
                end
            end
        end
        
        if ~exist('num_plot')
            num_plot = 8;
            
        elseif strcmp(gui_current_str('cycle1'),'none')
            waitbar(1)
            close(h_wait)
            
            delete(findobj(gcf,'type','line'));
            
            titles = get(findobj(gcf,'type','axes'),'Title');
            
            for i = 1:length(titles)
                delete(titles{i})
            end
            
            return
        end
        
        for i = 1:num_plot
            hold off
            
            if strcmp(vinf.multi_cycles.run,'on')
                
                waitbar(0.3 + i * 0.6 / num_plot)
                
                num_cycle = get(findobj('tag',['num_cycle',num2str(i)]), 'string');
                
                cycle = gui_current_str(['cycle',num2str(i)]);
                
                
                %run to make variables available
                %remember i and j because they sometimes get cleared (ex. CYC_NREL2VAIL)
                ij=[i];
                eval(cycle);
                i=ij(1);
                                
                % build cycle grade vector if not defined tm:8/23/99
                if size(cyc_grade,2) < 2
                    cyc_grade = [0 cyc_grade; 1 cyc_grade]; 
                end
            else
                waitbar(0.8)
            end
            
            %obtain distance from cyc_mph variable
            distance = cumtrapz(cyc_mph(:,1)./3600, cyc_mph(:,2));
            
            if strcmp(vinf.trip.run,'on')
                h = findobj('tag','axe trip');
            else
                h = findobj('tag',['axe cycle',num2str(i)]);
            end
            
            axes(h)
            cla
            
            hold on
            
            plot(vc_key_on(:,1),vc_key_on(:,2),'r');
            
            %Create the plotyy graph.  The handle(s) to the lines in the left axis are in h1 and the handles
            %to the second axis lines are in h2.  ax contains the handles to the two axes created.
            [ax,h1,h2] = plotyy(cyc_mph(:,1), cyc_mph(:,2) , cyc_mph(:,1), interp1(cyc_grade(:,1),cyc_grade(:,2),cyc_mph(:,1)),'plot','plot');
            
            pos_axe = get(h,'position');
            
            h_axes = findobj(gcf,'type','axes');
            
            pos_axes = get(h_axes,'position');
            
            n_pos = length(pos_axes);
            
            pos_axes = [pos_axes{:}];
            pos_axes = reshape(pos_axes, 4, n_pos);
            pos_axes = pos_axes';
            
            index_axe1 = find(pos_axes(:,1) == pos_axe(1));
            
            h_axes = h_axes(index_axe1);
            pos_axes = pos_axes(index_axe1,:);
            
            index_axe2 = find(pos_axes(:,2) == pos_axe(2));
            
            h_axes = h_axes(index_axe2);
            pos_axes = pos_axes(index_axe2,:);
            
            set(h_axes,'xlim',[0 max(cyc_mph(:,1))]);
            ylim('auto')
            
            if strcmp(vinf.trip.run,'on')
                title(strrep(title_cycle,'_',' '))
            else
                title(strrep([cycle,' x ',num_cycle],'_',' '))
            end
            
            waitbar(0.9)
            
            %make the second axes current (the axes with a color of 'none') so that both lines are visible
            axes(ax(2))
        end
        
        waitbar(1)
        close(h_wait)
        
    case 'num_cycle'
        
        num_pop = pop_menu(end);
        
        if strcmp(vinf.trip.run,'on')
            CycleFigControl('cycle',['cycle',num_pop]);
        else
            h = findobj('tag',['axe cycle',num_pop]);
            
            axes(h)
            
            cycle = gui_current_str(['cycle',num_pop]);
            num_cycle = get(findobj('tag',pop_menu), 'string');
            
            title(strrep([cycle,' x ',num_cycle],'_',' '))
        end
        
    case 'enable cycle'
        
        for i = 2:8
            
            if ~strcmp(gui_current_str(['cycle', num2str(i-1)]), 'none')
                set(findobj('tag', ['cycle', num2str(i)]), 'enable', 'on');
                set(findobj('tag', ['num_cycle', num2str(i)]), 'enable', 'on');
                
            else
                set(findobj('tag', ['cycle', num2str(i)]), 'enable', 'off', 'value', 1);
                set(findobj('tag', ['num_cycle', num2str(i)]), 'enable', 'off', 'string', '1');
            end
        end
        
     case 'ok'
        
        if strcmp(vinf.trip.run,'on')
           
           %used with optionlist
           listname = 'cycles';
           
           %change the directory to the drive_cycle directory
           tmp_dir = pwd; %store the current working directory to return to later
           advisor_top_dir = fileparts(which('advisor.m'));
           save_dir = fullfile(advisor_top_dir,'data', 'drive_cycle');
           cd(save_dir)
           
           %get the filename and path where user wants to save the trip
           [filename, pathname] = uiputfile('trip_*.m');	%user input for name to save trip (similar to cycle file)
           users_filename=filename; %used later to see if filename is changed from what user chose 
           
           % restore to the working directory that the user was in before
           cd(tmp_dir)
           
           %if new file name not selected (cancel,etc) return out of this case
           if filename == 0
              return
           end
          
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           %make sure file name is in the form 'trip_*.m'  a 'trip_*.mat' will also be saved
           test = findstr(filename, 'trip_');
           
           if isempty(test) | test(1) ~= 1
              filename = ['trip_',filename];
           end
           
           test = findstr(filename, '.m');
           
           if isempty(test) | test ~= (length(filename) - 1)
              test_point = findstr(filename, '.');
              
              if isempty(test_point)
                 filename = [filename,'.m'];
              else
                 filename = [filename(1:(test_point(1)-1)),'.m'];
              end
           end
           
           if ~strcmp(users_filename,filename)
              warndlg(['The file will be saved with the name ',filename]);
              uiwait(gcf)
           end
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           
           %save the necessary variables to the trip_*.mat file
           mat_filename=strrep(filename,'.m','.mat');
           evalin('base', ['save ''', pathname, mat_filename,''' cyc_mph vc_key_on cyc_grade cyc_cargo_mass']);
           
           %save the m-file for the trip
           fid=fopen([pathname filename],'wt+');
           fprintf(fid,'%%automatic save from building a trip\n\n');
           fprintf(fid,['cyc_description=''' filename ''';\n']);
           fprintf(fid,['cyc_version=' advisor_ver('number') ';\n']);
           fprintf(fid,'cyc_proprietary=0;\n');
           fprintf(fid,'cyc_validation=0;\n');
			  fprintf(fid,['load ' mat_filename '\n\n']);
           
           fprintf(fid,['cyc_avg_time=1;  %% (s)\n']);
           fprintf(fid,'cyc_filter_bool=0;\n');
           fprintf(fid,'cyc_elevation_init=0;\n\n');
           fprintf(fid,'%%Revision History:\n');
           fprintf(fid,['%% automatically created in ' advisor_ver('info') 'on ' date]);
           
           fclose(fid);
           
           cycle_name=strrep(filename,'.m','');
           list=optionlist('add','cycles',cycle_name);
           
           %make the file name the new string for the list
           
           value = optionlist('value', 'cycles', cycle_name);
           
           h = findobj('tag','cycles');
           
           set(h, 'string', list, 'value', value);
           
           vinf.trip.run = 'off';
           
           close(gcf)
           
           callback=get(h,'callback');
           callback(gcf,0);
           
        else %multi-cycle run ok
           vinf.multi_cycles.name = {};
           vinf.multi_cycles.number = {};
           
           evalin('base','cycle_choice = [];');
           evalin('base','times_cycle = [];');
           
           for i = 1:8
              
              name_cycle = gui_current_str(['cycle', num2str(i)]);
              time_cycle = str2num(get(findobj('tag',['num_cycle', num2str(i)]),'String'));
              
              if ~strcmp(name_cycle, 'none')
                 vinf.multi_cycles.name{end+1, 1} = name_cycle;
                 vinf.multi_cycles.number{end+1, 1} = time_cycle;
                 
                 
              end
           end
           
           close(gcbf)
           
           set(findobj('tag','multi_cycles_popupmenu'),'string',vinf.multi_cycles.name)
        end
        
 
    case 'help'
        if strcmp(vinf.trip.run,'on')
            load_in_browser('advisor_ch2.html', '#trip_bld');
        else
            load_in_browser('advisor_ch2.html', '#mult_cyc');
        end
        
    case 'load'
        
        [f,p] = uigetfile('trip_*.mat');
        
        if f == 0
           return
        end
        
        evalin('base',['load ',p,f])
        
        evalin('base','vinf.trip = trip;')
        
        evalin('base','clear trip')
        
        CycleFigControl
        
     otherwise
     end
     
  end
  
  %1/29/01 ss changed code to run trip properly in ADVISOR (grade is assumed to be 0 for now)
  %19-July-2001 mpo changed code to run with ADVISOR 3.2--added cyc_cargo_mass dummy variable (assumed to be 0 for now)
  %20-July-2001 mpo updated code for appending drive cycles. time sequences no longer overlay (i.e., duplicate time values)
  % ................a one second separation time has been arbitrarily chosen to separate the end of one cycle from
  % ................the beginning of another. 
  
  
  
  
