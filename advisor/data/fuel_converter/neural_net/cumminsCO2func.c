#ifndef cumminsCO2func_c
#define cumminsCO2func_c
/* Insert this code into your C program to fire the 
   C:\NeuroShell 2\CmnsAllPos 04-04-02 network */
/* This code is designed to be simple and fast for porting to any machine */
/* Therefore all code and weights are inline without looping or data storage */
/*   which might be harder to port between compilers. */

/* 
% Neural Network Mex file for Use with ADVISOR: cumminsCO2func.c
%
% Data source: Testing by West Virginia University
%
% Data confidence level:  no comparison has been performed
%
% Notes:  Neural Network predicts CO2 emissions of Cummins CI Engine
% Cummins ISM 370 CI Engine (model year 1999) 6 cylinder, 10.8 L, 370 HP, 
% peak torque 995 Nm@1200 rpm, governed speed of 2100 rpm
%
% Integrated into Advisor on:  05 April 2002
% Integrated into Advisor by:  Michael O'Keefe, National Renewable Energy 
%                               Laboratory, Michael_OKeefe@nrel.gov
% Original file provided by: West Virginia University
%
% Revision history at end of file.
*/

#include "wvuNN.h"

void cumminsCO2func(double *inarray, double *outarray)
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
/* outarray[0] is CO2 in g/s */

inarray[0] =  2 * (inarray[0] - 367.0703) / 1794.497 -1;

inarray[1] =  2 * (inarray[1] + 182.4661) / 341.5552 -1;

inarray[2] =  2 * (inarray[2] + 95.71754) / 213.7816 -1;

inarray[3] =  2 * (inarray[3] + 226.2746) / 1998.555 -1;

inarray[4] =  2 * (inarray[4] + 362.0183) / 715.5645 -1;

inarray[5] =  2 * (inarray[5] + 179.5587) / 349.8234 -1;

netsum = -0.3441134;
netsum += inarray[0] * 0.2907433;
netsum += inarray[1] * 0.2256435;
netsum += inarray[2] * -7.103509E-02;
netsum += inarray[3] * 6.177969E-02;
netsum += inarray[4] * -0.2215415;
netsum += inarray[5] * 0.1267472;
feature2[0] = tanh(netsum);

netsum = 1.382318E-03;
netsum += inarray[0] * -4.750554E-02;
netsum += inarray[1] * 0.1521284;
netsum += inarray[2] * -0.2942708;
netsum += inarray[3] * 0.1512263;
netsum += inarray[4] * 0.2949263;
netsum += inarray[5] * -8.029804E-02;
feature2[1] = tanh(netsum);

netsum = -0.2555748;
netsum += inarray[0] * -0.258638;
netsum += inarray[1] * 0.2499332;
netsum += inarray[2] * 0.1223314;
netsum += inarray[3] * 0.1054707;
netsum += inarray[4] * -0.2254859;
netsum += inarray[5] * -0.1407429;
feature2[2] = tanh(netsum);

netsum = 0.2146563;
netsum += inarray[0] * -0.306564;
netsum += inarray[1] * 0.2511523;
netsum += inarray[2] * -0.2645392;
netsum += inarray[3] * 7.850808E-02;
netsum += inarray[4] * 0.2420985;
netsum += inarray[5] * 4.821919E-02;
feature2[3] = tanh(netsum);

netsum = 7.152038E-02;
netsum += inarray[0] * -0.373009;
netsum += inarray[1] * -1.088172E-02;
netsum += inarray[2] * -0.3119715;
netsum += inarray[3] * -7.221655E-02;
netsum += inarray[4] * 0.1091694;
netsum += inarray[5] * 0.106743;
feature2[4] = tanh(netsum);

netsum = -3.542388E-02;
netsum += inarray[0] * -4.856825E-02;
netsum += inarray[1] * -0.1846676;
netsum += inarray[2] * 0.2240981;
netsum += inarray[3] * 0.1096107;
netsum += inarray[4] * -9.735986E-02;
netsum += inarray[5] * 0.129114;
feature2[5] = tanh(netsum);

netsum = -0.171857;
netsum += inarray[0] * 6.497087E-02;
netsum += inarray[1] * -3.689729E-02;
netsum += inarray[2] * -7.508546E-02;
netsum += inarray[3] * -0.3729622;
netsum += inarray[4] * -6.983477E-02;
netsum += inarray[5] * 0.150755;
feature2[6] = tanh(netsum);

netsum = 0.3028834;
netsum += inarray[0] * 7.665677E-02;
netsum += inarray[1] * -0.1460136;
netsum += inarray[2] * -0.1488826;
netsum += inarray[3] * -0.1321313;
netsum += inarray[4] * -0.242482;
netsum += inarray[5] * -6.941597E-03;
feature2[7] = tanh(netsum);

netsum = 0.2551994;
netsum += inarray[0] * 8.313546E-02;
netsum += inarray[1] * 0.2260086;
netsum += inarray[2] * 3.998795E-02;
netsum += inarray[3] * -3.297444E-02;
netsum += inarray[4] * 0.2775547;
netsum += inarray[5] * -0.2258677;
feature2[8] = tanh(netsum);

netsum = 0.2188482;
netsum += inarray[0] * 0.1019478;
netsum += inarray[1] * -0.1923934;
netsum += inarray[2] * 0.138097;
netsum += inarray[3] * 7.529514E-02;
netsum += inarray[4] * 0.1027968;
netsum += inarray[5] * -7.333524E-02;
feature2[9] = tanh(netsum);

netsum = -0.2629168;
netsum += inarray[0] * -0.2101083;
netsum += inarray[1] * 0.199474;
netsum += inarray[2] * 0.1882215;
netsum += inarray[3] * 5.969147E-02;
netsum += inarray[4] * -0.2151434;
netsum += inarray[5] * 0.1661034;
feature2[10] = tanh(netsum);

netsum = 0.3056099;
netsum += inarray[0] * -6.226782E-02;
netsum += inarray[1] * 0.1530275;
netsum += inarray[2] * 1.941439E-02;
netsum += inarray[3] * 0.5459083;
netsum += inarray[4] * 0.2242866;
netsum += inarray[5] * -0.2594149;
feature2[11] = tanh(netsum);

netsum = 0.1678389;
netsum += inarray[0] * -3.755192E-02;
netsum += inarray[1] * 0.298493;
netsum += inarray[2] * -1.288373E-02;
netsum += inarray[3] * 0.1733883;
netsum += inarray[4] * 0.1918577;
netsum += inarray[5] * 6.108342E-03;
feature2[12] = tanh(netsum);

netsum = 2.006138E-02;
netsum += inarray[0] * -9.601006E-02;
netsum += inarray[1] * 0.3009723;
netsum += inarray[2] * -0.1728706;
netsum += inarray[3] * -0.114541;
netsum += inarray[4] * 5.044192E-02;
netsum += inarray[5] * 0.1072973;
feature2[13] = tanh(netsum);

netsum = -0.234391;
netsum += inarray[0] * -0.3322508;
netsum += inarray[1] * 9.124353E-02;
netsum += inarray[2] * 0.1393344;
netsum += inarray[3] * -0.1081816;
netsum += inarray[4] * -0.1735888;
netsum += inarray[5] * -5.654685E-02;
feature2[14] = tanh(netsum);

netsum = -0.4027977;
netsum += inarray[0] * 6.542747E-02;
netsum += inarray[1] * -6.018502E-02;
netsum += inarray[2] * 2.115917E-02;
netsum += inarray[3] * -0.1999163;
netsum += inarray[4] * -0.1888032;
netsum += inarray[5] * -0.2009782;
feature2[15] = tanh(netsum);

netsum = -0.4284033;
netsum += inarray[0] * 0.2879529;
netsum += inarray[1] * -0.1681893;
netsum += inarray[2] * -6.968449E-02;
netsum += inarray[3] * 0.1722745;
netsum += inarray[4] * 0.3341041;
netsum += inarray[5] * 0.2166271;
feature2[16] = tanh(netsum);

netsum = -0.1108925;
netsum += inarray[0] * 0.193228;
netsum += inarray[1] * -0.1306158;
netsum += inarray[2] * 0.2957966;
netsum += inarray[3] * -0.3613937;
netsum += inarray[4] * -2.044912E-02;
netsum += inarray[5] * 0.2744284;
feature2[17] = tanh(netsum);

netsum = -0.256338;
netsum += inarray[0] * 1.169515E-02;
netsum += inarray[1] * 0.1571071;
netsum += inarray[2] * 0.1881683;
netsum += inarray[3] * -0.1053269;
netsum += inarray[4] * -0.2235015;
netsum += inarray[5] * 2.696071E-02;
feature2[18] = tanh(netsum);

netsum = -0.2664514;
netsum += inarray[0] * -0.1384405;
netsum += inarray[1] * -0.2960634;
netsum += inarray[2] * -0.2404057;
netsum += inarray[3] * 7.389635E-03;
netsum += inarray[4] * -2.11178E-04;
netsum += inarray[5] * -0.1005962;
feature2[19] = tanh(netsum);

netsum = -0.2010173;
netsum += inarray[0] * -0.2340439;
netsum += inarray[1] * -0.1852167;
netsum += inarray[2] * -0.2555826;
netsum += inarray[3] * 5.619223E-02;
netsum += inarray[4] * 5.659951E-02;
netsum += inarray[5] * -2.451383E-02;
feature3[0] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.2060945;
netsum += inarray[0] * -0.3082281;
netsum += inarray[1] * 6.170712E-02;
netsum += inarray[2] * 0.2186634;
netsum += inarray[3] * 0.131984;
netsum += inarray[4] * 0.1474279;
netsum += inarray[5] * -0.063435;
feature3[1] = 2 / (1 + exp(-netsum)) - 1;

netsum = 7.780497E-02;
netsum += inarray[0] * -0.2702673;
netsum += inarray[1] * 3.019985E-02;
netsum += inarray[2] * -0.1397319;
netsum += inarray[3] * 0.2989781;
netsum += inarray[4] * -0.2685443;
netsum += inarray[5] * -0.1337648;
feature3[2] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.104746;
netsum += inarray[0] * 0.1871731;
netsum += inarray[1] * 6.813129E-02;
netsum += inarray[2] * -0.1532906;
netsum += inarray[3] * -0.199911;
netsum += inarray[4] * 9.599268E-02;
netsum += inarray[5] * -7.663234E-03;
feature3[3] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.189761;
netsum += inarray[0] * 0.2298919;
netsum += inarray[1] * -0.2198683;
netsum += inarray[2] * 0.186812;
netsum += inarray[3] * -0.3108653;
netsum += inarray[4] * 0.2698027;
netsum += inarray[5] * 2.248411E-02;
feature3[4] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.2139807;
netsum += inarray[0] * -0.1755921;
netsum += inarray[1] * 2.560183E-03;
netsum += inarray[2] * -5.528532E-02;
netsum += inarray[3] * 6.188207E-02;
netsum += inarray[4] * -0.1112633;
netsum += inarray[5] * -0.2104401;
feature3[5] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.2410172;
netsum += inarray[0] * -0.2395725;
netsum += inarray[1] * 0.263453;
netsum += inarray[2] * -0.1676557;
netsum += inarray[3] * 6.824829E-02;
netsum += inarray[4] * 0.0326151;
netsum += inarray[5] * -0.1034415;
feature3[6] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.2455843;
netsum += inarray[0] * 3.227446E-02;
netsum += inarray[1] * 0.1090152;
netsum += inarray[2] * 8.882427E-02;
netsum += inarray[3] * 6.794636E-03;
netsum += inarray[4] * -0.1219938;
netsum += inarray[5] * 0.1485994;
feature3[7] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.1341096;
netsum += inarray[0] * -0.2982984;
netsum += inarray[1] * 0.2687261;
netsum += inarray[2] * 4.584594E-02;
netsum += inarray[3] * 4.061948E-03;
netsum += inarray[4] * -0.1832506;
netsum += inarray[5] * -0.1215558;
feature3[8] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.1270689;
netsum += inarray[0] * -0.2355487;
netsum += inarray[1] * -0.1877024;
netsum += inarray[2] * -2.964312E-02;
netsum += inarray[3] * 2.742727E-03;
netsum += inarray[4] * -0.2349758;
netsum += inarray[5] * 0.1951346;
feature3[9] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.28091;
netsum += inarray[0] * -1.992209E-02;
netsum += inarray[1] * -9.467349E-02;
netsum += inarray[2] * -2.429487E-02;
netsum += inarray[3] * -0.233144;
netsum += inarray[4] * 0.2261917;
netsum += inarray[5] * 0.2810666;
feature3[10] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.1255025;
netsum += inarray[0] * 0.1515634;
netsum += inarray[1] * -0.2044944;
netsum += inarray[2] * 0.0747037;
netsum += inarray[3] * 7.021618E-02;
netsum += inarray[4] * 0.1990971;
netsum += inarray[5] * 0.237164;
feature3[11] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.1001617;
netsum += inarray[0] * 0.1106571;
netsum += inarray[1] * 0.3017463;
netsum += inarray[2] * 8.067329E-02;
netsum += inarray[3] * 8.038712E-02;
netsum += inarray[4] * 0.1488296;
netsum += inarray[5] * 0.1328117;
feature3[12] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.2295069;
netsum += inarray[0] * 2.588011E-02;
netsum += inarray[1] * -3.053844E-02;
netsum += inarray[2] * 0.2201547;
netsum += inarray[3] * 4.373558E-02;
netsum += inarray[4] * -0.211848;
netsum += inarray[5] * -0.1194453;
feature3[13] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.1448895;
netsum += inarray[0] * -0.2592409;
netsum += inarray[1] * 0.3021858;
netsum += inarray[2] * 0.1990845;
netsum += inarray[3] * 0.1216798;
netsum += inarray[4] * -0.1025474;
netsum += inarray[5] * 0.2669464;
feature3[14] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.2029894;
netsum += inarray[0] * -0.0498101;
netsum += inarray[1] * -0.228834;
netsum += inarray[2] * 5.362978E-02;
netsum += inarray[3] * 0.2683599;
netsum += inarray[4] * -0.2408897;
netsum += inarray[5] * -0.2371445;
feature3[15] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.1273905;
netsum += inarray[0] * -0.1762702;
netsum += inarray[1] * 7.100917E-02;
netsum += inarray[2] * 0.1397748;
netsum += inarray[3] * -0.2348923;
netsum += inarray[4] * -0.2604014;
netsum += inarray[5] * -0.2520626;
feature3[16] = 2 / (1 + exp(-netsum)) - 1;

netsum = 6.944583E-02;
netsum += inarray[0] * 0.1237871;
netsum += inarray[1] * -0.2476282;
netsum += inarray[2] * 4.435824E-02;
netsum += inarray[3] * 2.224407E-02;
netsum += inarray[4] * 8.227137E-02;
netsum += inarray[5] * 0.1770596;
feature3[17] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.1621777;
netsum += inarray[0] * -0.1368265;
netsum += inarray[1] * -2.590111E-02;
netsum += inarray[2] * -9.316215E-02;
netsum += inarray[3] * 0.295718;
netsum += inarray[4] * 0.2018152;
netsum += inarray[5] * 7.664989E-04;
feature3[18] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.1544882;
netsum += inarray[0] * -4.821004E-02;
netsum += inarray[1] * 0.2657301;
netsum += inarray[2] * -0.2009906;
netsum += inarray[3] * 0.274499;
netsum += inarray[4] * 3.030751E-02;
netsum += inarray[5] * 0.0490315;
feature3[19] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.7524988;
netsum += inarray[0] * 0.6247826;
netsum += inarray[1] * 0.2798979;
netsum += inarray[2] * -0.2453858;
netsum += inarray[3] * -0.9544203;
netsum += inarray[4] * 5.553026E-02;
netsum += inarray[5] * -0.1757878;
feature4[0] = tanh(1.5 * netsum);

netsum = -0.2705496;
netsum += inarray[0] * 5.441098E-02;
netsum += inarray[1] * -0.1309904;
netsum += inarray[2] * -0.1750219;
netsum += inarray[3] * -0.2574952;
netsum += inarray[4] * 0.1966892;
netsum += inarray[5] * -0.1741367;
feature4[1] = tanh(1.5 * netsum);

netsum = -0.4937502;
netsum += inarray[0] * -0.351835;
netsum += inarray[1] * 1.556795E-02;
netsum += inarray[2] * -0.095144;
netsum += inarray[3] * 1.885412E-02;
netsum += inarray[4] * 0.1862831;
netsum += inarray[5] * -0.2350359;
feature4[2] = tanh(1.5 * netsum);

netsum = 1.371843;
netsum += inarray[0] * -0.392179;
netsum += inarray[1] * -0.3626243;
netsum += inarray[2] * 8.720375E-02;
netsum += inarray[3] * -1.669207;
netsum += inarray[4] * 0.1945584;
netsum += inarray[5] * -7.037151E-02;
feature4[3] = tanh(1.5 * netsum);

netsum = -0.3623862;
netsum += inarray[0] * -0.2023738;
netsum += inarray[1] * 0.142297;
netsum += inarray[2] * 0.1853564;
netsum += inarray[3] * -0.2967115;
netsum += inarray[4] * -0.1562771;
netsum += inarray[5] * -0.2880793;
feature4[4] = tanh(1.5 * netsum);

netsum = 0.2196855;
netsum += inarray[0] * 0.2110243;
netsum += inarray[1] * 0.2527486;
netsum += inarray[2] * -0.238084;
netsum += inarray[3] * -0.079249;
netsum += inarray[4] * -0.1811851;
netsum += inarray[5] * -0.1092725;
feature4[5] = tanh(1.5 * netsum);

netsum = 0.186938;
netsum += inarray[0] * -0.7641163;
netsum += inarray[1] * -9.618236E-02;
netsum += inarray[2] * -0.2688493;
netsum += inarray[3] * 0.1640264;
netsum += inarray[4] * -7.096538E-02;
netsum += inarray[5] * -0.2794263;
feature4[6] = tanh(1.5 * netsum);

netsum = -0.9668288;
netsum += inarray[0] * 0.175552;
netsum += inarray[1] * -0.2471733;
netsum += inarray[2] * 6.828463E-02;
netsum += inarray[3] * -0.8308722;
netsum += inarray[4] * 0.1221458;
netsum += inarray[5] * -0.1425804;
feature4[7] = tanh(1.5 * netsum);

netsum = -0.279903;
netsum += inarray[0] * -2.858477E-02;
netsum += inarray[1] * 0.132071;
netsum += inarray[2] * 0.337673;
netsum += inarray[3] * -0.7042624;
netsum += inarray[4] * -8.166044E-02;
netsum += inarray[5] * 0.2154436;
feature4[8] = tanh(1.5 * netsum);

netsum = 0.1295311;
netsum += inarray[0] * 0.2905031;
netsum += inarray[1] * 0.2835713;
netsum += inarray[2] * 0.1082413;
netsum += inarray[3] * -0.1658835;
netsum += inarray[4] * -0.1144055;
netsum += inarray[5] * -0.2831427;
feature4[9] = tanh(1.5 * netsum);

netsum = -0.768702;
netsum += inarray[0] * 0.6037022;
netsum += inarray[1] * -0.8950499;
netsum += inarray[2] * 0.2924414;
netsum += inarray[3] * 0.0893655;
netsum += inarray[4] * -5.839034E-02;
netsum += inarray[5] * 2.738134E-02;
feature4[10] = tanh(1.5 * netsum);

netsum = -0.3030446;
netsum += inarray[0] * 3.132385E-02;
netsum += inarray[1] * 7.832463E-02;
netsum += inarray[2] * 0.2189116;
netsum += inarray[3] * -0.5318152;
netsum += inarray[4] * -0.1631674;
netsum += inarray[5] * 0.1426238;
feature4[11] = tanh(1.5 * netsum);

netsum = -0.1169539;
netsum += inarray[0] * -0.3710389;
netsum += inarray[1] * -4.918312E-02;
netsum += inarray[2] * -5.524662E-02;
netsum += inarray[3] * -0.2457435;
netsum += inarray[4] * 0.1444138;
netsum += inarray[5] * 0.1719565;
feature4[12] = tanh(1.5 * netsum);

netsum = 0.6628264;
netsum += inarray[0] * 9.882841E-03;
netsum += inarray[1] * -0.1330866;
netsum += inarray[2] * 0.385523;
netsum += inarray[3] * -0.1627708;
netsum += inarray[4] * 0.7636465;
netsum += inarray[5] * -0.1403823;
feature4[13] = tanh(1.5 * netsum);

netsum = 0.4289978;
netsum += inarray[0] * 0.1755374;
netsum += inarray[1] * -0.1615392;
netsum += inarray[2] * -0.1708584;
netsum += inarray[3] * -0.105559;
netsum += inarray[4] * -3.75492E-03;
netsum += inarray[5] * 3.217599E-02;
feature4[14] = tanh(1.5 * netsum);

netsum = 0.1917784;
netsum += inarray[0] * 0.1218656;
netsum += inarray[1] * 0.2319294;
netsum += inarray[2] * 0.2443408;
netsum += inarray[3] * 0.2261662;
netsum += inarray[4] * 0.2301848;
netsum += inarray[5] * 0.1097712;
feature4[15] = tanh(1.5 * netsum);

netsum = 0.401893;
netsum += inarray[0] * 6.152721E-03;
netsum += inarray[1] * -0.3211947;
netsum += inarray[2] * -0.3895228;
netsum += inarray[3] * -0.2619153;
netsum += inarray[4] * -0.9603428;
netsum += inarray[5] * -0.1432285;
feature4[16] = tanh(1.5 * netsum);

netsum = 0.1792855;
netsum += inarray[0] * -0.4179925;
netsum += inarray[1] * -7.669292E-02;
netsum += inarray[2] * -0.2804243;
netsum += inarray[3] * -8.752109E-02;
netsum += inarray[4] * 0.3183127;
netsum += inarray[5] * 0.111282;
feature4[17] = tanh(1.5 * netsum);

netsum = -0.1823847;
netsum += inarray[0] * -7.633696E-02;
netsum += inarray[1] * 9.058772E-02;
netsum += inarray[2] * 1.847163E-02;
netsum += inarray[3] * 0.2977449;
netsum += inarray[4] * 8.576021E-02;
netsum += inarray[5] * 0.1405115;
feature4[18] = tanh(1.5 * netsum);

netsum = -3.757422E-03;
netsum += inarray[0] * 0.4042617;
netsum += inarray[1] * 0.0867511;
netsum += inarray[2] * 0.5232506;
netsum += inarray[3] * 4.239594E-02;
netsum += inarray[4] * 0.616666;
netsum += inarray[5] * 0.2519459;
feature4[19] = tanh(1.5 * netsum);

netsum = -7.728279E-02;
netsum += feature2[0] * 7.711458E-03;
netsum += feature2[1] * 0.2119625;
netsum += feature2[2] * 4.286568E-02;
netsum += feature2[3] * 2.016094E-02;
netsum += feature2[4] * -9.220932E-02;
netsum += feature2[5] * 0.121682;
netsum += feature2[6] * -0.230925;
netsum += feature2[7] * -1.739419E-02;
netsum += feature2[8] * 1.485803E-02;
netsum += feature2[9] * -9.637692E-02;
netsum += feature2[10] * 0.1074117;
netsum += feature2[11] * 0.3642467;
netsum += feature2[12] * 0.0573971;
netsum += feature2[13] * -0.0190787;
netsum += feature2[14] * 0.1250826;
netsum += feature2[15] * -0.2063022;
netsum += feature2[16] * 0.2806755;
netsum += feature2[17] * -0.2141093;
netsum += feature2[18] * -0.1640971;
netsum += feature2[19] * 2.922093E-02;
netsum += 0.2133624;
netsum += feature3[0] * -0.1721089;
netsum += feature3[1] * 0.2286306;
netsum += feature3[2] * 0.1932863;
netsum += feature3[3] * -0.1387025;
netsum += feature3[4] * -0.3191563;
netsum += feature3[5] * 3.656181E-02;
netsum += feature3[6] * -5.317382E-02;
netsum += feature3[7] * -0.1081803;
netsum += feature3[8] * 0.219343;
netsum += feature3[9] * 7.139682E-03;
netsum += feature3[10] * -1.786116E-02;
netsum += feature3[11] * -0.1870323;
netsum += feature3[12] * 3.270073E-02;
netsum += feature3[13] * -0.0563769;
netsum += feature3[14] * 2.861029E-02;
netsum += feature3[15] * 0.2152622;
netsum += feature3[16] * -7.223941E-02;
netsum += feature3[17] * -8.293899E-02;
netsum += feature3[18] * 0.210478;
netsum += feature3[19] * 0.1399798;
netsum += -0.34168;
netsum += feature4[0] * 0.7294049;
netsum += feature4[1] * -4.260946E-02;
netsum += feature4[2] * 0.2254905;
netsum += feature4[3] * -0.6587332;
netsum += feature4[4] * 4.198842E-02;
netsum += feature4[5] * 8.723592E-02;
netsum += feature4[6] * -0.309541;
netsum += feature4[7] * -0.6617138;
netsum += feature4[8] * -0.430601;
netsum += feature4[9] * 0.1350379;
netsum += feature4[10] * 0.7555521;
netsum += feature4[11] * -0.2931517;
netsum += feature4[12] * 5.133306E-02;
netsum += feature4[13] * -0.5598298;
netsum += feature4[14] * -2.555993E-02;
netsum += feature4[15] * 4.548705E-02;
netsum += feature4[16] * -0.4266604;
netsum += feature4[17] * -0.1681924;
netsum += feature4[18] * -0.0391742;
netsum += feature4[19] * 0.3020794;
outarray[0] = 1 / (1 + exp(-netsum));


outarray[0] = 60 *  (outarray[0] - .1) / .8 ;
if (outarray[0]<0) outarray[0] = 0;
if (outarray[0]>60) outarray[0] = 60;
               
} /* end cumminsCO2func() */
#endif
