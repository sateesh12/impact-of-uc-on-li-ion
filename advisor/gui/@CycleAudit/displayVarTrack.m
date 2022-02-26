function displayVarTrack(cyc, fname, E)
% uses the varTracker.m function to save the information usually printed
% during a display down to a file. The user must provide a file name
% (fname) as a character array).
if length(cyc)>1
    for i=1:length(cyc)
        display(cyc(i));
    end
    return
end

[P, K, A, R, accel, dhdt, dist] = specificPower(cyc);
[velbar, accbar, decbar, velmax, accmax, decmax, hist, driveTime, velbarDrive, nStarts, nStops] = cycStats(cyc); 

assignin('base','Cycle_Audit_Class',cyc.name);
assignin('base','Max_Time',max(cyc.t));
assignin('base','Idle_Time',max(cyc.t)-driveTime);
assignin('base','Idle_Time_Per',(max(cyc.t)-driveTime)*100/max(cyc.t))
assignin('base','Drive_Time',driveTime);
assignin('base','Drive_Time_Per',driveTime*100/max(cyc.t));
assignin('base','No_Starts',nStarts);
assignin('base','No_Stops',nStops);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
assignin('base','ave_velocity', velbar);
assignin('base','ave_velocity_driving', velbarDrive);
assignin('base','ave_accel_accel', accbar);
assignin('base','ave_decel_decel', decbar);
assignin('base','peak_velocity', velmax);
assignin('base','peak_accel', accmax);
assignin('base','peak_decel', decmax);
assignin('base','distance_traveled', max(dist));
assignin('base','height_diff', (cyc.h(end)-cyc.h(1)));
assignin('base','velocity_diff', (cyc.v(end)-cyc.v(1));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
assignin('base','specPE', P.E);
assignin('base','specKE', K.E);
assignin('base','specAero',A.E);
assignin('base','specRR', R.E);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
assignin('base','specPEtrac', P.Eexpend);
assignin('base','specKEtrac', K.Eexpend);
assignin('base','specAeroTrac', A.Eexpend);
assignin('base','specRRtrac', R.Eexpend);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
assignin('base','specPEregen', P.Eregen);
assignin('base','specKEregen', K.Eregen);
assignin('base','specAeroRegen', A.Eregen);
assignin('base','specRRregen', R.Eregen);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
assignin('base','PEtracAvePwr', P.PaveExpend);
assignin('base','KEtracAvePwr', K.PaveExpend);
assignin('base','AeroTracAvePwr',A.PaveExpend);
assignin('base','RRtracAvePwr', R.PaveExpend);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
assignin('base','PEregenPwr', P.PaveRegen);
assignin('base','KEregenPwr', K.PaveRegen);
assignin('base','AeroRegenPwr', A.PaveRegen);
assignin('base','RRregenPwr', R.PaveRegen);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('E')==1
    assignin('base','travelIntensity', E.travelIntensity);
    
assignin('base','', );
assignin('base','', );
assignin('base','', );

assignin('base','Speed Histogram -- by time            :'])
for i=1:size(hist.vel.bin,1)
    assignin('base',['LowBinVelTime',num2str(i,'%02.0f')], hist.vel.bin(i,1));
    ,' to ', num2str(hist.vel.bin(i,2)),' mph :', num2str(hist.vel.time(i)),' seconds, ', num2str(hist.vel.percentTime(i)*100),'% '])
end
assignin('base','Acceleration Histogram -- by time     :'])
for i=1:size(hist.acc.bin,1)
    assignin('base',['LowBinAccTime',num2str(i,'%02.0f')], hist.acc.bin(i,1));
    ,' to ', num2str(hist.acc.bin(i,2)),' m/s/s :', num2str(hist.acc.time(i)),' seconds, ', num2str(hist.acc.percentTime(i)*100),'% '])
end
[hist, cumdist] = distanceHist(cyc, hist.vel.bin, 0);
assignin('base','Speed Histogram -- by distance        :'])
for i=1:size(hist.vel.bin,1)
    assignin('base',['LowBinVelDist',num2str(i,'%02.0f')], hist.vel.bin(i,1));
    ,' to ', num2str(hist.vel.bin(i,2)),' mph :', num2str(hist.vel.distance(i)),' meters, ', num2str(hist.vel.percentDist(i)*100),'% '])
end
assignin('base','Acceleration Histogram -- by distance :'])
for i=1:size(hist.acc.bin,1)
    assignin('base',['LowBinAccDist',num2str(i,'%02.0f')], hist.acc.bin(i,1));
    ,' to ', num2str(hist.acc.bin(i,2)),' m/s/s :', num2str(hist.acc.distance(i)),' meters, ', num2str(hist.acc.percentDist(i)*100),'% '])
end