function newem = buildNewMap(em, fc_map_spd, fc_map_trq, fc_fuel_map_gpkWh_at_max_trq, fc_max_trq, fc_fuel_lhv)
% newem = buildNewMap(em, fc_map_spd, fc_map_trq, fc_fuel_map_gpkWh_at_max_trq, fc_max_trq, fc_fuel_lhv)
%
% Routine to build a new fuel map based on the existing BASE map by scaling to fit the efficiencies 
% of a new BSFC max-torque curve
% arguments: 1, eng_map object of the map to be used as the base for scaling
% arguments: 2, desired speeds of the new map in rad/s
% arguments: 3, desired torques to be evaluated with the new map (Nm)
% arguments: 4, BSFC values along the max. torque curve (g/kWh)
% arguments: 5, max torque curve of the engine
% arguments: 6, lower heating value of the fuel for the new engine (J/g)
%
% NOTE: To ensure that the new map matches exactly the efficiency and BSFC values
% given as input along the maximum torque curve, fc_map_trq should include all the values 
% found in fc_max_trq

%%%% BASE Data from eng_map Object %%%%
% (rad/s), speed range of the engine
fc_map_spd_base=em.map_spd; 
% (N*m), torque range of the engine
fc_map_trq_base=em.map_trq; 
% (g/kWh), BSFC map indexed vertically by fc_map_spd and 
% horizontally by fc_map_trq
fc_fuel_map_gpkWh_base=em.map_bsfc; % (g/kW*hr)
% (N*m), max torque curve of the engine indexed by fc_map_spd
fc_max_trq_base=em.max_trq;
fc_fuel_lhv_base=em.fuel_lhv; % (J/g), lower heating value of the fuel

%%%%% Build new efficiency and fuel consumptions maps
% find BASE max trqs corresponding to NEW spds
fc_max_trq_base_new=interp1(fc_map_spd_base,fc_max_trq_base,fc_map_spd);
for i=1:length(fc_map_spd)
    if fc_map_spd(i)<min(fc_map_spd_base) & isnan(fc_max_trq_base_new(i))
        fc_max_trq_base_new(i)=fc_max_trq_base(1);
    elseif fc_map_spd(i)>max(fc_map_spd_base) & isnan(fc_max_trq_base_new(i))
        fc_max_trq_base_new(i)=fc_max_trq_base(end);
    end
end

% build BASE efficiency and fuel consumption maps
[T,w]=meshgrid(fc_map_trq_base,fc_map_spd_base);
fc_map_kW_base=T.*w/1000; % (kW)
fc_fuel_map_base=fc_fuel_map_gpkWh_base.*fc_map_kW_base/3600; % (g/s)
fc_eff_map_base=fc_map_kW_base./(fc_fuel_map_base*fc_fuel_lhv_base/1000);
if max(max(fc_eff_map_base))>1.0 | min(min(fc_eff_map_base))<0.0
    disp(['fc_eff_map_base has gone out of bounds: max(', num2str(max(max(fc_eff_map_base))),...
            ') min(', num2str(min(min(fc_eff_map_base))),')']);
end % report error

% find BASE efficiency along the max trq curve corresponding to the NEW spds
fc_eff_at_max_trq_base=[];
for x=1:length(fc_map_spd)
    spd=fc_map_spd(x);
    trq=fc_max_trq_base_new(x);
    if fc_map_spd(x)<fc_map_spd_base(1) % implement "edge extention"
        spd=fc_map_spd_base(1);
        disp('Implementing low-end edge extention on speed')
    elseif fc_map_spd(x)>fc_map_spd_base(end)
        spd=fc_map_spd_base(end);
        disp('Implementing high-end edge extention on speed')
    end
    if fc_map_trq_base(end)<fc_max_trq_base_new(x) % implement "edge extention"
        trq=fc_map_trq_base(end);
        disp('Implementing high-end edge extention on torque')
    elseif fc_map_trq_base(1)>fc_max_trq_base_new(x)
        trq=fc_map_trq_base(1);
        disp('Implementing low-end edge extention on torqe')
    end
    fc_eff_at_max_trq_base=[fc_eff_at_max_trq_base, ...
            interp2(fc_map_spd_base,fc_map_trq_base,fc_eff_map_base',spd,trq)];
    if isnan(fc_eff_at_max_trq_base(x))
        disp(['NaN detected in fc_eff_at_max_trq_base(', num2str(x),')'])
        fc_eff_map_base
        fc_max_trq_base_new
    end
end
if max(max(fc_eff_at_max_trq_base))>1.0 | min(min(fc_eff_at_max_trq_base))<0.0
    disp(['fc_eff_at_max_trq_base has gone out of bounds: max(', num2str(max(max(fc_eff_at_max_trq_base))),...
            ') min(', num2str(min(min(fc_eff_at_max_trq_base))),')']);
end % report error


% calculate the efficiency along the max trq curve for the NEW data
fc_eff_at_max_trq=(fc_max_trq.*fc_map_spd/1000)./...
    ((fc_fuel_map_gpkWh_at_max_trq.*(fc_max_trq.*fc_map_spd/1000)/3600)*fc_fuel_lhv/1000);

if max(max(fc_eff_at_max_trq))>1.0 | min(min(fc_eff_at_max_trq))<0.0
    disp(['fc_eff_at_max_trq has gone out of bounds: max(', num2str(max(max(fc_eff_at_max_trq))),...
            ') min(', num2str(min(min(fc_eff_at_max_trq))),')']);
end % report error

% build a matrix of efficiencies for the BASE data indexed by NEW spds and 
% fraction of max trq at the current speed
fc_max_trq_frac=[0.05:0.05:1.0];
fc_eff_map_base_new=[];
for x=1:length(fc_map_spd)
    spd = fc_map_spd(x);
    trqs= fc_max_trq_frac*fc_max_trq_base_new(x);
    if fc_map_spd(x)<fc_map_spd_base(1) % implement "edge extention"
        spd=fc_map_spd_base(1);
        disp('Implementing low-end edge extention on speed--fc_eff_map_base_new creation')
    elseif fc_map_spd(x)>fc_map_spd_base(end)
        spd=fc_map_spd_base(end);
        disp('Implementing high-end edge extention on speed--fc_eff_map_base_new creation')        
    end
    for y=1:length(trqs)
        if trqs(y)>fc_map_trq_base(end) % implement "edge extention"
            trqs(y)=fc_map_trq_base(end);
            disp('Implementing high-end edge extention on torque--fc_eff_map_base_new creation')
        elseif trqs(y)<fc_map_trq_base(1)
            trqs(y)=fc_map_trq_base(1);
            disp('Implementing low-end edge extention on speed--fc_eff_map_base_new creation')        
        end
    end
    fc_eff_map_base_new=[fc_eff_map_base_new ...
            interp2(fc_map_spd_base,fc_map_trq_base,fc_eff_map_base',spd,trqs)];
end
fc_eff_map_base_new=fc_eff_map_base_new'; % eff map translated to new map speeds and non-dimensional trq

% generate the remainder of the NEW efficiency map (i.e., info below the max. torque) 
% this efficiency map is indexed by fc_max_trq_frac and NEW spds 
% by scaling the BASE data according to: (NEW eff at max trq/BASE eff at max trq)
fc_eff_map_new=[];
for x=1:length(fc_map_spd)
    fc_eff_map_new=[fc_eff_map_new; fc_eff_map_base_new(x,:)*(fc_eff_at_max_trq(x)/fc_eff_at_max_trq_base(x))];
    disp(['Efficiencies at Max. Torque: BASE (', num2str(fc_eff_at_max_trq_base(x)*100),...
            '%)  NEW (', num2str(fc_eff_at_max_trq(x)*100), '%) '])
end

if 1 % plot results
    figure
    c=contour(fc_map_spd*30/pi,fc_max_trq_frac,fc_eff_map_new'*100);
    clabel(c)
    title('Efficiency vs. Engine Speed and Max. Torque Fraction')
    xlabel('Engine Speed (RPM)')
    ylabel('Max. Torque Fraction')
end

% generate new NEW efficiency map indexed by NEW trq and NEW spd vectors
fc_eff_map_new_new=[];
for x=1:length(fc_map_spd)
    trqs=fc_map_trq;
    for y=1:length(trqs)
        if trqs(y)>max(fc_max_trq_frac*fc_max_trq(x)) % implement "edge extention"
            trqs(y)=max(fc_max_trq_frac*fc_max_trq(x));
            disp('Implementing high-end edge extention on torque--fc_eff_map')
        elseif trqs(y)<min(fc_max_trq_frac*fc_max_trq(x))
            trqs(y)=min(fc_max_trq_frac*fc_max_trq(x));
            disp('Implementing low-end edge extention on speed--fc_eff_map')        
        end
    end    
    fc_eff_map_new_new=[fc_eff_map_new_new ...
            interp2(fc_map_spd,(fc_max_trq_frac*fc_max_trq(x)),fc_eff_map_new',fc_map_spd(x),trqs)];
end
fc_eff_map_new_new=fc_eff_map_new_new';

% fill in gaps in the map
for x=1:length(fc_map_spd)
    for y=1:length(fc_map_trq)
        if isnan(fc_eff_map_new_new(x,y))
            fc_eff_map_new_new(x,y)=min(min(fc_eff_map_new_new));
            %disp(['NaN detected! at fc_map_spd(', num2str(x),', ', num2str(y), ') Setting to minimum efficiency...'])
        end
    end
end

% generate the new fuel consumption and efficiency maps for the NEW data
[T,w]=meshgrid(fc_map_trq,fc_map_spd);
fc_map_kW=T.*w/1000; % shaft power out
fc_fuel_map=(1000/fc_fuel_lhv)*(fc_map_kW./fc_eff_map_new_new); % [g/s] = [g/kJ_fuel input]*[kJ_shaft/s]*[kJ_fuel/kJ_shaft]
fc_bsfc_map=fc_fuel_map.*3600./fc_map_kW; % g/kWh = [g/s]*[3600 s/h]*[1/kW]
fc_eff_map=fc_eff_map_new_new;

% check results
if 1
    figure
    plot(fc_map_spd*30/pi,fc_max_trq)
    hold
    plot(fc_map_spd*30/pi,fc_max_trq,'rx')
    c=contour(fc_map_spd*30/pi,fc_map_trq,fc_eff_map'*100);
    clabel(c)
    title('Efficiency Map by Torque and Speed')
    xlabel('Speed (RPM)')
    ylabel('Torque (Nm)')
    
    [T,w]=meshgrid(fc_map_trq,fc_map_spd);
    fc_map_kW=T.*w/1000;
    fc_fuel_map_gpkWh=fc_fuel_map./fc_map_kW*3600;
    
    figure
    plot(fc_map_spd*30/pi,fc_max_trq)
    hold
    plot(fc_map_spd*30/pi,fc_max_trq,'rx')
    c=contour(fc_map_spd*30/pi,fc_map_trq,fc_fuel_map_gpkWh',[191 192 193 194 196 197 202]);
    clabel(c)
    title('BSFC (g/kWh) Map by Torque and Speed')
    xlabel('Speed (RPM)')
    ylabel('Torque (Nm)')
    
    fc_eff_at_max_trq_new=[];
    for x=1:length(fc_map_spd)
        
        fc_eff_at_max_trq_new=[fc_eff_at_max_trq_new ...
                interp2(fc_map_spd,fc_map_trq,fc_eff_map',fc_map_spd(x),fc_max_trq(x))];
    end;
    try
        eff_diff=fc_eff_at_max_trq-fc_eff_at_max_trq_new;
    catch
        for x=1:min([length(fc_eff_at_max_trq) length(fc_eff_at_max_trq_new)])
            eff_diff(x)=fc_eff_at_max_trq(x)-fc_eff_at_max_trq_new(x);
        end
        eff_diff
    end
    bsfc=[];
    for x=1:length(fc_map_spd) 
        bsfc=[bsfc interp2(fc_map_spd,fc_map_trq,...
                (fc_fuel_map./fc_map_kW*3600)',fc_map_spd(x),fc_max_trq(x))]; 
    end;
    try
        bsfc_diff=fc_fuel_map_gpkWh_at_max_trq-bsfc
    catch
        for x=1:min([length(bsfc) length(fc_fuel_map_gpkWh_at_max_trq)])
            bsfc_diff(x)=fc_fuel_map_gpkWh_at_max_trq(x)-bsfc(x);
        end
        bsfc_diff
    end
end;

% Create and Return the New Map! (assuming everything worked...)
newem = eng_map(fc_map_spd, fc_map_trq, fc_bsfc_map, fc_fuel_lhv, fc_max_trq);
