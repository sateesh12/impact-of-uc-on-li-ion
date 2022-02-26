function interpolator(bore1,strk1,etype,bore2,strk2,trq_vec,spd_vec,sfc,no,hc,co,new_filename)
%this function was converted from fortran to MATLAB code by Sam Sprik of NREL in December 2001
%Original fortran code is described below
%bore and strokes in cm, etype=1,2,or 3,  map=, trq_vec in N, spd_vec in rad/s
%no,hc,co are emissions maps in ppm
%sfc in g/kWh use indicated sfc for direct injected engines and brake sfc for port fuel injected engines
%c@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%c
%c
%c
%c                            AN EMISSIONS SCALAR ALGORITHM 
%c                            FOR SI AND CI ENGINE MAPS USED
%c                          WITHIN THE ADVISOR HEV SIMULATOR
%c
%c
%c                                 
%c                              DOE CONTRACT 4000003049
%c
%c                          POC: SCOTT SLUDER
%c                               OAK RIDGE NATIONAL LABORATORIES
%c                               P.O. BOX 2008
%c                               BETHAL VALLEY ROAD
%c                               OAK RIDGE, TN  37831-6437
%c
%c
%c                          DEVELOPED BY:
%c                               TIM WILSON / DOUG BAKER
%c                               TECAT ENGINEERING INC.
%c                               20501 PARKER ROAD
%c                               LIVONIA, MI  48152
%c
%c
%c                                  AUGUST 31, 2001
%c
%c
%c     PURPOSE:
%c         ALGORITHM FOR NORMALIZING BORE/STROKE SCALARS TO ADVISOR 
%c         BASELINE ENGINE MAPS AND CREATING NEW BORE/STROKE SCALAR
%c         MAPS AT A USER-SPECIFIED TARGET BORE AND STROKE.
%c
%c@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%c    
%c+++++++++++++++++++++++++
%c  INPUTS
%c+++++++++++++++++++++++++
%c
%c  ADVISOR BASELINE ENGINE FILE INPUTS:
%c
%c   LINE 1:
%c     bore1               cylinder bore of baseline engine to be scaled (engine 1).
%c     strk1	          stroke of baseline engine to be scaled (engine 1).
%c   LINE 2:
%c     nrtorq              # of torque data points
%c     nrrpm               # of speed data points
%c   LINE 3 - # data pts:
%c     torq                engine torque (N-M/cylinder)
%c     rpm                 engine speed (RPM)
%c     hc                  HC emissions (PPM)
%c     co                  CO emissions (PPM)
%c     no                  NO emissions (PPM)
%c     sfc                 Specific fuel consumption (g/kW/hr).  Note: use indicated
%c                         sfc for direct-injected, brake sfc for port-injected engines.
%c
%c   RUNTIME INPUTS:
%c
%c     etype               engine type selector:
%c        	             1) direct injected diesel
%c         	             2) direct injected gas
%c        	             3) port injected gas
%c
%c     bore2	           cylinder bore of target engine to scale to (engine 2).
%c
%c     strk2	           stroke of target engine to scale to (engine 2).
%c
%c
%c ++++++++++++++++++++++++
%c  SIMULATION VARIABLES
%c ++++++++++++++++++++++++
%c
%c     dd*	           logical flag for direct injected diesel
%c
%c     dg*	           logical flag for direct injected gas
%c
%c     pg*                 logical flag for port injected gas
%c
%c
%c     bpts                number of bore dimensions for which simulations were performed for an engine type.
%c     stpts               number of stroke dimensions for which simulations were performed for an engine type.
%c     ldpts               number of load values for which simulations were
%c                         performed for an engine type.
%c     rpmpt               number of speed values for which simulations were
%c                         performed for an engine type.
%c     ivals               number of emissions which are scaled for an engine type.
%c                         Note that torque is the last value in this list and is not scaled.
%c
%c     *NOTE: One of these logical flags must be set to true with all others set to false.
%c
%c    TJW 8/31/01
%c
%c@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%c

%check to make sure all the inputs are defined if running with inputs
if nargin>0
    if ~exist('bore1');error('all input variables not defined');end
    if ~exist('strk1');error('all input variables not defined');end    
    if ~exist('etype');error('all input variables not defined');end    
    if ~exist('bore2');error('all input variables not defined');end    
    if ~exist('strk2');error('all input variables not defined');end    
    if ~exist('trq_vec');error('all input variables not defined');end    
    if ~exist('spd_vec');error('all input variables not defined');end        
    if ~exist('sfc');error('all input variables not defined');end    
    if ~exist('co');error('all input variables not defined');end    
    if ~exist('no');error('all input variables not defined');end    
    if ~exist('hc');error('all input variables not defined');end    
end

%c +++ Direct injection diesel parameters.
bptsdd=3;
stptsdd=3;
ldptsdd=3;
rpmptdd=3;
ivalsdd=5;
%c
%c +++ Direct injection gas parameters.
bptsdg=4;
stptsdg=4;
ldptsdg=4;
rpmptdg=4;
ivalsdg=5;
%c
%c +++ Port injection gas parameters.
bptspg=3;
stptspg=3;
ldptspg=16;
rpmptpg=47;
ivalspg=5;
%c
%c +++ Advisor baseline engine parameters.
mxtqpts=50;
mxrpmpts=50;
%c
mxbpts=4;
mxstpts=4;
mxldpts=16;
mxrpmpt=47;
mxvlues=5;
%c

%c
%c +++ Read experimental data.
if nargin==0
    %c +++ Get engine type.
    dd=0;
    dg=0;
    pg=0;
    etype=input(['1) Direct injected CI\n'...
                '2) Direct injected SI\n'...
                '3) Port injected SI\n'...
                'Enter engine type:  ']);
       
    if etype==1.0
        dd=1;
    elseif etype==2.0
        dg=1;
    elseif etype==3.0
        pg=1;
    else
        errordlg('etype has to be 1,2 or 3')
        return
    end
    
    %c +++ Get bore & stroke dimensions to scale to.
    bore2= input('Enter Bore to scale to (cm): ');
    strk2= input('Enter Stroke to scale to (cm): '); %cm
    
    if exist('exp.dat','file')
        fid=fopen('exp.dat','rt');
        bore1=fscanf(fid,'%f',1);
        strk1=fscanf(fid,'%f',1);
        nrtorq=fscanf(fid,'%f',1);
        nrrpm=fscanf(fid,'%f',1);
        %tempmatrix=fscanf(fid,'%f',[6 nrtorq*nrrpm])';
        for i=1:nrtorq
            for j=1:nrrpm
                torq(i,j)=fscanf(fid,'%f',1);
                rpm(i,j)=fscanf(fid,'%f',1);
                hc(i,j)=fscanf(fid,'%f',1);
                co(i,j)=fscanf(fid,'%f',1);
                no(i,j)=fscanf(fid,'%f',1);
                sfc(i,j)=fscanf(fid,'%f',1);
            end
        end
        fclose(fid)
    end
else
    dd=0;
    dg=0;
    pg=0;
    if etype==1.0
        dd=1;
    elseif etype==2.0
        dg=1;
    elseif etype==3.0
        pg=1;
    else
        errordlg('etype has to be 1,2 or 3')
        return
    end
    
    nrtorq=length(trq_vec);
    nrrpm=length(spd_vec);
    [rpm,torq]=meshgrid(spd_vec*30/pi,trq_vec);
    
end
%c
%run m-file with interpolator data in it
interpolator_data
%c


%c
%c ++++++++++++++++++++++==+++++++++++++++++++++++++++++
%c +++ load scalar tables for selected engine type +++++
%c +++++++++++++++++++++++++++++++++++++++++++++++++++++
%c
%c +++ Set parameters for the specific kind of engine being used.
if dd
    bpts = bptsdd;
    stpts = stptsdd;
    rpmpts = rpmptdd;
    ldpts = ldptsdd;
    ivalues = ivalsdd;
%c
    for i=1:bptsdd
        bores(i)=boresdd(i);
    end
%c
    for i=1:stptsdd
        stks(i)=stksdd(i);
    end
%c
    for i=1:ldptsdd
        lds(i)=lddd(i);
    end
%c
    for i=1:rpmptdd
        rpms(i)=rpmsdd(i);
    end
%c
elseif dg
    bpts = bptsdg;
	stpts = stptsdg;
	rpmpts = rpmptdg;
	ldpts = ldptsdg;
	ivalues = ivalsdg;
%c
    for i=1:bptsdg
        bores(i)=boresdg(i);
    end
%c
    for i=1:stptsdg
        stks(i)=stksdg(i);
    end
%c
    for i=1:ldptsdg
        lds(i)=lddg(i);
    end
%c
    for i=1:rpmptdg
        rpms(i)=rpmsdg(i);
    end
%c
elseif pg
    bpts = bptspg;
	stpts = stptspg;
	rpmpts = rpmptpg;
	ldpts = ldptspg;
	ivalues = ivalspg;
%c
    for i=1:bptspg
        bores(i)=borespg(i);
    end
%c
    for i=1:stptspg
        stks(i)=stkspg(i);
    end
%c
    for i=1:ldptspg
        lds(i)=ldpg(i);
    end
%c
    for i=1:rpmptpg
        rpms(i)=rpmspg(i);
    end
end; %if dd
%c
%c +++ Dimensions of engine to scale 'from' and 'to' must not be out of range.
if bore1 < bores(1) 
    disp(['Warning:  Baseline ADVISOR engine bore out of range.'])
    disp(['Bore limited to ' num2str(bores(1)) ])
	bore1 = bores(1);
elseif bore1 > bores(bpts)
    disp(['Warning:  Baseline ADVISOR engine bore out of range.'])
    disp(['Bore limited to ' num2str(bores(bpts)) ])
	bore1 = bores(bpts);
end
if bore2 < bores(1)
    disp(['Warning:  Scaled engine bore out of range.'])
    disp(['Bore limited to ' num2str(bores(1)) ])
	bore2 = bores(1);
elseif bore2 > bores(bpts)
    disp(['Warning:  Scaled engine bore out of range.'])
    disp(['Bore limited to ' num2str(bores(bpts)) ])
	bore2 = bores(bpts);
end
if strk1 < stks(1)
    disp(['Warning:  Baseline ADVISOR engine stroke out of range.'])
    disp(['Stroke limited to ' num2str(stks(1)) ])
	strk1 = stks(1);
elseif strk1 > stks(stpts)
    disp(['Warning:  Baseline ADVISOR engine stroke out of range.'])
    disp(['Stroke limited to ' num2str(stks(stpts)) ])
	strk1 = stks(stpts);
end
if strk2 < stks(1)
    disp(['Warning:  Scaled engine stroke out of range.'])
    disp(['Stroke limited to ' num2str(stks(1)) ])
	strk2 = stks(1);
elseif strk2 > stks(stpts)
    disp(['Warning:  Scaled engine stroke out of range.'])
    disp(['Stroke limited to ' num2str(stks(stpts)) ])
	strk2 = stks(stpts);
end
%c
%c +++ Move the scalar data for selected engine type into 'scldata'.  
%c +++ Use:
%c +++   'scldd' for direct injection diesel 
%c +++   'sclpg' for port injected gasoline
%c +++   'scldg' for direct injected gasoline
%c
for i=1:ivalues
    for j=1:rpmpts
        for k=1:ldpts
            for l=1:stpts
                for m=1:bpts
                    if dd 
                        scldata(m,l,k,j,i) = scldd(m,l,k,j,i);
                    elseif dg 
                        scldata(m,l,k,j,i) = scldg(m,l,k,j,i);
                    elseif pg
                        scldata(m,l,k,j,i) = sclpg(m,l,k,j,i);
                    end %if dd
                end %for m
            end % for l
        end % for k
    end %for j
end %for i
%c
%c ++++++++++++++++++++++==+++++++++++++++++++++++++++++++++++++++
%c +++ Normalize data to dimensions of ADVISOR baseline engine.
%c +++ Identify 'quadrant' of simulated engines containing
%c +++ ADVISOR baseline engine as defined by bore1 & stroke1.
%c ++++++++++++++++++++++==+++++++++++++++++++++++++++++++++++++++
%c
for i = 1:bpts - 1
    if bore1 >= bores(i) & bore1 <= bores(i+1) 
        ibrng = i;
    end %if
end %for
%c
for i = 1:stpts - 1
    if strk1 >= stks(i) & strk1 <= stks(i+1)
        isrng = i;
    end %if
end %for
%c
%c +++ Create 'emap' which is an emission map at bore1 & stroke1.
bfctr = (bore1 - bores(ibrng)) / (bores(ibrng+1) - bores(ibrng));
sfctr = (strk1 - stks(ibrng)) / (stks(isrng+1) - stks(isrng));
for i = 1:ivalues
    for j = 1:rpmpts
        for k = 1:ldpts
            sintrp1 = scldata(ibrng,isrng,k,j,i) + sfctr*(scldata(ibrng,isrng+1,k,j,i) - scldata(ibrng,isrng,k,j,i));
            sintrp2 = scldata(ibrng+1,isrng,k,j,i) + sfctr*(scldata(ibrng+1,isrng+1,k,j,i)-scldata(ibrng+1,isrng,k,j,i));
            emap1(k,j,i) = sintrp1 + (sintrp2 - sintrp1)*bfctr;
        end %for k
    end %for j
end %for i
%c
%c +++ Divide 'scldata' which is the scalar data for chosen engine type,
%c +++ by the emap so that all data is now relative to bore1 & stroke1.
for i = 1:ivalues - 1
    for j = 1:rpmpts
        for k = 1:ldpts
            for l = 1:stpts
                for m = 1:bpts
                    scldata(m,l,k,j,i) = scldata(m,l,k,j,i) / emap1(k,j,i);
                end %for m
            end %for l
        end %for k
    end %for j
end %for i
%c
%c ++++++++++++++++++++++==+++++++++++++++++++++++++++++++++++++++
%c +++ Identify 'quadrant' of simulated engines containing 
%c +++ target engine design defined by bore2 & stroke2.
%c ++++++++++++++++++++++==+++++++++++++++++++++++++++++++++++++++
%c
for i = 1:bpts - 1
    if bore2 >= bores(i) & bore2 <= bores(i+1)
        ibrng = i;
    end %if
end %for
%
for i = 1:stpts - 1
    if strk2 >= stks(i) & strk2 <= stks(i+1)
        isrng = i;
    end %if
end %for
%c
%c +++ Create a new 'emap' which is an emission map at bore2 & stroke2.
bfctr = (bore2 - bores(ibrng)) / (bores(ibrng+1) - bores(ibrng));
sfctr = (strk2 - stks(isrng)) / (stks(isrng+1) - stks(isrng));
for i = 1:ivalues
    for j = 1:rpmpts
        for k = 1:ldpts
            sintrp1 = scldata(ibrng,isrng,k,j,i) + sfctr*(scldata(ibrng,isrng+1,k,j,i) - scldata(ibrng,isrng,k,j,i));
            sintrp2 = scldata(ibrng+1,isrng,k,j,i) + sfctr*(scldata(ibrng+1,isrng+1,k,j,i)-scldata(ibrng+1,isrng,k,j,i));
            emap2(k,j,i) = sintrp1 + (sintrp2 - sintrp1)*bfctr;
        end %for k
    end %for j
end %for i
%c
%c +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%c +++ End of baseline & target scalar map generation. +++++
%c +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%c
%c +++ Write scaled engine file.
fid=fopen('exp.out','wt');
fprintf(fid,'%f  %f\n',bore2,strk2);
fprintf(fid,'%f  %f\n',nrtorq,nrrpm);
%c
%c ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%c     Determine performance/emissions maps for target engine.
%c     Use baseline ADVISOR map resolution for output.
%c ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%c
rpmmn = max(rpm(1,1),rpms(1));
rpmmx = min(rpm(1,nrrpm),rpms(rpmpts));
delrpm = (rpmmx - rpmmn) / (nrrpm - 1);
%c
torqmn = 999999;
torqmx = 0;
for j = 1: rpmpts
    for i = 1: ldpts
        torqmx = max(emap2(i,j,ivalues), torqmx);
        if emap2(i,j,ivalues) ~= -1.00000
            torqmn = min(emap2(i,j,ivalues), torqmn);
        end %if
    end %for i
end %for j
deltorq = (torqmx - torqmn) / (nrtorq - 1);
%c
%c +++ Beginning of loop over torq & speed to determine target maps +++++
%c
spd_map_rpm=[];
trq_map_Nm=[];
fuel_map_gpkWh=[];
co_map_gpkWh=[];
no_map_gpkWh=[];
hc_map_gpkWh=[];
for itorq=1:nrtorq
    rtorq = torqmn + (itorq - 1)*deltorq;
    %c
    for irpm=1:nrrpm
        rrpm = rpmmn + (irpm - 1)*delrpm;
        %c
        %c +++     Find RPM band.
        for i=1:rpmpts-1
            if rrpm >= rpms(i) & rrpm <= rpms(i+1)
                irpmrng = i;
            end %if
        end %for
        %c
        %c +++     Interpolate scalars between speed bands using request speed.
        factrpm = (rrpm-rpms(irpmrng))/(rpms(irpmrng+1)-rpms(irpmrng));
        for i=1:ivalues
            for k=1:ldpts
                vector(k,i) = emap2(k,irpmrng,i) + factrpm*...
                    (emap2(k,irpmrng+1,i) - emap2(k,irpmrng,i));
            end %for
        end %for
%c
%c +++     Find Load along target rpm; limit if out of range.
	    torqcl = rtorq;
        if rtorq < vector(1,ivalues)
            torqcl = vector(1,ivalues);
            disp(['Warning: Requested torque out of range.  RPM = ', num2str(rrpm)]);
            disp([' Torq = ', num2str(rtorq), '  Torq limited to ', num2str(torqcl)]);   
            ldlo = 1;
        elseif rtorq > vector(ldpts,ivalues)
            torqcl = vector(ldpts,ivalues);
            disp(['Warning: Requested torque out of range.  RPM = ', num2str(rrpm)]);
            disp(['  Torq = ', num2str(rtorq), '  Torq limited to ', num2str(torqcl)]);
            ldlo = ldpts - 1;
        else
            for i=1:ldpts - 1
                if rtorq >= vector(i,ivalues) & rtorq <= vector(i+1,ivalues)
                    ldlo = i;
                end %if
            end % for
        end %if
%c
%c +++     Find load interpolation factor along target rpm band.
	    factld = (torqcl - vector(ldlo,ivalues)) /...
                  (vector(ldlo+1,ivalues)-vector(ldlo,ivalues));
%c
%c +++     Calculate Scalars
        for i=1:ivalues - 1
            scalar(i) = vector(ldlo,i) + factld *...
                (vector(ldlo+1,i)-vector(ldlo,i));
        end %for
%c
%c +++     Find target PHI (or MAP) which produced the requested torque.
	    phi = lds(ldlo) + factld * (lds(ldlo+1) - lds(ldlo));
%c
%c +++     Find the equivalent Baseline torque, which is the torque
%c +++     produced by the baseline engine at the same PHI (or MAP) 
%c +++     condition as the scaled target engine.
	    for i = 1:ldpts - 1
            if phi >= lds(i) & phi <= lds(i+1)
                phifact = (phi - lds(i))/(lds(i+1) - lds(i));
                iphirng = i ;
            end %end if
        end %for
	    btorqlo = emap1(iphirng,irpmrng,ivalues) + (emap1(iphirng+1,irpmrng,ivalues)...
            - emap1(iphirng,irpmrng,ivalues)) * phifact;
	    btorqhi = emap1(iphirng,irpmrng+1,ivalues) + (emap1(iphirng+1,irpmrng+1,ivalues)...
            -emap1(iphirng,irpmrng+1,ivalues))*phifact;
	    btorq = (1-factrpm)*btorqlo + factrpm*btorqhi;
%c
%c +++     Find baseline emissions at equivalent 
%c         torque (btorq) and request speed (rrpm)
%c
%c +++     Find RPM band within baseline engine.
        for i=1:nrrpm-1
            if rrpm >= rpm(1,i) & rrpm <= rpm(1,i+1)
                irpmrng = i;
            end %if
        end %for
%c
%c +++     Find RPM interpolation factor.
	    factrpm=(rrpm-rpm(1,irpmrng))/...
            (rpm(1,irpmrng+1)-rpm(1,irpmrng));
%c
%c +++     Find Torque band.  Is the same for both sides of the rpm band.
        if btorq < torq(1,irpmrng)
            disp(['Warning:  Scaled torq out of range in ADVISOR engine map.']);
            disp(['   RPM = ',num2str(rpm(1,irpmrng)),' Torq = ',num2str(btorq),' Torq limited to ',num2str(torq(1,irpmrng))]);
            btorq = torq(1,irpmrng);
            ldlo = 1;
        elseif btorq > torq(nrtorq,irpmrng)
            disp(['Warning:  Scaled torq out of range in ADVISOR engine map.']);
            disp(['   RPM = ',num2str(rpm(nrrpm,irpmrng)),' Torq = ',num2str(btorq),' Torq limited to ',num2str(torq(nrtorq,irpmrng))]);
            btorq = torq(nrtorq,irpmrng);
            ldlo = nrtorq - 1;
        else
            for i=1:nrtorq - 1
                if btorq >= torq(i,irpmrng) & btorq <= torq(i+1,irpmrng)	
                    ldlo = i;
                end %if
            end %for
        end %if
%c
%c +++     Find Load Factor.  Is the same at both sides of rpm band.
	    factlo = (btorq - torq(ldlo,irpmrng)) /...
            (torq(ldlo+1,irpmrng) - torq(ldlo,irpmrng));
%c
%c +++     Calculate BASELINE engine emissions at btorq & rrpm using factlo & factrpm.
	    hclo = hc(ldlo,irpmrng) + (hc(ldlo+1,irpmrng) - hc(ldlo,irpmrng))*factlo;
	    colo = co(ldlo,irpmrng) + (co(ldlo+1,irpmrng) - co(ldlo,irpmrng))*factlo;
	    nolo = no(ldlo,irpmrng) + (no(ldlo+1,irpmrng) - no(ldlo,irpmrng))*factlo;
	    sfclo = sfc(ldlo,irpmrng) + (sfc(ldlo+1,irpmrng) - sfc(ldlo,irpmrng))*factlo;
%c
	    hchi = hc(ldlo,irpmrng+1) + (hc(ldlo+1,irpmrng+1) - hc(ldlo,irpmrng+1))*factlo;
	    cohi = co(ldlo,irpmrng+1) + (co(ldlo+1,irpmrng+1) - co(ldlo,irpmrng+1))*factlo;
	    nohi = no(ldlo,irpmrng+1) + (no(ldlo+1,irpmrng+1) - no(ldlo,irpmrng+1))*factlo;
	    sfchi = sfc(ldlo,irpmrng+1) + (sfc(ldlo+1,irpmrng+1) - sfc(ldlo,irpmrng+1))*factlo;
%c
	    emishc = hclo + (hchi - hclo)*factrpm;
	    emisco = colo + (cohi - colo)*factrpm;
	    emisno = nolo + (nohi - nolo)*factrpm;
	    emissfc = sfclo + (sfchi - sfclo)*factrpm;
%c
%c +++     Multiply emis by the appropriate scalar value.
	    emishc = emishc * scalar(1);
	    emisco = emisco * scalar(2);
	    emisno = emisno * scalar(3);
	    emissfc = emissfc * scalar(4);
%c
%c +++     Write emission results to output file.
        %format(f4.1,'   ',f5.0,'   ',3(f7.0,'   '),f7.1)
        fprintf(fid,'%4.1f  %5.0f  %7.0f  %7.0f  %7.0f  %7.1f\n',rtorq, rrpm, emishc, emisco, emisno, emissfc);
        %fill in matrices
        if itorq==1
            spd_map_rpm=[spd_map_rpm rrpm];
        end
        fuel_map_gpkWh(irpm,itorq)=emissfc;
        hc_map_gpkWh(irpm,itorq)=emishc;
        co_map_gpkWh(irpm,itorq)=emisco;
        no_map_gpkWh(irpm,itorq)=emisno;
    end %for
        trq_map_Nm=[trq_map_Nm rtorq];

end %for
fclose(fid);

fid2=fopen(new_filename,'wt');

fprintf(fid2,['%% ',strrep(new_filename,'\','\\') , '  ',strrep(advisor_ver('info'),'\','\\') ,' scaled fuel converter file created: ',datestr(now,0),'\n\n']);
fprintf(fid2,['spd_map_rpm=' strrep(mat2str(spd_map_rpm,5),';','\n') '\n']);
fprintf(fid2,['trq_map_Nm=' strrep(mat2str(trq_map_Nm,5),';','\n') '\n\n']);
fprintf(fid2,['hc_map_gpkWh=' strrep(mat2str(hc_map_gpkWh,5),';','\n') '\n\n']);
fprintf(fid2,['co_map_gpkWh=' strrep(mat2str(co_map_gpkWh,5),';','\n') '\n\n']);
fprintf(fid2,['no_map_gpkWh=' strrep(mat2str(no_map_gpkWh,5),';','\n') '\n\n']);
fprintf(fid2,['fuel_map_gpkWh=' strrep(mat2str(fuel_map_gpkWh,5),';','\n') '\n']);
fclose(fid2);

edit(new_filename)
