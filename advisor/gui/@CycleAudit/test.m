function result=test(cyc)
%function 'test' for testing cycle audit program
%function will (1) run statistics on drive cycle, (2)run energy audit on specified
%drive cycle, (3) plot graphics associated with statistics, (4) plot
%graphics associated with energy audit, (5) export data from 1,2 into a
%.csv file for analysis in different programs, (6) test that cycle audit
%function works as desired

%setting C1 using default template
C1=CycleAudit
%creates structure called data using run_statistics
data=run_statistics(C1)
%creates structure called data using run_energy_audit
data=run_energy_audit(C1)
%plots statistics from variable C1
plot_statistics(C1)
%plots energy audit data from variable C1
plot_energy_audit(C1)
%saves data from run_statistics and energy_audit to file called test.csv inside current directory 
save(C1,'test.csv')
%tests to see if file was saved into test.csv
fid=fopen('test.csv','r')
%loads all file info into string 'str'
str=fscanf(fid,'%s',inf)
fclose(fid)

C2=CycleAudit
C2.time=[0:1:10]
C2.velocity=ones(1,11)*5
C2.name='average_velocity'
data=run_statistics(C2)
if data.average_velocity ==5
    result='yes, correct'
else
    result='no, does not compute'
error(['[',mfilename,'] Error! failed average velocity analysis - computed average velocity does not equal assigned average velocity of 5'])
end

function results=test_elevator()
%set up the cycle and the elevator parameters
vel=[0 0 0 0]; %meters/second
time=[0 10 20 30]; % seconds
distance=0;
gradebydistance=[100 200 300 500]; %meters

elevator_mass=10; %kg
g=9.81; %m/s^2

%set up the CycleAudit class
C=CycleAudit;

C.time=time;
C.velocity=vel;
C.gradebydistance=gradebydistance;
C.mass=elevator_mass;
C.gravity=g;
C.distance=distance;