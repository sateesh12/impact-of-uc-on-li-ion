function makeCycFile(cyc, name)
% function makeCycFile(cyc, name)
% creates an ADVISOR CYC_*.mat file for use with ADVISOR CYC_*.m file

try
    cyc_mph=[cyc.t, cyc.v./0.44704]; % convert from m/s to mph
    cyc_description=cyc.name; % get the name from the advisor file
    
    % ok, need to fix the grade calcs LATER!
%     vAvg=conv(cyc.v,[0.5 0.5]);
%     vAvg=vAvg(2:end-1); % shave off the edges which don't mean anything
%     dd = vAvg.*diff(cyc.t); % distance in meters
%     dh = diff(cyc.h);
%     index=find(dd~=0);
%     aveGrade=dh(index)./dd(index);
%     grade=[0; conv(aveGrade,[1 -1]).*(dd./2)./conv(dd,[0.5 0.5])
%     dh = diff(cyc.h(index));
%     dd = diff(dcum(index));
%     grade=conv(dh,[1 1])./conv(dd,[1 1]);
%     cyc_grade=[dcum(index), grade];
%     
     save(name,'cyc_mph','cyc_description');
catch
    keyboard
end
