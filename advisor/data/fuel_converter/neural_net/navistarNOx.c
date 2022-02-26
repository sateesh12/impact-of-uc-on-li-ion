/* Insert this code into your C program to fire the C:\NeuroShell 2\Nav Pos NOx (04-05-02) network */
/* This code is designed to be simple and fast for porting to any machine */
/* Therefore all code and weights are inline without looping or data storage */
/*   which might be harder to port between compilers. */

/* 
% Neural Network Mex file for Use with ADVISOR: navistarNOx.c
%
% Data source: Testing by West Virginia University
%
% Data confidence level:  no comparison has been performed
%
% Notes:  Neural Network predicts CO2 emissions of Navistar CI Engine
% Navistar T 444E (model year 1994), 8-cylinder, 7.3 liter, rated power of 175 HP, peak torque 460 Nm@1400 rpm,
% speed governed at 2600 rpm
%
% Created on:  05 April 2002
% By:  Michael O'Keefe, National Renewable Energy Laboratory, Michael_OKeefe@nrel.gov
%
% Revision history at end of file.
*/

#include <math.h>
#include "mex.h"

void navistarNOx(double *inarray, double *outarray)
{
 double netsum;
 double feature2[20];
 double feature3[20];
 double feature4[20];

/* inarray[0] is Disp._Spd in rpm */
/* inarray[1] is dS/dt(5s) [s(t)-s(t-5.0)]/[5.0]*/
/* inarray[2] is dS/dt(10s) [s(t)-s(t-10.)]/[10.]*/
/* inarray[3] is Disp_T in Nm*/
/* inarray[4] is dT/dt(5s) [T(t)-T(t-5.0)]/[5.0]*/
/* inarray[5] is dT/dt(10s) [T(t)-T(t-5.0)]/[5.0] */
/* outarray[0] is NOx in g/s */

if (inarray[0]<240.1239) inarray[0] = 240.1239;
if (inarray[0]>2713.334) inarray[0] = 2713.334;
inarray[0] =  2 * (inarray[0] - 240.1239) / 2473.21 -1;

if (inarray[1]<-171.4034) inarray[1] = -171.4034;
if (inarray[1]>225.1266) inarray[1] = 225.1266;
inarray[1] =  2 * (inarray[1] + 171.4034) / 396.53 -1;

if (inarray[2]<-130.8206) inarray[2] = -130.8206;
if (inarray[2]>167.3204) inarray[2] = 167.3204;
inarray[2] =  2 * (inarray[2] + 130.8206) / 298.141 -1;

if (inarray[3]<-292.7434) inarray[3] = -292.7434;
if (inarray[3]>781.8658) inarray[3] = 781.8658;
inarray[3] =  2 * (inarray[3] + 292.7434) / 1074.609 -1;

if (inarray[4]<-145.1079) inarray[4] = -145.1079;
if (inarray[4]>91.80727) inarray[4] = 91.80727;
inarray[4] =  2 * (inarray[4] + 145.1079) / 236.9152 -1;

if (inarray[5]<-68.89952) inarray[5] = -68.89952;
if (inarray[5]>65.36434) inarray[5] = 65.36434;
inarray[5] =  2 * (inarray[5] + 68.89952) / 134.2639 -1;

netsum = -0.3957765;
netsum += inarray[0] * 0.3044781;
netsum += inarray[1] * 0.3454607;
netsum += inarray[2] * -0.1045618;
netsum += inarray[3] * 0.1303231;
netsum += inarray[4] * -0.2393644;
netsum += inarray[5] * 0.1215367;
feature2[0] = tanh(netsum);

netsum = 0.1279111;
netsum += inarray[0] * -1.542995E-03;
netsum += inarray[1] * 0.2543725;
netsum += inarray[2] * -0.2499526;
netsum += inarray[3] * 8.989598E-02;
netsum += inarray[4] * 0.2360211;
netsum += inarray[5] * -5.703045E-02;
feature2[1] = tanh(netsum);

netsum = -0.3117902;
netsum += inarray[0] * -0.3630034;
netsum += inarray[1] * 0.2688982;
netsum += inarray[2] * 9.257457E-02;
netsum += inarray[3] * 5.021038E-02;
netsum += inarray[4] * -0.250028;
netsum += inarray[5] * -0.1672032;
feature2[2] = tanh(netsum);

netsum = 0.3363805;
netsum += inarray[0] * -0.2831887;
netsum += inarray[1] * 0.3622172;
netsum += inarray[2] * -0.2256913;
netsum += inarray[3] * 5.550051E-02;
netsum += inarray[4] * 0.2873718;
netsum += inarray[5] * 3.816301E-02;
feature2[3] = tanh(netsum);

netsum = -2.160532E-02;
netsum += inarray[0] * -0.4100401;
netsum += inarray[1] * -7.421961E-02;
netsum += inarray[2] * -0.328274;
netsum += inarray[3] * -0.1055911;
netsum += inarray[4] * 0.1705517;
netsum += inarray[5] * 7.307258E-02;
feature2[4] = tanh(netsum);

netsum = -5.573411E-02;
netsum += inarray[0] * -0.0960659;
netsum += inarray[1] * -0.1060757;
netsum += inarray[2] * 0.2156522;
netsum += inarray[3] * 0.1019971;
netsum += inarray[4] * -0.1891453;
netsum += inarray[5] * 0.1612145;
feature2[5] = tanh(netsum);

netsum = -0.1648754;
netsum += inarray[0] * 2.193118E-03;
netsum += inarray[1] * -0.1655917;
netsum += inarray[2] * -0.1006079;
netsum += inarray[3] * -0.3440722;
netsum += inarray[4] * 9.074235E-03;
netsum += inarray[5] * 0.1608877;
feature2[6] = tanh(netsum);

netsum = 0.342895;
netsum += inarray[0] * 0.1490434;
netsum += inarray[1] * -0.1410198;
netsum += inarray[2] * -0.148702;
netsum += inarray[3] * -0.0865499;
netsum += inarray[4] * -0.2415393;
netsum += inarray[5] * 8.43027E-03;
feature2[7] = tanh(netsum);

netsum = 0.306773;
netsum += inarray[0] * 0.151608;
netsum += inarray[1] * 0.2366542;
netsum += inarray[2] * 7.786464E-02;
netsum += inarray[3] * 5.625922E-03;
netsum += inarray[4] * 0.3105497;
netsum += inarray[5] * -0.2010628;
feature2[8] = tanh(netsum);

netsum = 0.2204882;
netsum += inarray[0] * 0.1158106;
netsum += inarray[1] * -0.2306288;
netsum += inarray[2] * 0.1542973;
netsum += inarray[3] * 0.1005394;
netsum += inarray[4] * 0.1742104;
netsum += inarray[5] * -5.802542E-02;
feature2[9] = tanh(netsum);

netsum = -0.2685743;
netsum += inarray[0] * -0.2858814;
netsum += inarray[1] * 0.1858915;
netsum += inarray[2] * 0.1226448;
netsum += inarray[3] * 0.1058582;
netsum += inarray[4] * -0.2576672;
netsum += inarray[5] * 0.2145471;
feature2[10] = tanh(netsum);

netsum = 0.320673;
netsum += inarray[0] * -3.547779E-02;
netsum += inarray[1] * 0.438327;
netsum += inarray[2] * 9.402534E-02;
netsum += inarray[3] * 0.4531832;
netsum += inarray[4] * 0.1289702;
netsum += inarray[5] * -0.2944696;
feature2[11] = tanh(netsum);

netsum = 0.2339243;
netsum += inarray[0] * -4.325217E-02;
netsum += inarray[1] * 0.3930894;
netsum += inarray[2] * 0.0136762;
netsum += inarray[3] * 0.1742827;
netsum += inarray[4] * 0.2015024;
netsum += inarray[5] * 2.162764E-03;
feature2[12] = tanh(netsum);

netsum = 2.405466E-02;
netsum += inarray[0] * -0.1051072;
netsum += inarray[1] * 0.3324034;
netsum += inarray[2] * -0.1699638;
netsum += inarray[3] * -0.1037684;
netsum += inarray[4] * 5.337318E-02;
netsum += inarray[5] * 9.434217E-02;
feature2[13] = tanh(netsum);

netsum = -0.2604659;
netsum += inarray[0] * -0.43428;
netsum += inarray[1] * 2.584165E-02;
netsum += inarray[2] * 8.083263E-02;
netsum += inarray[3] * -0.1857327;
netsum += inarray[4] * -0.3252396;
netsum += inarray[5] * -0.130793;
feature2[14] = tanh(netsum);

netsum = -0.4345424;
netsum += inarray[0] * 6.826349E-02;
netsum += inarray[1] * -0.2653868;
netsum += inarray[2] * -3.200014E-02;
netsum += inarray[3] * -6.479347E-02;
netsum += inarray[4] * -0.1548613;
netsum += inarray[5] * -0.1863147;
feature2[15] = tanh(netsum);

netsum = -0.5857556;
netsum += inarray[0] * 0.1851492;
netsum += inarray[1] * 0.1823652;
netsum += inarray[2] * -8.574051E-02;
netsum += inarray[3] * 0.2626222;
netsum += inarray[4] * 6.054239E-02;
netsum += inarray[5] * 0.2421584;
feature2[16] = tanh(netsum);

netsum = -0.1556447;
netsum += inarray[0] * 0.1646325;
netsum += inarray[1] * -0.1741415;
netsum += inarray[2] * 0.2690298;
netsum += inarray[3] * -0.2696115;
netsum += inarray[4] * 1.571842E-02;
netsum += inarray[5] * 0.2697242;
feature2[17] = tanh(netsum);

netsum = -0.4036206;
netsum += inarray[0] * -0.1385431;
netsum += inarray[1] * 0.1982414;
netsum += inarray[2] * 0.2154467;
netsum += inarray[3] * -7.501042E-02;
netsum += inarray[4] * -0.2226883;
netsum += inarray[5] * -3.897752E-03;
feature2[18] = tanh(netsum);

netsum = -0.3112086;
netsum += inarray[0] * -0.1781548;
netsum += inarray[1] * -0.3611548;
netsum += inarray[2] * -0.2976696;
netsum += inarray[3] * -4.531831E-02;
netsum += inarray[4] * 7.739821E-03;
netsum += inarray[5] * -0.1152863;
feature2[19] = tanh(netsum);

netsum = -0.2348593;
netsum += inarray[0] * -0.2597956;
netsum += inarray[1] * -0.2394565;
netsum += inarray[2] * -0.278019;
netsum += inarray[3] * 3.308985E-02;
netsum += inarray[4] * 0.1034006;
netsum += inarray[5] * -3.807853E-02;
feature3[0] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.2407284;
netsum += inarray[0] * -0.2817966;
netsum += inarray[1] * 0.1298067;
netsum += inarray[2] * 0.2300246;
netsum += inarray[3] * 0.1204871;
netsum += inarray[4] * 0.1224717;
netsum += inarray[5] * -5.720799E-02;
feature3[1] = 2 / (1 + exp(-netsum)) - 1;

netsum = 8.369624E-02;
netsum += inarray[0] * -0.2710567;
netsum += inarray[1] * 6.481063E-02;
netsum += inarray[2] * -0.1429489;
netsum += inarray[3] * 0.2892655;
netsum += inarray[4] * -0.3091733;
netsum += inarray[5] * -0.1407192;
feature3[2] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.1055238;
netsum += inarray[0] * 0.1983679;
netsum += inarray[1] * 3.945562E-02;
netsum += inarray[2] * -0.1496322;
netsum += inarray[3] * -0.199048;
netsum += inarray[4] * 0.1270755;
netsum += inarray[5] * -9.155186E-03;
feature3[3] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.2292788;
netsum += inarray[0] * 0.1924342;
netsum += inarray[1] * -0.3088873;
netsum += inarray[2] * 0.1871679;
netsum += inarray[3] * -0.3002376;
netsum += inarray[4] * 0.3290641;
netsum += inarray[5] * 0.0226404;
feature3[4] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.2181906;
netsum += inarray[0] * -0.1676172;
netsum += inarray[1] * 0.0061087;
netsum += inarray[2] * -0.0551839;
netsum += inarray[3] * 6.015796E-02;
netsum += inarray[4] * -0.1108723;
netsum += inarray[5] * -0.2130377;
feature3[5] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.2716743;
netsum += inarray[0] * -0.2800599;
netsum += inarray[1] * 0.24868;
netsum += inarray[2] * -0.1810915;
netsum += inarray[3] * 5.321803E-02;
netsum += inarray[4] * 4.486744E-02;
netsum += inarray[5] * -0.1161868;
feature3[6] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.2670316;
netsum += inarray[0] * 1.487489E-03;
netsum += inarray[1] * 9.330463E-02;
netsum += inarray[2] * 8.187877E-02;
netsum += inarray[3] * 5.346401E-03;
netsum += inarray[4] * -0.1156523;
netsum += inarray[5] * 0.1385247;
feature3[7] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.1721932;
netsum += inarray[0] * -0.2825025;
netsum += inarray[1] * 0.3335162;
netsum += inarray[2] * 4.236826E-02;
netsum += inarray[3] * 1.923683E-03;
netsum += inarray[4] * -0.2229338;
netsum += inarray[5] * -0.1226291;
feature3[8] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.1380777;
netsum += inarray[0] * -0.2567934;
netsum += inarray[1] * -0.1853925;
netsum += inarray[2] * -3.733407E-02;
netsum += inarray[3] * -5.133263E-03;
netsum += inarray[4] * -0.2461113;
netsum += inarray[5] * 0.1905786;
feature3[9] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.2955058;
netsum += inarray[0] * 4.58305E-03;
netsum += inarray[1] * -9.679097E-02;
netsum += inarray[2] * -1.415107E-02;
netsum += inarray[3] * -0.2271831;
netsum += inarray[4] * 0.2354882;
netsum += inarray[5] * 0.291972;
feature3[10] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.1402185;
netsum += inarray[0] * 0.1429821;
netsum += inarray[1] * -0.2559602;
netsum += inarray[2] * 7.918394E-02;
netsum += inarray[3] * 6.991084E-02;
netsum += inarray[4] * 0.2439977;
netsum += inarray[5] * 0.2410081;
feature3[11] = 2 / (1 + exp(-netsum)) - 1;

netsum = -9.509894E-02;
netsum += inarray[0] * 0.1119335;
netsum += inarray[1] * 0.3217488;
netsum += inarray[2] * 8.145297E-02;
netsum += inarray[3] * 8.750007E-02;
netsum += inarray[4] * 0.1384902;
netsum += inarray[5] * 0.1332305;
feature3[12] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.2499903;
netsum += inarray[0] * 9.861578E-04;
netsum += inarray[1] * -4.011399E-02;
netsum += inarray[2] * 0.2145995;
netsum += inarray[3] * 4.207919E-02;
netsum += inarray[4] * -0.2110389;
netsum += inarray[5] * -0.1245383;
feature3[13] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.1586927;
netsum += inarray[0] * -0.2579906;
netsum += inarray[1] * 0.3342768;
netsum += inarray[2] * 0.1997419;
netsum += inarray[3] * 0.1256936;
netsum += inarray[4] * -0.1055849;
netsum += inarray[5] * 0.2615083;
feature3[14] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.228072;
netsum += inarray[0] * -2.034981E-02;
netsum += inarray[1] * -0.1789378;
netsum += inarray[2] * 6.097388E-02;
netsum += inarray[3] * 0.2644427;
netsum += inarray[4] * -0.276148;
netsum += inarray[5] * -0.2272478;
feature3[15] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.1178381;
netsum += inarray[0] * -0.1825498;
netsum += inarray[1] * 6.161448E-02;
netsum += inarray[2] * 0.1390054;
netsum += inarray[3] * -0.2371638;
netsum += inarray[4] * -0.2466493;
netsum += inarray[5] * -0.2595389;
feature3[16] = 2 / (1 + exp(-netsum)) - 1;

netsum = 6.729404E-02;
netsum += inarray[0] * 0.1270876;
netsum += inarray[1] * -0.2672671;
netsum += inarray[2] * 4.879281E-02;
netsum += inarray[3] * 2.525634E-02;
netsum += inarray[4] * 0.101768;
netsum += inarray[5] * 0.18255;
feature3[17] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.1821879;
netsum += inarray[0] * -0.1093244;
netsum += inarray[1] * 9.96606E-03;
netsum += inarray[2] * -8.759008E-02;
netsum += inarray[3] * 0.2824378;
netsum += inarray[4] * 0.1753657;
netsum += inarray[5] * 6.610683E-03;
feature3[18] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.1469939;
netsum += inarray[0] * -3.985467E-02;
netsum += inarray[1] * 0.3048208;
netsum += inarray[2] * -0.1990215;
netsum += inarray[3] * 0.2831391;
netsum += inarray[4] * 4.519025E-03;
netsum += inarray[5] * 4.992901E-02;
feature3[19] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.2282642;
netsum += inarray[0] * 0.5284736;
netsum += inarray[1] * -7.977333E-02;
netsum += inarray[2] * 9.567546E-02;
netsum += inarray[3] * -5.443674E-02;
netsum += inarray[4] * -8.687496E-03;
netsum += inarray[5] * 9.644519E-02;
feature4[0] = tanh(1.5 * netsum);

netsum = -0.1253987;
netsum += inarray[0] * 0.1137712;
netsum += inarray[1] * -0.2454371;
netsum += inarray[2] * -0.1077928;
netsum += inarray[3] * -0.2310765;
netsum += inarray[4] * 0.2452515;
netsum += inarray[5] * -0.1547431;
feature4[1] = tanh(1.5 * netsum);

netsum = -0.4489899;
netsum += inarray[0] * -0.4716282;
netsum += inarray[1] * -0.1136563;
netsum += inarray[2] * -0.1041974;
netsum += inarray[3] * -4.704503E-02;
netsum += inarray[4] * -3.721086E-02;
netsum += inarray[5] * -0.2639102;
feature4[2] = tanh(1.5 * netsum);

netsum = 1.25511;
netsum += inarray[0] * -0.4161488;
netsum += inarray[1] * -0.3315701;
netsum += inarray[2] * 4.731025E-02;
netsum += inarray[3] * -1.157785;
netsum += inarray[4] * 4.687717E-03;
netsum += inarray[5] * -0.337789;
feature4[3] = tanh(1.5 * netsum);

netsum = -0.3566121;
netsum += inarray[0] * -0.3836306;
netsum += inarray[1] * 0.3212332;
netsum += inarray[2] * 0.2031169;
netsum += inarray[3] * -0.3207067;
netsum += inarray[4] * -8.382798E-02;
netsum += inarray[5] * -0.2918189;
feature4[4] = tanh(1.5 * netsum);

netsum = 6.049855E-02;
netsum += inarray[0] * 0.1427704;
netsum += inarray[1] * 0.4457843;
netsum += inarray[2] * -0.3189017;
netsum += inarray[3] * 0.1595984;
netsum += inarray[4] * -0.4495163;
netsum += inarray[5] * -2.593426E-02;
feature4[5] = tanh(1.5 * netsum);

netsum = 0.8205107;
netsum += inarray[0] * -0.4822665;
netsum += inarray[1] * -0.4324903;
netsum += inarray[2] * 0.1939064;
netsum += inarray[3] * -0.2104855;
netsum += inarray[4] * 1.925078E-02;
netsum += inarray[5] * -0.3728488;
feature4[6] = tanh(1.5 * netsum);

netsum = -0.2432685;
netsum += inarray[0] * 0.4697219;
netsum += inarray[1] * 0.1823093;
netsum += inarray[2] * 0.2188274;
netsum += inarray[3] * -0.3858987;
netsum += inarray[4] * 0.6709369;
netsum += inarray[5] * -8.435769E-02;
feature4[7] = tanh(1.5 * netsum);

netsum = -0.2315233;
netsum += inarray[0] * 0.1097716;
netsum += inarray[1] * 0.4275585;
netsum += inarray[2] * 0.5375271;
netsum += inarray[3] * -0.6606393;
netsum += inarray[4] * 0.1180967;
netsum += inarray[5] * -0.187685;
feature4[8] = tanh(1.5 * netsum);

netsum = 2.840171E-02;
netsum += inarray[0] * 0.1193261;
netsum += inarray[1] * 0.2598758;
netsum += inarray[2] * 4.897643E-02;
netsum += inarray[3] * 6.582124E-02;
netsum += inarray[4] * -0.2405539;
netsum += inarray[5] * -0.1993214;
feature4[9] = tanh(1.5 * netsum);

netsum = -0.8225031;
netsum += inarray[0] * -7.822055E-03;
netsum += inarray[1] * 0.1611831;
netsum += inarray[2] * 7.884776E-02;
netsum += inarray[3] * 0.6285043;
netsum += inarray[4] * -0.1056218;
netsum += inarray[5] * 0.2750491;
feature4[10] = tanh(1.5 * netsum);

netsum = 0.3682081;
netsum += inarray[0] * 0.2346618;
netsum += inarray[1] * -6.982484E-02;
netsum += inarray[2] * 8.368348E-02;
netsum += inarray[3] * -0.4031249;
netsum += inarray[4] * 2.260515E-02;
netsum += inarray[5] * 0.1055076;
feature4[11] = tanh(1.5 * netsum);

netsum = -6.975695E-02;
netsum += inarray[0] * -0.3490559;
netsum += inarray[1] * -6.925845E-02;
netsum += inarray[2] * -0.1194051;
netsum += inarray[3] * -0.2499773;
netsum += inarray[4] * 0.106336;
netsum += inarray[5] * 0.1199819;
feature4[12] = tanh(1.5 * netsum);

netsum = 0.8151858;
netsum += inarray[0] * -0.5589004;
netsum += inarray[1] * -0.7531719;
netsum += inarray[2] * 0.4804894;
netsum += inarray[3] * -0.5892838;
netsum += inarray[4] * 0.2176886;
netsum += inarray[5] * 0.1927742;
feature4[13] = tanh(1.5 * netsum);

netsum = 0.5827413;
netsum += inarray[0] * 0.5556902;
netsum += inarray[1] * -0.4261251;
netsum += inarray[2] * -0.1287149;
netsum += inarray[3] * -4.479981E-02;
netsum += inarray[4] * -0.0983393;
netsum += inarray[5] * 0.0214004;
feature4[14] = tanh(1.5 * netsum);

netsum = 7.877731E-02;
netsum += inarray[0] * 0.2300079;
netsum += inarray[1] * 5.154325E-02;
netsum += inarray[2] * 0.2049974;
netsum += inarray[3] * 0.4791473;
netsum += inarray[4] * 0.4444318;
netsum += inarray[5] * 0.4249846;
feature4[15] = tanh(1.5 * netsum);

netsum = -6.602202E-02;
netsum += inarray[0] * 0.3866641;
netsum += inarray[1] * -0.9293387;
netsum += inarray[2] * -0.1094037;
netsum += inarray[3] * 5.373635E-03;
netsum += inarray[4] * -0.3493333;
netsum += inarray[5] * -0.4198917;
feature4[16] = tanh(1.5 * netsum);

netsum = -0.4910995;
netsum += inarray[0] * -0.8842441;
netsum += inarray[1] * 0.2380228;
netsum += inarray[2] * -0.4027413;
netsum += inarray[3] * -1.415392;
netsum += inarray[4] * 0.5240588;
netsum += inarray[5] * -0.3747137;
feature4[17] = tanh(1.5 * netsum);

netsum = -0.7458497;
netsum += inarray[0] * -0.2084498;
netsum += inarray[1] * 0.1568527;
netsum += inarray[2] * 4.632528E-02;
netsum += inarray[3] * 0.5689726;
netsum += inarray[4] * -7.791334E-02;
netsum += inarray[5] * 0.3216428;
feature4[18] = tanh(1.5 * netsum);

netsum = -0.6210099;
netsum += inarray[0] * -0.1552907;
netsum += inarray[1] * 9.601706E-02;
netsum += inarray[2] * 8.839942E-02;
netsum += inarray[3] * 0.4519915;
netsum += inarray[4] * -0.1298171;
netsum += inarray[5] * 0.1221648;
feature4[19] = tanh(1.5 * netsum);

netsum = 0.1368681;
netsum += feature2[0] * 0.1815961;
netsum += feature2[1] * 0.1362976;
netsum += feature2[2] * -1.606058E-03;
netsum += feature2[3] * 0.1642599;
netsum += feature2[4] * -0.1551079;
netsum += feature2[5] * 4.455543E-02;
netsum += feature2[6] * -0.178803;
netsum += feature2[7] * 6.088285E-02;
netsum += feature2[8] * 5.595157E-02;
netsum += feature2[9] * -0.0914904;
netsum += feature2[10] * 7.351058E-02;
netsum += feature2[11] * 0.3329143;
netsum += feature2[12] * 0.1560892;
netsum += feature2[13] * 7.440352E-02;
netsum += feature2[14] * 0.1837583;
netsum += feature2[15] * -0.1867271;
netsum += feature2[16] * 0.1868529;
netsum += feature2[17] * -0.1288127;
netsum += feature2[18] * -0.1185778;
netsum += feature2[19] * -0.1580197;
netsum += 0.4275001;
netsum += feature3[0] * -0.2537531;
netsum += feature3[1] * 0.202335;
netsum += feature3[2] * 0.2061212;
netsum += feature3[3] * -0.110606;
netsum += feature3[4] * -0.3750603;
netsum += feature3[5] * 5.052782E-02;
netsum += feature3[6] * -6.696545E-02;
netsum += feature3[7] * -7.419179E-02;
netsum += feature3[8] * 0.277596;
netsum += feature3[9] * -1.577031E-02;
netsum += feature3[10] * -4.806834E-02;
netsum += feature3[11] * -0.2465455;
netsum += feature3[12] * 7.848518E-02;
netsum += feature3[13] * -4.368689E-02;
netsum += feature3[14] * 0.1124606;
netsum += feature3[15] * 0.1961945;
netsum += feature3[16] * -1.150282E-02;
netsum += feature3[17] * -0.1186455;
netsum += feature3[18] * 0.150471;
netsum += feature3[19] * 0.1675797;
netsum += -0.1275269;
netsum += feature4[0] * 0.0576039;
netsum += feature4[1] * -5.081539E-02;
netsum += feature4[2] * 0.1448577;
netsum += feature4[3] * -0.8127456;
netsum += feature4[4] * -0.1041551;
netsum += feature4[5] * 0.2147869;
netsum += feature4[6] * -0.3941466;
netsum += feature4[7] * -0.3129296;
netsum += feature4[8] * -0.337931;
netsum += feature4[9] * 0.1138555;
netsum += feature4[10] * 0.2753298;
netsum += feature4[11] * -3.133287E-02;
netsum += feature4[12] * -3.722423E-02;
netsum += feature4[13] * -0.6637312;
netsum += feature4[14] * 0.4088827;
netsum += feature4[15] * -0.3658173;
netsum += feature4[16] * -0.501023;
netsum += feature4[17] * -0.8510846;
netsum += feature4[18] * 0.1827391;
netsum += feature4[19] * 0.1130523;
outarray[0] = 1 / (1 + exp(-netsum));


outarray[0] = 0.25 *  (outarray[0] - .1) / .8 ;
if (outarray[0]<0) outarray[0] = 0;
if (outarray[0]>0.25) outarray[0] = 0.25;

} /* end cumminsNOX() */

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
/** nlhs is the number of left-hand-side arguments
    plhs are the left-hand-side arguments
    nrhs is the number of right-hand-side arguments
    prhs are the right-hand-side arguments **/
    
  double *inarray, *outarray;
  int mrows, ncols, i, currIndex;
  double tmp=0.0;
  
  /* Check for proper number of arguments. */
  if(nrhs != 1) {
    mexErrMsgTxt("One input required.");
  } else if(nlhs > 1) {
    mexErrMsgTxt("Too many output arguments");
  }
  
  /* The input must be a noncomplex scalar double.*/
  mrows = mxGetM(prhs[0]);
  ncols = mxGetN(prhs[0]);
  if(!mxIsDouble(prhs[0]) || mxIsComplex(prhs[0]) || mrows!=6)
  {
    mexErrMsgTxt("Input must be a noncomplex double matrix of size 6xN.");
  }
  /* Create matrix for the return argument. */
  plhs[0] = mxCreateDoubleMatrix(1, ncols, mxREAL); /* one row by n-cols */

  /* Assign pointers to the data storage area of the real-double part of the mxArray each input and output. */
  inarray = mxGetPr(prhs[0]);
  outarray= mxGetPr(plhs[0]);
  
  for(i=0; i<ncols; i++)
  {
    currIndex=i*6; /* gives the index to the next column of 6 in inarray*/
    /* increment the pointer by 6 places--matrix stored as an array by columns 
                   (i.e., 0(c1,r1),1(c1,r2)...5(c1,r6),6(c2,r1), etc. */
    /* Call the navistarNOx function. */
    navistarNOx(&inarray[currIndex],&tmp);
    outarray[i]=tmp; /* assign to outarray */
  }
} /* end mexFunction() */

/* 
to test:
out=navistarNOx([[60:70];diff([60:71]);diff([60:71]);[60:70];diff([60:71]);diff([60:71])]) 
*/