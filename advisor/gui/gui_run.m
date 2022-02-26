%
% Commands executed when RUN button is pushed from cycle setup figure
%

global vinf;
deltaSOC_tol=vinf.cycle.SOCtol/100;	%tolerance for zero delta SOC correction, given by user in %
max_zero_delta_iter=vinf.cycle.SOCiter;  % maximum number of zero delta soc iterations

if strcmp(vinf.test.run,'on')
    eval(vinf.test.name)
    return
end

% build cycle grade vector if not defined tm:8/23/99
if evalin('base','size(cyc_grade,2)')<2
    evalin('base',['cyc_grade=[0 cyc_grade; 1 cyc_grade];']) 
end

%message to user that simulation is running
if strcmp(vinf.parametric.run,'off')& ~isfield(vinf,'run_without_gui')
    waitbar(0,'Simulation in progress.  See command window for updates.');
    waitbar(0.2);
end

%if the acceleration is on, but parametric is off and cycle is not Accel, run the acceleration test
if strcmp(vinf.acceleration.run,'on')&~strcmp(vinf.cycle.name,'CYC_ACCEL')%&strcmp(vinf.parametric.run,'off')
    
    if ~isfield(vinf,'accel_test')
        AccelFigControl
        uiwait(gcf)
    end
    
    str=[];
    if vinf.accel_test.param.active(1)
        value=eval(['vinf.accel_test.param.gb_shift_delay']);
        str=[str,'''','gb_shift_delay',''',',mat2str(value),','];
    end
    if vinf.accel_test.param.active(2)
        value=eval(['vinf.accel_test.param.ess_init_soc']);
        str=[str,'''','ess_init_soc',''',',mat2str(value),','];
    end
    mat=[];
    if vinf.accel_test.param.active(3)
        mat=[mat; vinf.accel_test.param.spds1];
    end
    if vinf.accel_test.param.active(4)
        mat=[mat; vinf.accel_test.param.spds2];
    end
    if vinf.accel_test.param.active(5)
        mat=[mat; vinf.accel_test.param.spds3];
    end
    if ~isempty(mat)
        str=[str,'''','spds',''',',mat2str(mat),','];
    end
    if vinf.accel_test.param.active(6)
        value=eval(['vinf.accel_test.param.dist_in_time']);
        str=[str,'''','dist_in_time',''',',mat2str(value),','];
    end
    if vinf.accel_test.param.active(7)
        value=eval(['vinf.accel_test.param.time_in_dist']);
        str=[str,'''','time_in_dist',''',',mat2str(value),','];
    end
    if vinf.accel_test.param.active(8)
        value=eval(['vinf.accel_test.param.max_rate_bool']);
        str=[str,'''','max_rate_bool',''',',mat2str(value),','];
    end
    if vinf.accel_test.param.active(9)
        value=eval(['vinf.accel_test.param.max_speed_bool']);
        str=[str,'''','max_speed_bool',''',',mat2str(value),','];
    end
    if vinf.accel_test.param.active(11)
        value=eval(['vinf.accel_test.param.disable_systems']);
        str=[str,'''','disable_systems',''',',mat2str(value),','];
    end
    if vinf.accel_test.param.active(12)
        value=eval(['vinf.accel_test.param.disable_systems']);
        str=[str,'''','disable_systems',''',',mat2str(value),','];
    end
    if vinf.accel_test.param.active(14)
        value=eval(['vinf.accel_test.param.override_mass']);
        str=[str,'''','override_mass',''',',mat2str(value),','];
    end
    if vinf.accel_test.param.active(15)
        value=eval(['vinf.accel_test.param.add_mass']);
        str=[str,'''','add_mass',''',',mat2str(value),','];
    end
    if ~isempty(str)
        str=str(1:end-1);
        str=['[vinf.accel_test.results]=accel_test_advanced(',str,');'];
    else
        str=['[vinf.accel_test.results]=accel_test_advanced;'];
    end
    eval(str)
end

%if the gradeability is on, but parametric is off, run the gradeability test
if strcmp(vinf.gradeability.run,'on')%&strcmp(vinf.parametric.run,'off') 
    %evalin('base','vinf.max_grade=grade_test(vinf.gradeability.speed);');%sam added (55) on 9/16/98
    %[vinf.gradeability.results.grade,vinf.gradeability.results.gear]=grade_test_advanced('mph',vinf.gradeability.speed);  
    % tm:8/15/00 replaced by statements below
    
    if ~isfield(vinf,'grade_test')
        GradeFigControl
        uiwait(gcf)
    end
    
    str=[];
    
    checkbox_tags={'grade',...
            'speed',...
            'duration',...
            'gear_num',...
            'ess_init_soc',...
            'ess_min_soc',...
            'grade_lb',...
            'grade_ub',...
            'grade_init_step',...
            'speed_tol',...
            'grade_tol',...
            'max_iter',...
            'disp_status'};
    
    for i=1:length(checkbox_tags)
        if vinf.grade_test.param.active(i)
            value=eval(['vinf.grade_test.param.',checkbox_tags{i}]);
            str=[str,'''',checkbox_tags{i},''',',mat2str(value),','];
        end
    end
    if vinf.grade_test.param.active(length(checkbox_tags)+2)|vinf.grade_test.param.active(length(checkbox_tags)+3)
        value=eval(['vinf.grade_test.param.disable_systems']);
        str=[str,'''','disable_systems',''',',mat2str(value),','];
    end
    if vinf.grade_test.param.active(length(checkbox_tags)+5)
        value=eval(['vinf.grade_test.param.override_mass']);
        str=[str,'''','override_mass',''',',mat2str(value),','];
    end
    if vinf.grade_test.param.active(length(checkbox_tags)+6)
        value=eval(['vinf.grade_test.param.add_mass']);
        str=[str,'''','add_mass',''',',mat2str(value),','];
    end
    
    if ~isempty(str)
        str=str(1:end-1);
        str=['[vinf.grade_test.results.grade vinf.grade_test.results.gear]=grade_test_advanced(',str,');'];
    else
        str=['[vinf.grade_test.results.grade vinf.grade_test.results.gear]=grade_test_advanced;'];
    end
    eval(str)
    vinf.gradeability.results.grade=vinf.grade_test.results.grade;
end 

if strcmp(vinf.cycle.soc,'on')%& strcmp(vinf.parametric.run,'off')
    if strcmp(vinf.cycle.socmenu,'linear')	%linear SOC correction
        %run the simulation with the low soc value
        if exist('cs_lo_soc')
            evalin('base','ess_init_soc=cs_lo_soc-.01;');
        end
        gui_run_simulation;
        evalin('base','gui_post_process');
        if evalin('base','exist(''mpg'')')
            mpg(1)=evalin('base','mpg');
            gpm(1)=1/mpg(1);
        else	%for series case with no gas mileage, the gallons per mile is zero
            gpm(1)=0;
        end
        hc(1)=evalin('base','hc_gpm');
        co(1)=evalin('base','co_gpm');
        nox(1)=evalin('base','nox_gpm');
        deltaSOC(1)=evalin('base','ess_soc_hist(end)-ess_soc_hist(1)');
        
        if abs(deltaSOC(1))>deltaSOC_tol %doesn't run another simulation if low init SOC gives zero delta
            %update the waitbar--half way done with simulation
            if ~isfield(vinf,'run_without_gui')
                waitbar(.45);
            end
            %run the simulation with the hi soc value
            evalin('base','ess_init_soc=cs_hi_soc+.01;');
            gui_run_simulation;
            evalin('base','clear mpg hc_gpm co_gpm nox_gpm'); %clear variables left from first run
            evalin('base','gui_post_process');
            if evalin('base','exist(''mpg'')')
                mpg(2)=evalin('base','mpg');
                gpm(2)=1/mpg(2);
            else	%for series case with no gas mileage, the gallons per mile is zero
                gpm(2)=0;
            end
            hc(2)=evalin('base','hc_gpm');
            co(2)=evalin('base','co_gpm');
            nox(2)=evalin('base','nox_gpm');
            deltaSOC(2)=evalin('base','ess_soc_hist(end)-ess_soc_hist(1)');
            if ~isfield(vinf,'run_without_gui')
                waitbar(.9);
            end
            
            %interpolate to find value at zero delta soc
            GPMile=interp1(deltaSOC,gpm,0);
            MilesPG=1/GPMile;
            mpgge=MilesPG*42600/evalin('base','fc_fuel_lhv')*749/evalin('base','fc_fuel_den');%gas equivalent
            hc_emis=interp1(deltaSOC,hc,0);
            co_emis=interp1(deltaSOC,co,0);
            nox_emis=interp1(deltaSOC,nox,0);
            
            %assign the linear corrected results in base
            assignin('base','mpg',MilesPG);
            assignin('base','mpgge',mpgge); %miles per gallon gas equivalent
            assignin('base','hc_gpm',hc_emis);
            assignin('base','co_gpm',co_emis);
            assignin('base','nox_gpm',nox_emis);
            
            %if linear did not work because positive delta SOC was not achieved
            if isnan(mpg)
                evalin('base','mpg=0;mpgge=0;hc_gpm=0;co_gpm=0;nox_gpm=0;');
                evalin('base','warnings{warn_index}=''SOC correct linear did not work.  Fuel Converter too small to charge batteries on this cycle.'';');
                evalin('base','warn_index=warn_index+1;');
            end
        end
        
        if ~exist('no_results_fig') & (~isfield(vinf,'run_without_gui') | (isfield(vinf,'run_without_gui') & vinf.run_without_gui == 0))
            ResultsFig;	%pull up results figure
        end
        
    elseif strcmp(vinf.cycle.socmenu,'zero delta')	%Zero Delta SOC correction
        % Initialize plots
        assignin('base','counter',0)
        
        %Added to work with J1711: zero delta between 'pause' and end
        if evalin('base','~exist(''soc_t'')')
            evalin('base','soc_t=1;'); 
        end
        if exist('cs_lo_soc')
            evalin('base','ess_init_soc=(cs_lo_soc+cs_hi_soc)/2;'); %take the average as the starting point
        end
        clear InitSOC DeltaSOC min_positive_index min_negative_index;
        clear Ess_Delta_Energy_Stored;
        old_pos=0; old_neg=0;
        
        for tmp_i=1:max_zero_delta_iter
            
            gui_run_simulation; %run the simulation
            InitSOC(tmp_i)=evalin('base','ess_init_soc'); %record initial SOC value
            DeltaSOC(tmp_i)=evalin('base','ess_soc_hist(end)-ess_soc_hist(soc_t)'); %record Delta SOC
            
            %added MPG calcs for plotting
            try, %record MPG, NaN if no fuel used
                if max(gal)>0
                    MPG_zerodelta(tmp_i)=trapz(t,mpha)/3600/max(gal);
                else
                    MPG_zerodelta(tmp_i)=NaN;
                end
            catch
                MPG_zerodelta(tmp_i)=NaN;
            end
            
            Ess2Fuel_energy_ratio_percent(tmp_i)=calc_ess2fuel;
            
            % plot progress
            if ~isfield(vinf,'run_without_gui') % tm:7/14/00 added to prevent plots when not using gui
                evalin('base','counter=counter+1;')
                if evalin('base','counter')==1
                    colors={'b*','r*','k*','m*','c*','g*','y*','bs','rs','ks','ms','cs','gs','ys','bx','rx','kx','mx','cx','gx','yx','bo','ro','ko','mo','co','go','yo','b+','r+','k+','m+','c+','g+','y+','b.','r.','k.','m.','c.','g.','y.'};
                    evalin('base','h0=figure;hold on;')
                    set(gcf,'NumberTitle','off','Name','Zero Delta SOC Progress')
                    h1_dsoc=subplot(3,1,1); hold on; %first plot SOC info, [ 0.13 0.581098265895954 0.637428571428571 0.343901734104046 ]
                    plot([deltaSOC_tol deltaSOC_tol+eps],[ 0 1], 'r:')%tolerance lines
                    plot([-deltaSOC_tol -deltaSOC_tol+eps],[ 0 1], 'r:')%tolerance lines
                    legend_str=[];
                    legend_str=strvcat(legend_str, '+ Tol','- Tol');
                    %xlabel('Delta SOC')
                    ylabel('Initial SOC')
                    title(['Note: Tolerance Method is ''' vinf.cycle.soc_tol_method ''''])
                    %position of axis: [ 0.13 0.114285714285714 0.6375 0.342857142857143 ] normalized
                    h2_dsoc=subplot(3,1,2);%second plot MPG info
                    set(h2_dsoc,'Units','normalized','Position',[ 0.13 0.4 0.64 0.22 ]);
                    hold on; 
                    %xlabel('Delta SOC')
                    ylabel('MPG')
                    h3_dsoc=subplot(3,1,3);%second plot MPG info
                    set(h3_dsoc,'Units','normalized','Position',[ 0.13 0.11 0.64 0.22 ]);
                    ylabel('Ess/Fuel Energy ratio (%)')
                    hold on; 
                    plot([-1 1],vinf.cycle.ess2fuel_tol*ones(1,2),'--')
                    xlabel('Delta SOC')
                end 
                plot_index=tmp_i;
                eval(['axes(h1_dsoc); plot(DeltaSOC(plot_index),InitSOC(plot_index),''',colors{plot_index},''')']);
                eval(['axes(h2_dsoc);plot(DeltaSOC(plot_index),MPG_zerodelta(plot_index),''',colors{plot_index},''')']);
                eval(['axes(h3_dsoc);plot(DeltaSOC(plot_index),Ess2Fuel_energy_ratio_percent(plot_index),''',colors{plot_index},''')']);
                legend_str=strvcat(legend_str, num2str(plot_index));
                
                axes(h1_dsoc); %SOC plot
                legend(h1_dsoc,legend_str,-1);
                axlim=max(abs(min(DeltaSOC)),max(DeltaSOC));
                axis([-axlim-0.01 axlim+0.01 0 1]);%make axis symmetric about zero
                axes(h2_dsoc); %MPG plot
                try,axis([-axlim-0.01 axlim+0.01 0.95*min(MPG_zerodelta) 1.05*max(MPG_zerodelta)]);end%make axis symmetric about zero
                axes(h3_dsoc); %ess2fuel ratio plot
                %legend('ESS2Fuel ratio Tol.',-1)
                try,axis([-axlim-0.01 axlim+0.01 0 1.05*max(Ess2Fuel_energy_ratio_percent)]);end%make axis symmetric about zero%legend(legend_str,-1);
                drawnow
            end
            %end plotting
            
            if strcmp(vinf.cycle.soc_tol_method,'soctol')
                
                %this if for the soctol method (delta soc is below a certain percent)
                if abs(DeltaSOC(tmp_i))<deltaSOC_tol	%break the for loop if reach tolerance goal
                    disp(['Delta SOC Tolerance of ',num2str(deltaSOC_tol),' met.']);
                    disp(['Number of runs: ',num2str(tmp_i),', ESS/Fuel Energy ratio: ',num2str(Ess2Fuel_energy_ratio_percent(tmp_i)),' %, DeltaSOC: ',num2str(DeltaSOC(tmp_i)),', Initial_SOC: ',num2str(InitSOC(tmp_i))]);
                    break;
                end %if <tolerance
                
            elseif strcmp(vinf.cycle.soc_tol_method,'ess2fuel')
                
                %this if for the ess2fuel method (ratio of net ess stored energy to fuel energy used is below a certain percent)
                if Ess2Fuel_energy_ratio_percent(tmp_i)<vinf.cycle.ess2fuel_tol	%break the for loop if reach tolerance goal
                    disp(['ESS stored/Fuel Energy Tolerance of ',num2str(vinf.cycle.ess2fuel_tol),'% met.']);
                    disp(['Number of runs: ',num2str(tmp_i),', ESS/Fuel Energy ratio: ',num2str(Ess2Fuel_energy_ratio_percent(tmp_i)),' %, DeltaSOC: ',num2str(DeltaSOC(tmp_i)),', Initial_SOC: ',num2str(InitSOC(tmp_i))]);
                    break;
                end %if <tolerance
                
            end
            
            %reset the initial SOC
            if tmp_i>1
                min_index=max(find(DeltaSOC==min(DeltaSOC))); %find minimum deltaSOC index
                if DeltaSOC(min_index)<0
                    negative_DeltaSOC=abs(DeltaSOC(DeltaSOC<0));
                    min_negative_index=find(DeltaSOC==-1*min(negative_DeltaSOC));
                    positive_DeltaSOC=DeltaSOC(DeltaSOC>0); %new vector with only positive delta SOC's
                    if ~ isempty(positive_DeltaSOC)
                        min_positive_index=find(DeltaSOC==min(positive_DeltaSOC));
                    end %if ~ isempty
                end %if DeltaSOC<0
            end %if tmp_i>1
            if exist('min_positive_index') & exist('min_negative_index')
                if min_positive_index~=old_pos | min_negative_index~=old_neg
                    DSOC(1)=DeltaSOC(min_negative_index);
                    SOC_init(1)=InitSOC(min_negative_index);
                    DSOC(2)=DeltaSOC(min_positive_index);
                    SOC_init(2)=InitSOC(min_positive_index);
                    SOC=interp1(DSOC,SOC_init,0,'linear'); %interpolate to find next starting SOC
                    old_pos=min_positive_index;
                    old_neg=min_negative_index;
                else %case where points closest to zero are not changing
                    min_delta_index=max(find(abs(DeltaSOC)==min(abs(DeltaSOC)))); %find index for minimum Delta SOC
                    if tmp_i~=min_delta_index & sign(DeltaSOC(tmp_i))==sign(DeltaSOC(min_delta_index)) & abs((DeltaSOC(tmp_i)-DeltaSOC(min_delta_index)))<0.01
                        factor=.5/(tmp_i-max(min_negative_index,min_positive_index));
                    else
                        factor=.5/(tmp_i-max(min_negative_index,min_positive_index));
                    end % if tmp_i~=min_delta...
                    SOC=InitSOC(min_positive_index)+factor*(InitSOC(min_negative_index)-InitSOC(min_positive_index));
                end %if min_pos_index..
                
            else %case where only one sign of deltaSOC
                min_delta_index=max(find(abs(DeltaSOC)==min(abs(DeltaSOC)))); %find index for minimum Delta SOC
                factor=1*(tmp_i-min_delta_index+1);
                if tmp_i>3 & factor==1 %case where dSOC is dropping (min delta is tmp_i), but slowly
                    factor=5*(tmp_i-min_delta_index+1);
                end
                SOC=InitSOC(min_delta_index)+factor*DeltaSOC(min_delta_index);
            end %if exist(min_pos..)
            
            if SOC>1, SOC=1; elseif SOC<0 SOC=0; end	%added to limit initial values of SOC between 0 and 1
            assignin('base','ess_init_soc',SOC); 
            disp(['Run number: ',num2str(tmp_i),', ESS/Fuel Energy ratio: ',num2str(Ess2Fuel_energy_ratio_percent(tmp_i)),' %, DeltaSOC: ',num2str(DeltaSOC(tmp_i)),', Initial_SOC: ',num2str(InitSOC(tmp_i))]);
            
        end %for loop tmp_i=1:max_zero_delta_iter
        
        %pick best run of all runs to display
        min_delta_index=max(find(abs(DeltaSOC)==min(abs(DeltaSOC)))); %find index for minimum Delta SOC
        if min_delta_index~=tmp_i %if it wasn't the last run
            assignin('base','ess_init_soc',InitSOC(min_delta_index));
            gui_run_simulation;
        end
        if tmp_i==max_zero_delta_iter
            disp(['Maximum number of runs (',num2str(max_zero_delta_iter),') reached.']);
            if abs(DeltaSOC(min_delta_index))<=deltaSOC_tol
                disp(['Tolerance of ',num2str(deltaSOC_tol),' met.  Minimum DeltaSOC: ',num2str(DeltaSOC(min_delta_index))]);
            else
                disp(['Tolerance of ',num2str(deltaSOC_tol),' not met.  Minimum DeltaSOC: ',num2str(DeltaSOC(min_delta_index))]);
            end
        end
        
        if ~isfield(vinf,'run_without_gui')
            waitbar(.95);
        end
        evalin('base','gui_post_process');
        if ~exist('no_results_fig')&~isfield(vinf,'run_without_gui')
            ResultsFig;	%pull up results figure
        end
        if exist('tmp_i')
            clear tmp_i;
        end
        if exist('i')
            clear i;
        end
    end %SOC correct scenarios (linear or zero delta) 
    
elseif strcmp(vinf.cycle.soc,'off')%& strcmp(vinf.parametric.run,'off')
    
    if strcmp(vinf.cycle.run,'on')&strcmp(vinf.cycle.name,'CYC_ACCEL');%sam added vinf.cycle.run,'on'
        vinf.acceleration=accel_test_advanced; %for acceleration cycle, run the acceleration test to pick results from it
    else
        gui_run_simulation;	%run the basic cycle
    end
    if ~isfield(vinf,'run_without_gui')
        waitbar(.95);
    end
    evalin('base','gui_post_process');	%runs the post processing
    if ~exist('no_results_fig')&~isfield(vinf,'run_without_gui')
        ResultsFig;			%calls up the results figure
    end
    
    %run the parametric function, includes calls for grade and acceleration if checked
% elseif strcmp(vinf.parametric.run,'on')
%     parametric_execute;	
end

if strcmp(vinf.parametric.run,'off')& ~isfield(vinf,'run_without_gui')
    waitbar(1);
    close(findobj('tag','TMWWaitbar')); 	%close the waitbar   
end

%Revision history
% 8/5/98-valerie new file
% 8/6/98-sam changed vinf.acceleration to vinf.acceleration.run
% 8/9/98-valerie,sam add SOC correction
% 8/10/98-valerie, changed SOC correction algorithm
% 8/12/98-vj, added mpgge mpgde
% 8/13/98-valerie, clear mpg, emiss. for linear SOC correct before running 2nd time
% 8/19/98-vj, changed SOC algorithm
% 8/19/98-vj, run accel cycle at .1 time step
% 9/9/98-vj, added warning if linear SOC correction didn't work
% 9/14/98-vj, SOC linear now has top point at hi limit +.01
%9/16/98-ss, added (55) to grade test because grade_test.m changed
%12/10/98-vj added if statements to see if user was running advisor using gui or
%			not to decide whether or not to display the waitbar.
% 4/12/99: vhj: added soc_t for zero-delta iterations (SOC at soc_t to compare final SOC to)
% 5/25/99: vhj: added |strcmp(vinf.test.run,'off') for defining soc_t for no test
% 9/22/99: vhj changed soc_t definition--set to one if it does not exist
% 9/22/99: vhj SOC tolerance and # iterations set by user
% 9/23/99: vhj display message if max # iterations reached
%11/30/99: vhj added case for zero delta SOC correct (if i>3 & factor==1 %case where dSOC is dropping (min delta is i), but slowly)
%02/16/00: vhj initial values of SOC limited to lie between 0 and 1
% 3/21/00: ss updated calls to results figure ResultsFigControl was gui_results.
%05/10/00: vhj added plotting for zero delta soc
%05/18/00: vhj changed zero delta SOC algorithm to take max of possible min_delta_index's (3+1 places)
% tm:7/14/00 added conditional to plot routine to prevent plots when not using gui
% tm 7/18/00 updated calls to grade_test_advanced and accel_test_advanced lines 27 and ~32, and 224
% 08/07/00: vhj updated plotting to plot mpg during zero delta
% 8/14/00:tm updated function calls to accel and grade tests to use user inputs as defaults if they exist
%8/16/00:tm moved statements that check for accel_test field inside of conditional to prevent error
% 1/29/01:tm revised function calls to accel and grade tests due to changes in grade and accel setup figures and options
% 7/26/01: mpo fixed a bug that was occuring due to duplicate 'i' veriables in Delta_SOC_Correct for loop (i --> tmp_i)
% 2/15/02: ss replaced ResultsFigControl with ResultsFig