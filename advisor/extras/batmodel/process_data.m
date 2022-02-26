function process_data(type,results)
global binf

%binf structure:
%			 data_files: {'test.dat'}
%               path: 'D:\Val\battery_testing\process\'
%       header_names: {1x11 cell}
%    no_header_lines: 1
%            batname: 'Hawker Genesis 12AH spiral wound lead acid'
%             batnum: 'number'
%           testdate: 'Date'
%    testdescription: 'description'
%         testscript: 'Test Script'
%               vars: {'Time (s)';'Current (A)';'Voltage (V)';'Capacity (Ah)';'Temperature (C)'};
%         var_column: [1 6 5 2 7]
%         equations: {5x1 cell}

%%%%%%%%%%%%%%%%%
%Process the data
%%%%%%%%%%%%%%%%%
if nargin==0
    if strcmp(binf.test_type,'RC')   %RC processing

        %get thermal parameters from user here, then this will call processing files
        RC_therm_params;
        
    elseif strcmp(binf.test_type,'peukert')
        h=waitbar(.001);
        try, waitbar(0.05);end
        process_data('peukert',0);	%read in data, convert with eqns, found in binf.peukert.data
        waitbar(.25);
        
        %get A and Ah (neg current=discharge)
        time=binf.peukert.data(:,1);
        current=binf.peukert.data(:,2);
        voltage=binf.peukert.data(:,3);
        amphours=binf.peukert.data(:,4);
        %Indices for start/end of discharge currents-no residual and residual
        thresh=0.11;	%bitrode oscillates between 0 and 0.05 A when at rest, ignore these jumps
        Ahthresh=binf.peukert.ratedAh/10;	%threshold for Ah (sometimes it's non-zero)
        cindbeginNR=[];	%nr for no residual
        cindbeginR=[];
        cindendNR=[];
        cindendR=[];
        cind0soc=[];
        for i=2:length(current)-1
            if abs(current(i-1))<thresh & current(i)<-thresh %find where discharge current begins,
                if current(i+1)<-thresh %next current isn't zero(eliminates points that limit out in one time step)
                    if abs(amphours(i))<Ahthresh
                        %amphours<thresh so that start at 100%soc point (this doesn't capture the residual drops)
                        cindbeginNR=[cindbeginNR; i];
                    else
                        cindbeginR=[cindbeginR; i];
                    end
                end
            elseif (current(i)>-40 & abs(current(i+1))<thresh & current(i)<-thresh) | (current(i)<=-40 & abs(current(i+1))<abs(0.03*current(i)))  %find where discharge current ends
                if isempty(cindbeginR)
                    %amphours>-thresh so that start at 100%soc point(this doesn't capture the residual drops)
                    cindendNR=[cindendNR; i];
                elseif cindbeginNR(end)>cindbeginR(end)
                    %amphours>-thresh so that start at 100%soc point(this doesn't capture the residual drops)
                    cindendNR=[cindendNR; i];
                else
                    cindendR=[cindendR; i];
                end
            elseif abs(current(i-1))<thresh & current(i)>thresh & amphours(i+1)<thresh & ~isempty(cindbeginNR) %charging initiation from 0%SOC has started
                cind0soc=[cind0soc; i];
            end
        end
        %Find A-hrs vs. A
        for i=1:length(cindbeginNR)
            tempAhr=(time(cindendNR(i))-time(cindbeginNR(i)))*abs(current(cindendNR(i)))/3600;
            IC(i,:)=[-current(cindendNR(i)) tempAhr];	%neg sign on current here to flip polarity
        end
        %disp(['Current-Ahrs from test: ']);
        %IC
        binf.peukert.IC=IC;
        
        if 1 %debug
            binf.peukert.indices.cindbeginR=cindbeginR;
            binf.peukert.indices.cindendR=cindendR;
            binf.peukert.indices.cindbeginNR=cindbeginNR;
            binf.peukert.indices.cindendNR=cindendNR;
            binf.peukert.indices.cind0soc=cind0soc;
        end
        
        %Find A-hrs from residual capacity testing
        if ~isempty(cindbeginR)	%if residual cap tests found
            ICresid=IC;
            %find to which test the residual is to be added
            for j=1:length(cindbeginR)
                addind=max(find(cindbeginR(j)>cindbeginNR));	%index to add A-hrs to
                addlAhr=(time(cindendR(j))-time(cindbeginR(j)))*abs(current(cindendR(j)))/3600;	%additional A-hrs
                ICresid(addind,2)=ICresid(addind,2)+addlAhr;	%sum A-hrs
            end
            savej=[];
            for j=1:length(ICresid(:,1))
                if IC(j,2)~=ICresid(j,2)
                    savej=[savej; j];
                end
            end
            ICresid=ICresid(savej,:);
            %disp(['Current-Ahrs from test with residual A-hrs: ']);
            %ICresid
        end
        
        waitbar(.5);
        
        %end up with vector IC=[current(disch is positive) capacity(Ahrs)];
        %find peukert coeffs
        curr=IC(:,1);
        Ah=IC(:,2);
        [C_exp]=find_peuk(curr,Ah);
        coeff=C_exp(1);
        exp=C_exp(2);
        waitbar(.75);
        
        % Want IC=[Amps	data(Ah)		model(Ah)	error		%error]
        IC=[IC coeff.*IC(:,1).^exp]; 	%generate 3rd column (model)
        IC=[IC IC(:,3)-IC(:,2)];		%generate 4th column (error)
        IC=[IC IC(:,4)./IC(:,2)*100];	%generate 5th column (%error)
        
        %average error calculations
        pavgE=mean(abs(IC(:,5)));
        A=.9*min(curr):1:1.4*max(curr);
        Temperature=mean(binf.peukert.data(:,5));	%mean temperature
        
        %Record OCV results at 0 and 100% SOC for use in OCV determination
        OCV0=voltage(cind0soc);
        OCV100=voltage(cindbeginNR-1);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Find coulombic efficiency
        
        
        %end coulombic efficiency section
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %Save data to binf variable
        %IC already written above
        if ~isempty(cindbeginR)
            binf.peukert.ICresid=ICresid;
        end
        binf.peukert.coefficient=coeff;
        binf.peukert.exponent=exp;
        binf.peukert.A=A;
        binf.peukert.percentage_error=pavgE;
        binf.peukert.OCV0=OCV0;
        binf.peukert.OCV100=OCV100;
        binf.peukert.temperature=Temperature;
        binf.peukert.indices.cindbeginR=cindbeginR;
        binf.peukert.indices.cindendR=cindendR;
        binf.peukert.indices.cindbeginNR=cindbeginNR;
        binf.peukert.indices.cindendNR=cindendNR;
        binf.peukert.indices.cind0soc=cind0soc;
        
        
        process_data('',1);
        waitbar(1);
        close(h)	%close the waitbar
        
    elseif strcmp(binf.test_type,'VOC')
        h=waitbar(.001);
        try, waitbar(0.05);end
        process_data('VOC',0);	%read in data, convert with eqns, found in binf.VOC.data
        waitbar(.25);
        
        %get A and V (neg current=discharge)
        time=binf.VOC.data(:,1);
        current=binf.VOC.data(:,2);
        voltage=binf.VOC.data(:,3);
        amphours=binf.VOC.data(:,4);
        Temperature=mean(binf.VOC.data(:,5));	%mean temperature
        
        %Indices for start/end of discharge currents-
        %thresh=0.08;	%bitrode oscillates between 0 and 0.05 A when at rest, ignore these jumps
        thresh=0.2;	% for sam abc prius data bitrode oscillates between 0 and 0.05 A when at rest, ignore these jumps
        ind=[];
        %      t_begin=[];
        
        %Find indices for OCV points
        for i=1:length(current)-1
            if abs(current(i))<thresh & current(i+1)<-thresh %find where discharge current begins
                ind=[ind; i];
                %            if amphours(i)<0.01
                %               t_begin=[t_begin; time(i)];
                %            end
            elseif abs(current(i))<thresh & current(i+1)>thresh & amphours(i)<-thresh  %capture charging point
                ind=[ind; i];
            end
        end
        
        waitbar(.5);
        
        %Find SOC and OCV at indices
        OCV=voltage(ind);
        j=1;
        Ahused=abs(amphours(ind));
        maxAh=max(Ahused);
        SOC=round((maxAh-Ahused)/maxAh*100);
        
        %Add peukert-OCV data if available
        try, eval('binf.peukert.OCV100;')
            OCV=[OCV; binf.peukert.OCV100];
            SOC=[SOC; (100+0*(1:length(binf.peukert.OCV100))')];
        end
        
        %Find Model parameters
        tmpvec=[SOC OCV];
        tmpvec=sort(tmpvec,1);
        evalpts=1; evalind=[1];
        for i=1:length(tmpvec)-1 %look to see how many model evaluation points to make (e.g. 11 for every 10%, 6 if every 20% SOC)
            if find(tmpvec(i,1)~=tmpvec(i+1,1))
                evalpts=evalpts+1;
                evalind=[evalind;i+1]; %used to pick actual SOC value
            end
        end
        evalind=[evalind;length(tmpvec)];
        disp(evalpts)
        for i=2:evalpts+1
            modelOCV(i-1)=mean(tmpvec(evalind(i-1):evalind(i)-1,2));
            modelSOC(i-1)=tmpvec(evalind(i-1),1);
        end
        ess_soc=[0:10:100];
        [modelSOC' modelOCV'];
        ess_voc=interp1(modelSOC,modelOCV,ess_soc);
        [ess_soc' ess_voc'];
        
        %Calculate error
        for i=1:length(OCV)
            error(i)=abs(interp1(ess_soc,ess_voc,SOC(i))-OCV(i))/OCV(i);
        end
        pavgE=mean(error)*100;
        
        waitbar(.75);
        
        %Save data to binf variable
        binf.VOC.SOC_OCV_data=[SOC OCV];
        binf.VOC.ess_voc=ess_voc;
        binf.VOC.ess_soc=ess_soc;
        binf.VOC.percentage_error=pavgE;
        binf.VOC.temperature=Temperature;
        binf.VOC.ind=ind;
        
        process_data('',1);
        
        waitbar(1);
        close(h)	%close the waitbar
        
    elseif strcmp(binf.test_type,'Rint')
        h=waitbar(.001);
        try, waitbar(0.05);end
        process_data('Rint',0);	%read in data, convert with eqns, found in binf.Rint.data
        waitbar(.3);
        
        %get A and V (neg current=discharge)
        time=binf.Rint.data(:,1);
        current=binf.Rint.data(:,2);
        voltage=binf.Rint.data(:,3);
        amphours=binf.Rint.data(:,4);
        Temperature=mean(binf.Rint.data(:,5));	%mean temperature
        
        
        %Find start/stop points
        indb=[];
        inde=[];
        avgt=2; %seconds to average over
        beginind=min(find(time>avgt));
        endind=max(find(time<=(time(end)-avgt)));
        dV_dt_thresh=0.008; %change in voltage over time theshhold
        not_chg_dis_last=1;
        last_sign=0; begining=0;endpt=0;dV_dt_save=[];%ending=0;
        for i=beginind:length(voltage)%1:endind
            if ~mod(i,1000)
                disp(['Status: ',num2str(i),' of ',num2str(length(voltage))]);
            end
            %To be used in logic below to determine beginning and end points
            %Use only voltage (averaged over time) to determine start/stop points
            %Assume start in a non-chg/discharge state
            prev_t_index=max(find(time<=time(i)-avgt));
            dV_dt=(voltage(i)-voltage(prev_t_index))/avgt; %average dV/dt
            
            startpt=(not_chg_dis_last&(abs(dV_dt)>dV_dt_thresh));
            if last_sign~=0 %last_sign=0 if not charging or discharging
                endpt=(sign(dV_dt)==-last_sign)&abs(dV_dt)>dV_dt_thresh;	%switching signs, and large change in voltage
            end
            
            %try, if abs(current(i))>2
            %      disp(['min=',num2str(time(i)/60),' dV/dt=',num2str(dV_dt),' not_chg_dis_last=',num2str(not_chg_dis_last),' startpt=',num2str(startpt)])
            %      disp(['last_sign=',num2str(last_sign),' sign(dV_dt)=',num2str(sign(dV_dt))])
            %   end,         end
            
            not_chg_dis_last=(abs(dV_dt)<=dV_dt_thresh)*(abs(last_sign)-1); 	%not charging or discharging now
            % abs(last_sign)-1 disables the 'not chg/dis' boolean if haven't ended a chg/dis
            dV_dt_save(i)=dV_dt;
            
            %beginning point
            if startpt
                last_sign=sign(dV_dt);
                %if adding a beginning, make sure an end has been reached, otherwise write over previous beginning
                if ~isempty(indb) & ~isempty(inde)
                    if inde(end)<indb(end)
                        indb=[indb(1:end-1); i-3]; %find where discharge/charge current begins, overwriting last
                    else
                        indb=[indb; i-3]; %find where discharge/charge current begins
                    end
                else
                    indb=[indb; i-3]; %find where discharge/charge current begins
                end
            elseif endpt
                last_sign=0;
                %ending point   
                if ~isempty(indb)	%begin point must exist (if try to end the charging before first begin point, don't use)
                    if ~isempty(inde) & inde(end)>indb(end) %if two ends found before a beginning is found,
                        inde=[inde(1:end-1); i-3]; 				 %overwrite last (multiple ends)
                    else  
                        inde=[inde; i-3]; %find where discharge/charge current ends
                    end
                end
                endpt=0;
            end
        end
        
        %Cleanup of begin/end points
        if indb(end)>inde(end)	%if 'begin' a charge but don't end it at the end, elim this begin point
            indb=indb(1:end-1);
        end
        if length(indb)==length(inde)
            indb=[indb; length(voltage)];
        end
        assignin('base','indb',indb);   assignin('base','inde',inde);
        
        %Assign pulse time=first pulse time
        tpulse=time(inde(1))-time(indb(1))	%time of first pulse (used to elminate shorter & longer pulses)
        %Additional pulse lengths
        extra_tpulses=[30 5 21 25 10 15];
        all_tpulses=[tpulse extra_tpulses];
        pulseind=[];
        binf.Rint.badpulses=['Rint pulse lengths desired (+-10%): ', num2str(round(all_tpulses*100)/100),];
        binf.Rint.badpulses=strvcat(binf.Rint.badpulses,'The following points are thrown out:');
        
        %Find 3 indices for Rint points
        for i=1:length(indb)-1	%note-indb should be one larger than inde
            %this eliminates the pulses which drop the SOC and are not intended as Rint tests
            %disp([num2str(i) ' ' num2str(time(indb(i))/60) ' ' num2str(current(inde(i))) ' ' num2str((time(inde(i))-time(indb(i))))]);
            tpactual=time(inde(i))-time(indb(i)); %actual pulse length
            %condition for a good pulse length
            tpulsegood=0;
            for j=1:length(all_tpulses)
                if tpactual<=1.10*all_tpulses(j) & tpactual>=0.9*all_tpulses(j)
                    tpulsegood=1;
                end
            end
            if tpulsegood
                pulseind=[pulseind; indb(i) inde(i) indb(i+1)];
            else
                %Document why the point was rejected (outside of pulselength)
                %Mark pulse at time of begin index, thrown out because out of +-5% of pulsewidth
                binf.Rint.badpulses=strvcat(binf.Rint.badpulses,['t begin: ',num2str(round(time(indb(i))/60*100)/100),...
                        ' tpulse actual: ',num2str(round(100*(time(inde(i))-time(indb(i))))/100)]);
            end
        end
        
        assignin('base','pulseind',pulseind);
        
        %temperary plots
        figure;hold on; zoom on;
        plot(binf.Rint.data(:,1)/60,binf.Rint.data(:,2),'b');						%current
        plot(binf.Rint.data(:,1)/60,binf.Rint.data(:,4),'k');						%Ahrs
        plot(binf.Rint.data(:,1)/60,binf.Rint.data(:,3),'g');						%voltage
        plot(binf.Rint.data(indb,1)/60,binf.Rint.data(indb,3),'ro'); %indb
        plot(binf.Rint.data(inde,1)/60,binf.Rint.data(inde,3),'ko'); %inde
        
        plot(binf.Rint.data(pulseind(:,1),1)/60,binf.Rint.data(pulseind(:,1),3),'rx'); %indb
        plot(binf.Rint.data(pulseind(:,2),1)/60,binf.Rint.data(pulseind(:,2),3),'kx'); %inde
        plot(binf.Rint.data(pulseind(:,3),1)/60,binf.Rint.data(pulseind(:,3),3),'bx'); %inde
        plot(time/60,dV_dt_save*100,'m');	%dV/dt
        xlabel('Time (min)');
        ylabel('Data');
        title('Points chosen for evaluation: Rint')
        legend('Current','Ah','Voltage','begin','end','V1','V2','V3','dV/dt*100',-1)
        
        waitbar(.5);
        
        %Process points to find internal resistance
        %Get OCV-SOC correlation
        try, binf.VOC.ess_voc;
            ess_soc=binf.VOC.ess_soc;
            ess_voc=binf.VOC.ess_voc;
        catch
            ess_soc=0:20:100;
            %ess_voc=%userinput;!!!!!!!!!!!
        end
        v1=voltage(pulseind(:,1));				
        v2=voltage(pulseind(:,2));
        v3=voltage(pulseind(:,3));
        assignin('base','pulseind',pulseind);
        for i=1:size(pulseind,1)
            %check on current pulse--see if mean current didn't decrease to less than itol+current at beginning
            jump_pt=0; %look ahead this # of indices (gets rid of initial startup spikes/lows)
            t_range=time(pulseind(i,1)+jump_pt:pulseind(i,2));
            c_range=current(pulseind(i,1)+jump_pt:pulseind(i,2));
            deltat=time(pulseind(i,2))-time(pulseind(i,1)+jump_pt);
            imean(i)=trapz(t_range,c_range)/deltat;
        end
        imean=round(imean'); %if running small currents, need more precision here
        %Calculate values
        Voc=mean([v1 v3],2);		% effective voc during pulse
        Rint=(v2-v3)./imean;		% effective resistance
        %Rint=(v2-v1)./imean;		% effective resistance, try this if 'rest' voc is dropping a lot
        %Separate values into charge/discharge values
        VocD=[];Rdis=[];Idis=[];VocC=[];Rchg=[];Ichg=[];
        for i=1:length(Rint)
            if sign(imean(i))<0	%discharge
                VocD=[VocD; Voc(i)];
                Rdis=[Rdis; Rint(i)];
                Idis=[Idis; imean(i)];
            elseif sign(imean(i))>0	%charge
                VocC=[VocC; Voc(i)];
                Ichg=[Ichg; imean(i)];
                if Rint(i)<0 %begin/end indices miss an end of test case
                    Rchg=[Rchg; 5.8E-3];	%this value is for the single 1.2 A case for Saft
                else
                    Rchg=[Rchg; Rint(i)];
                end
            end
        end
        %Sort the data, increasing OCV
        try,tmp=sortrows([VocD Rdis Idis]); VocD=tmp(:,1);Rdis=tmp(:,2);Idis=tmp(:,3);end
        try,tmp=sortrows([VocC Rchg Ichg]); VocC=tmp(:,1);Rchg=tmp(:,2);Ichg=tmp(:,3);end
        
        %%%%%%%%%%%%%%%%%%
        %Discharge
        %Polyfit the data
        [pd,sd]=polyfit(VocD,Rdis,3);
        [Rd,deltaD] = polyval(pd,VocD,sd);
        %perrorD=deltaD./Rd*100;
        %pavgED=mean(perrorD);
        ess_r_dis=polyval(pd,ess_voc);
        modelD=interp1(ess_voc,ess_r_dis,VocD);
        modelD(end)=modelD(end-1);
        errorD=abs(modelD-Rdis)./Rdis*100;
        pavgerrorD=mean(errorD);
        %display results to screen
        for i=1:length(ess_soc)
            disp(['At ',num2str(ess_soc(i)),' SOC, Rdis = ',num2str(round(polyval(pd,ess_voc(i))*1000*10)/10),' mohms']);
        end
        disp(['Max: ',num2str(max(Rdis)*1000),' Min: ',num2str(min(Rdis)*1000)]);
        %disp(['Avg tolerance: ',num2str(round(pavgED*10)/10),'%'])
        %%%%%%%%%%%%
        %Charge
        %Polyfit the data
        [pc,sc]=polyfit(VocC,Rchg,3);
        [Rc,deltaC] = polyval(pc,VocC,sc);
        %perrorC=deltaC./Rc*100;
        %pavgEC=mean(perrorC);
        ess_r_chg=polyval(pc,ess_voc);
        modelC=interp1(ess_voc,ess_r_chg,VocC);
        modelC(end)=modelC(end-1);
        errorC=abs(modelC-Rchg)./Rchg*100;
        pavgerrorC=mean(errorC);
        %display results to screen
        for i=1:length(ess_soc)
            disp(['At ',num2str(ess_soc(i)),' SOC, Rchg = ',num2str(round(polyval(pc,ess_voc(i))*1000*10)/10),' mohms']);
        end
        disp(['Max: ',num2str(max(Rchg)*1000),' Min: ',num2str(min(Rchg)*1000)]);
        disp(binf.Rint.badpulses)
        %disp(['Avg tolerance: ',num2str(round(pavgEC*10)/10),'%'])
        
        
        waitbar(.75);
        
        %Save data to binf variable
        binf.Rint.Rcharge_data=Rchg;
        binf.Rint.Rcharge_VOC=VocC;
        binf.Rint.Ichg=Ichg;
        binf.Rint.chg_fit=Rc;
        binf.Rint.Rdischarge_data=Rdis;
        binf.Rint.Rdischarge_VOC=VocD;
        binf.Rint.Idis=Idis;
        binf.Rint.dis_fit=Rd;
        binf.Rint.ess_r_dis=ess_r_dis;
        binf.Rint.ess_r_chg=ess_r_chg;
        binf.Rint.pulseind=pulseind;
        binf.Rint.temperature=Temperature;
        
        process_data('',1);
        
        waitbar(1);
        close(h)	%close the waitbar
        
    end   
end

if nargin>0
    if results
        disp('Plotting Results')
        if strcmp(binf.test_type,'peukert')
            plot_peuk_mod=1; %plot the peukert model?
            %additional data sent from pre processing
            pavgE=binf.peukert.percentage_error;
            coeff=binf.peukert.coefficient;
            exp=binf.peukert.exponent;
            Temperature=binf.peukert.temperature;
            IC=binf.peukert.IC;
            ICresid=binf.peukert.ICresid;
            A=binf.peukert.A;
            cindbeginR=binf.peukert.indices.cindbeginR;
            cindendR=binf.peukert.indices.cindendR;
            cindbeginNR=binf.peukert.indices.cindbeginNR;
            cindendNR=binf.peukert.indices.cindendNR;
            cind0soc=binf.peukert.indices.cind0soc;
            
            %plot results
            figure;hold on;zoom on;
            title(['Peukert Curve. Avg error: ',num2str(round(pavgE*10)/10),'%',' Coeff: ',num2str(round(coeff*1000)/1000),' Exp: ',num2str(round(exp*10000)/10000),'at T=',num2str(round(Temperature*10)/10),'C']);
            xlabel('Discharge Current (A)');
            ylabel('Capacity (Ah)');
            plot(IC(:,1),IC(:,2),'k*');
            if plot_peuk_mod, plot(A,coeff*A.^exp,'b'); end
            if ~isempty(cindbeginR)
                plot(ICresid(:,1),ICresid(:,2),'rd');
                if plot_peuk_mod, 
                    if plot_peuk_mod, legend('data','Peukert model','residual data',0);
                    else
                        legend('data','residual data',0);
                    end
                else
                    legend('data','residual data',0);
                end
            else
                legend('data','Peukert model',0);
            end
            
            %plot data
            figure; hold on;
            plot(binf.peukert.data(:,1)/60,binf.peukert.data(:,2),'b');						%current
            plot(binf.peukert.data(:,1)/60,binf.peukert.data(:,3),'r');						%voltage
            plot(binf.peukert.data(:,1)/60,binf.peukert.data(:,4),'k');						%Ah
            plot(binf.peukert.data(cindbeginNR,1)/60,binf.peukert.data(cindbeginNR,2),'b*');	%begin No Residual
            plot(binf.peukert.data(cindendNR,1)/60,binf.peukert.data(cindendNR,2),'r*');		%end NR
            if ~isempty(cindbeginR)
                plot(binf.peukert.data(cindbeginR,1)/60,binf.peukert.data(cindbeginR,2),'k*');	%begin Residual
                plot(binf.peukert.data(cindendR,1)/60,binf.peukert.data(cindendR,2),'g*');			%end Resid
            end
            plot(binf.peukert.data(cindbeginNR-1,1)/60,binf.peukert.data(cindbeginNR-1,2),'m*');	%100% SOC for OCV
            plot(binf.peukert.data(cind0soc,1)/60,binf.peukert.data(cind0soc,2),'c*');				%0% SOC for OCV
            xlabel('Time (min)');
            ylabel('Data');
            title('Points chosen for evaluation: Peukert')
            if ~isempty(cindbeginR)
                legend('Current','Voltage','Ah','beginNoResidual','endNR','beginResidual','endR','100%SOC-VOC','O%SOC-VOC',-1) 
            else
                legend('Current','Voltage','Ah','begin','end','100%SOC-VOC','O%SOC-VOC',-1) 
            end
            
        elseif strcmp(binf.test_type,'VOC')
            ess_soc=binf.VOC.ess_soc;
            ess_voc=binf.VOC.ess_voc;
            SOC=binf.VOC.SOC_OCV_data(:,1);
            OCV=binf.VOC.SOC_OCV_data(:,2);
            pavgE=binf.VOC.percentage_error;
            Temperature=binf.VOC.temperature;
            ind=binf.VOC.ind;
            
            %Plots
            figure; hold on;
            plot(ess_soc,ess_voc,'b');	%model
            plot(SOC,OCV,'k*');	%OCV data
            xlabel('SOC');
            ylabel('OCV');
            title(['Open Circuit Voltage vs. SOC. Avg Error: ',num2str(round(pavgE*10)/10),'% at T=',num2str(round(Temperature*10)/10),'C']);
            legend('Model','Data',0)
            
            figure; hold on;
            plot(binf.VOC.data(:,1)/60,binf.VOC.data(:,2),'b');						%current
            plot(binf.VOC.data(:,1)/60,binf.VOC.data(:,4),'k');						%Ahrs
            plot(binf.VOC.data(:,1)/60,binf.VOC.data(:,3),'r');						%voltage
            plot(binf.VOC.data(ind,1)/60,binf.VOC.data(ind,2),'r*');
            plot(binf.VOC.data(ind,1)/60,binf.VOC.data(ind,3),'r*');
            xlabel('Time (min)');
            ylabel('Data');
            title('Points chosen for evaluation: VOC')
            legend('Current','Ah','Voltage','eval pts',0)
            
        elseif strcmp(binf.test_type,'Rint')
            %pull up results figure
            bat_results;
        elseif strcmp(binf.test_type,'RC')
            %pull up results figure
            rc_results;
        end
        
    else	%read data, convert with eqns
        disp('Reading in data')
        %import data, strip headers
        batdata=[];
        batdatainit=[];
        var_column=eval(['binf.',type,'.var_column']);
        for i=1:length(eval(['binf.',type,'.data_files']))
            name=eval(['binf.',type,'.data_files{1}']);
            pathname=eval(['binf.',type,'.path']);
            fid=fopen([pathname eval(['binf.',type,'.data_files{',num2str(i),'}'])],'rt');	%open file
            for j=1:eval(['binf.',type,'.no_header_lines'])
                hdrs=fgetl(fid);											%strip headers off files
            end
            if strcmp(name(end-2:end),'dat')
                m=length(eval(['binf.',type,'.header_names']));
                batdatainit=[batdatainit; fscanf(fid,'%f',[m,inf])];	%scan variables to workspace
            end
            fclose(fid);
            batdatainit=batdatainit'; %need to transpose to get #columns x # datapts
            if i>1 & ~binf.bitrode
                disp(['Processing data file #',num2str(i)]);
                %disp(['Time value to add to next file''s time vectors: ',num2str(batdata(end,var_column(1)))]);
                batdatainit(:,var_column(1))=batdatainit(:,var_column(1))+batdata(end,var_column(1)); %need to adjust time vector of 2nd+ files to be sequential
            end
            batdata=[batdata; batdatainit];	
            
            batdatainit=[];
        end
        if binf.bitrode & strcmp(hdrs(1:13),'"Test Unique"')
            if batdata(1,1)~=batdata(end,1)	%case where multiple tests in same dat files ('test unique' identifier)
                ind=[];
                for i=2:length(batdata)
                    if batdata(i-1,1)~=batdata(i,1)
                        ind=[ind; i];	%indices where the test changes
                    end
                end
                for i=1:length(ind)	%adjust time vector (found in var_column(1))
                    if i<length(ind)%& batdata(ind(i),var_column(1))<batdata(ind(i)-1,var_column(1))
                        batdata(ind(i):ind(i+1)-1,var_column(1))=batdata(ind(i):ind(i+1)-1,var_column(1)) + batdata(ind(i)-1,var_column(1)); 
                    elseif i==length(ind) %& batdata(ind(i),var_column(1))<batdata(ind(i)-1,var_column(1))
                        batdata(ind(i):end,var_column(1))=batdata(ind(i):end,var_column(1))+batdata(ind(i)-1,var_column(1)); 
                    end
                end
            end
        end
        %Equations to convert data into variables
        equations=strrep(eval(['binf.',type,'.equations']),'y=','');
        for i=1:length(var_column)
            data(:,i)=eval(strrep(equations{i},'x',['batdata(:,',num2str(var_column(i)),')']));
        end
        %Set initial time to 0 sec for ABC
        if ~binf.bitrode
            data(:,1)=data(:,1)-data(1,1);	%time in first column
        end
        eval(['binf.',type,'.data=data;']);
        
        %end of function read_data
    end
end


%Revision history
% 6/25/99: vhj file created, peukert processing finished, residual capacity
% 6/25/99: vhj finished OCV
% 6/28/99: vhj finished Rint
% 6/29/99: fixed time varying portion
% 7/13/99: vhj ratedAh for Ahthresh
% 7/14/99: vhj SOC range 0,10,20:20:100
% 7/19/99: vhj adjusted Rint indb and inde--don't begin another before an end
% 7/22/99: vhj added output of SOC, VOC data points
% 8/02/99: vhj added condition to peukert begin points: next point also a discharge
% 9/20/99: vhj added tolerance bands for determining pulse indices
%10/01/99: vhj plot voltage for peukert
%10/26/99: vhj added requirement & strcmp(hdrs(1:13),'"Test Unique"') for adjusting time vector w/ bitrode tests
%12/09/99: vhj results plotting, function into input argument
%12/16/99: vhj plotting separation complete
%02/24/00: vhj changed length(ICresid(:,1)) for resid calcs
%09/07/00: vhj/mdz added '& amphours(i+1)<-thresh' condition to VOC calcs to only get charging point at 0%SOC-and not at beginning of file, changed OCV thresh to 0.08
%						round SOC for VOC
%						set all thresh's to 0.08 A
%09/08/00: vhj changed Ah capacity calcs during peukert to refer to the endpoint for both NoResidual and Residual (current(cindendNR/R))
%					changed peukert threshold to 0.11
%					Rint: added variables to word the logic of begin/end points in 'english'
%09/08/00: vhj/mdz Rint: changed logic for ending point to look at voltage changes
%					Rint thresh to 0.08 (below 0.1!), added new threshold for begin/end points
%					overwrite multiple ends for begin & end (Rint), added logic for being within 5% of multiple pulse lengths (one calculated on the fly, the others hard coded in)
%					updated mean current to cover 'entire' range of pulse (previously used 2 points), delete igood (it was wrong and not needed)
%					rounding current
%09/11/00: vhj added peukert plotting options
%09/14/00: mdz peukert: added a new scheme (3% of discharge thresh) for finding end of discharge when discharge is high rate (>=40 Amps) b/c of larger electronics' spikes at these rates
%					added '& amphours(i+1)<thresh' condition to peukert calcs to only get beginning charging points and not beginning of overcharge points
%					added '& ~isempty(cindbeginNR)' condition to peukert calcs to only get charging point at 0%SOC (after dischrages)-and not at beginning of file
%09/22/00: mdz VOC: changed '& amphours(i+1)<-thresh' to '& amphours(i)<-thresh' to look for neg. Ah BEFORE program typically resets Ah variable
%					took out t_begin variable because it wasn't finding all points for VOC and didn't play any role
%09/26/00: mdz peukert: changed 'Ahthresh=binf.peukert.ratedAh/6;' to 'Ahthresh=binf.peukert.ratedAh/10;' so it would not used first resid. of OvonicEV batt. @ 0C as a NoResid.
%09/26/00: vhj/mz changed SOC to every 10% SOC, 10% tolerance on bad Rint pulses, updated display when processing multiple files
%					march backwards with voltage to get end point
%09/27/00: vhj/mz changed Rint: look at sign(mean(i))<>0 instead of looking at current(index) to determine charge/discharge
%09/29/00: vhj changed Rint pick point to average based on voltage behavior only (no current)
% 11/07/00: ss updated threshold for voltage to 0.02 from 0.008
%01/18/01: vhj threshhold back to 0.008 for evercel template files
%03/13/01: vhj added RC calls