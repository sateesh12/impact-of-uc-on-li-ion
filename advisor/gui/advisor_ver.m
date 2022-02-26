function [a_version,a_date]=advisor_ver(option)
%this provides information on the current version of advisor
%advisor_ver can be typed at the command prompt 

advisor_release_date='April 24, 2013';
year = '2003';
release = '00';
revision = 'r0116';
advisor_version=['ADVISOR ', year, '-', release, '-', revision];

if nargin==0
   disp('  ')
   disp('############################################ ');
   disp(['# ',advisor_version, ' ', advisor_release_date]);
   disp('############################################ ');
   disp(' ');
end   

if nargin>0
switch option
   
case 'info'
   a_version=advisor_version;
   a_date=advisor_release_date;
case 'number'
   a_version=advisor_version_num;
end
end