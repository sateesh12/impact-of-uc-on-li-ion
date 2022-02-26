/* Insert this code into your C program to fire the C:\NeuroShell 2\Nav Pos CO (04-05-02) network */
/* This code is designed to be simple and fast for porting to any machine */
/* Therefore all code and weights are inline without looping or data storage */
/*   which might be harder to port between compilers. */

/* 
% Neural Network Mex file for Use with ADVISOR: navistarCO.c
%
% Data source: Testing by West Virginia University
%
% Data confidence level:  no comparison has been performed
%
% Notes:  Neural Network predicts CO emissions of Navistar CI Engine
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

void navistarCO(double *inarray, double *outarray)
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
/* outarray[0] is CO in g/s */

if (inarray[0]<240.1239) inarray[0] = 240.1239;
if (inarray[0]>2713.334) inarray[0] = 2713.334;
inarray[0] =  2 * (inarray[0] - 240.1239) / 2473.21 -1;

if (inarray[1]<-171.4034) inarray[1] = -171.4034;
if (inarray[1]>225.1266) inarray[1] = 225.1266;
inarray[1] =  2 * (inarray[1] + 171.4034) / 396.5299 -1;

if (inarray[2]<-130.8206) inarray[2] = -130.8206;
if (inarray[2]>167.3204) inarray[2] = 167.3204;
inarray[2] =  2 * (inarray[2] + 130.8206) / 298.1411 -1;

if (inarray[3]<-292.7434) inarray[3] = -292.7434;
if (inarray[3]>781.8658) inarray[3] = 781.8658;
inarray[3] =  2 * (inarray[3] + 292.7434) / 1074.609 -1;

if (inarray[4]<-145.1079) inarray[4] = -145.1079;
if (inarray[4]>91.80727) inarray[4] = 91.80727;
inarray[4] =  2 * (inarray[4] + 145.1079) / 236.9152 -1;

if (inarray[5]<-68.89952) inarray[5] = -68.89952;
if (inarray[5]>65.36434) inarray[5] = 65.36434;
inarray[5] =  2 * (inarray[5] + 68.89952) / 134.2639 -1;

netsum = -0.4461369;
netsum += inarray[0] * 0.4218712;
netsum += inarray[1] * -0.1387182;
netsum += inarray[2] * -0.5017056;
netsum += inarray[3] * 0.2034791;
netsum += inarray[4] * -0.4037959;
netsum += inarray[5] * -1.358959E-02;
feature2[0] = tanh(netsum);

netsum = 0.1893815;
netsum += inarray[0] * 1.957669E-02;
netsum += inarray[1] * 0.3866812;
netsum += inarray[2] * -9.833736E-02;
netsum += inarray[3] * -1.285169E-02;
netsum += inarray[4] * 0.3182695;
netsum += inarray[5] * 1.116578E-03;
feature2[1] = tanh(netsum);

netsum = -0.3996852;
netsum += inarray[0] * -0.357557;
netsum += inarray[1] * 1.435666E-02;
netsum += inarray[2] * -0.2106894;
netsum += inarray[3] * 0.1084898;
netsum += inarray[4] * -0.4417502;
netsum += inarray[5] * -0.3294605;
feature2[2] = tanh(netsum);

netsum = 0.3404427;
netsum += inarray[0] * -0.2880446;
netsum += inarray[1] * 0.4277124;
netsum += inarray[2] * -0.1657829;
netsum += inarray[3] * 9.117562E-02;
netsum += inarray[4] * 0.3965608;
netsum += inarray[5] * 0.1205392;
feature2[3] = tanh(netsum);

netsum = 0.1004699;
netsum += inarray[0] * -0.1664602;
netsum += inarray[1] * -0.3351977;
netsum += inarray[2] * -0.5163834;
netsum += inarray[3] * 0.0952422;
netsum += inarray[4] * 0.1598589;
netsum += inarray[5] * 0.1110757;
feature2[4] = tanh(netsum);

netsum = -0.1857429;
netsum += inarray[0] * -0.216397;
netsum += inarray[1] * -7.303727E-02;
netsum += inarray[2] * 0.2625461;
netsum += inarray[3] * -0.1086167;
netsum += inarray[4] * -0.3763538;
netsum += inarray[5] * 3.951842E-02;
feature2[5] = tanh(netsum);

netsum = -0.2471107;
netsum += inarray[0] * 0.024133;
netsum += inarray[1] * -0.3708148;
netsum += inarray[2] * -0.3762727;
netsum += inarray[3] * -0.2453805;
netsum += inarray[4] * -0.1179934;
netsum += inarray[5] * 4.222766E-02;
feature2[6] = tanh(netsum);

netsum = 0.6040064;
netsum += inarray[0] * 0.1937728;
netsum += inarray[1] * 2.076301E-02;
netsum += inarray[2] * 1.584975E-03;
netsum += inarray[3] * -4.961717E-02;
netsum += inarray[4] * -0.2323001;
netsum += inarray[5] * 8.365719E-02;
feature2[7] = tanh(netsum);

netsum = 0.420331;
netsum += inarray[0] * 0.3231752;
netsum += inarray[1] * 0.6007081;
netsum += inarray[2] * 0.18778;
netsum += inarray[3] * 0.0470992;
netsum += inarray[4] * 0.6212413;
netsum += inarray[5] * -0.1683748;
feature2[8] = tanh(netsum);

netsum = 0.3188861;
netsum += inarray[0] * 8.494955E-02;
netsum += inarray[1] * -1.080846E-02;
netsum += inarray[2] * 0.3784838;
netsum += inarray[3] * 0.1501896;
netsum += inarray[4] * 0.3854102;
netsum += inarray[5] * 0.1226334;
feature2[9] = tanh(netsum);

netsum = -0.3774774;
netsum += inarray[0] * -1.856732;
netsum += inarray[1] * 0.8148706;
netsum += inarray[2] * 0.6468133;
netsum += inarray[3] * -0.1492399;
netsum += inarray[4] * -0.7470148;
netsum += inarray[5] * 0.2854629;
feature2[10] = tanh(netsum);

netsum = 0.4628607;
netsum += inarray[0] * 0.3588505;
netsum += inarray[1] * 0.602026;
netsum += inarray[2] * 0.2580545;
netsum += inarray[3] * 0.3469927;
netsum += inarray[4] * 0.6026782;
netsum += inarray[5] * -0.2957882;
feature2[11] = tanh(netsum);

netsum = 0.217305;
netsum += inarray[0] * -4.454474E-02;
netsum += inarray[1] * 0.5781991;
netsum += inarray[2] * 0.207199;
netsum += inarray[3] * 0.1713531;
netsum += inarray[4] * 0.3408048;
netsum += inarray[5] * 0.1177871;
feature2[12] = tanh(netsum);

netsum = 6.535886E-02;
netsum += inarray[0] * -0.1200504;
netsum += inarray[1] * 0.402477;
netsum += inarray[2] * -0.232978;
netsum += inarray[3] * -8.485774E-02;
netsum += inarray[4] * 0.0156456;
netsum += inarray[5] * 3.492708E-02;
feature2[13] = tanh(netsum);

netsum = -0.3638115;
netsum += inarray[0] * -0.4963779;
netsum += inarray[1] * 8.625574E-02;
netsum += inarray[2] * 2.525349E-02;
netsum += inarray[3] * -0.2128968;
netsum += inarray[4] * -0.5407772;
netsum += inarray[5] * -0.2776141;
feature2[14] = tanh(netsum);

netsum = -0.4986616;
netsum += inarray[0] * -0.1830743;
netsum += inarray[1] * -0.3712161;
netsum += inarray[2] * -0.2685711;
netsum += inarray[3] * 5.831126E-02;
netsum += inarray[4] * -0.3674958;
netsum += inarray[5] * -0.3391505;
feature2[15] = tanh(netsum);

netsum = -0.4418214;
netsum += inarray[0] * -9.054033E-03;
netsum += inarray[1] * 0.1911192;
netsum += inarray[2] * 0.2549299;
netsum += inarray[3] * -6.592191E-02;
netsum += inarray[4] * 0.2432261;
netsum += inarray[5] * 0.3871483;
feature2[16] = tanh(netsum);

netsum = -4.645641E-02;
netsum += inarray[0] * -7.539689E-02;
netsum += inarray[1] * 0.2094896;
netsum += inarray[2] * 0.4877823;
netsum += inarray[3] * -0.3432269;
netsum += inarray[4] * 0.1155943;
netsum += inarray[5] * 0.3388237;
feature2[17] = tanh(netsum);

netsum = -0.4317767;
netsum += inarray[0] * -6.688371E-02;
netsum += inarray[1] * -0.1431121;
netsum += inarray[2] * -0.222849;
netsum += inarray[3] * 6.918651E-02;
netsum += inarray[4] * -0.3598996;
netsum += inarray[5] * -0.1691781;
feature2[18] = tanh(netsum);

netsum = -0.1990977;
netsum += inarray[0] * 5.617051E-02;
netsum += inarray[1] * -0.5613405;
netsum += inarray[2] * -0.4677532;
netsum += inarray[3] * 4.922319E-02;
netsum += inarray[4] * -7.875078E-02;
netsum += inarray[5] * -0.2031176;
feature2[19] = tanh(netsum);

netsum = -0.3343145;
netsum += inarray[0] * -0.2407724;
netsum += inarray[1] * -0.3427542;
netsum += inarray[2] * -0.3310584;
netsum += inarray[3] * 9.600373E-02;
netsum += inarray[4] * 9.855387E-02;
netsum += inarray[5] * -0.0395299;
feature3[0] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.2875;
netsum += inarray[0] * -0.2992358;
netsum += inarray[1] * 0.18395;
netsum += inarray[2] * 0.2430758;
netsum += inarray[3] * 5.768489E-02;
netsum += inarray[4] * 7.512689E-02;
netsum += inarray[5] * -9.846749E-02;
feature3[1] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.1135023;
netsum += inarray[0] * -0.2138781;
netsum += inarray[1] * -0.0934316;
netsum += inarray[2] * -0.2943649;
netsum += inarray[3] * 0.302875;
netsum += inarray[4] * -0.3924623;
netsum += inarray[5] * -0.2012383;
feature3[2] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.1313786;
netsum += inarray[0] * 0.2128612;
netsum += inarray[1] * 0.1049047;
netsum += inarray[2] * -7.841387E-02;
netsum += inarray[3] * -0.1648899;
netsum += inarray[4] * 0.2000224;
netsum += inarray[5] * 4.495818E-02;
feature3[3] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.3092304;
netsum += inarray[0] * 0.1563326;
netsum += inarray[1] * -0.1449868;
netsum += inarray[2] * 0.3564435;
netsum += inarray[3] * -0.2812038;
netsum += inarray[4] * 0.4952509;
netsum += inarray[5] * 0.1238582;
feature3[4] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.2539366;
netsum += inarray[0] * -0.1381994;
netsum += inarray[1] * -6.911561E-02;
netsum += inarray[2] * -0.142459;
netsum += inarray[3] * 0.1010081;
netsum += inarray[4] * -0.156301;
netsum += inarray[5] * -0.2416967;
feature3[5] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.360628;
netsum += inarray[0] * -0.2742201;
netsum += inarray[1] * 0.1337124;
netsum += inarray[2] * -0.312238;
netsum += inarray[3] * 0.0867711;
netsum += inarray[4] * 1.052461E-02;
netsum += inarray[5] * -0.1754237;
feature3[6] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.3153153;
netsum += inarray[0] * -7.813205E-03;
netsum += inarray[1] * 8.482616E-02;
netsum += inarray[2] * 6.168706E-02;
netsum += inarray[3] * 1.549877E-02;
netsum += inarray[4] * -0.1095669;
netsum += inarray[5] * 0.1292428;
feature3[7] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.2514491;
netsum += inarray[0] * -0.2943599;
netsum += inarray[1] * 0.2704945;
netsum += inarray[2] * -0.1200943;
netsum += inarray[3] * -2.715204E-02;
netsum += inarray[4] * -0.4059355;
netsum += inarray[5] * -0.2581095;
feature3[8] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.1963221;
netsum += inarray[0] * -0.2594927;
netsum += inarray[1] * -0.2916315;
netsum += inarray[2] * -0.1420942;
netsum += inarray[3] * -1.272736E-02;
netsum += inarray[4] * -0.3088457;
netsum += inarray[5] * 0.132125;
feature3[9] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.3500101;
netsum += inarray[0] * -2.409486E-02;
netsum += inarray[1] * 6.772569E-02;
netsum += inarray[2] * 0.1440515;
netsum += inarray[3] * -0.2609615;
netsum += inarray[4] * 0.3011613;
netsum += inarray[5] * 0.3491137;
feature3[10] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.2564353;
netsum += inarray[0] * 0.101464;
netsum += inarray[1] * -0.1518573;
netsum += inarray[2] * 0.240853;
netsum += inarray[3] * 6.207299E-02;
netsum += inarray[4] * 0.4048892;
netsum += inarray[5] * 0.3520205;
feature3[11] = 2 / (1 + exp(-netsum)) - 1;

netsum = -7.618195E-02;
netsum += inarray[0] * 0.0890865;
netsum += inarray[1] * 0.41503;
netsum += inarray[2] * 0.164995;
netsum += inarray[3] * 5.603925E-02;
netsum += inarray[4] * 0.1748387;
netsum += inarray[5] * 0.1591834;
feature3[12] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.2929284;
netsum += inarray[0] * -3.58689E-03;
netsum += inarray[1] * -0.1059195;
netsum += inarray[2] * 0.131218;
netsum += inarray[3] * 5.831553E-02;
netsum += inarray[4] * -0.2589216;
netsum += inarray[5] * -0.1692969;
feature3[13] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.1823639;
netsum += inarray[0] * -0.2866738;
netsum += inarray[1] * 0.4251814;
netsum += inarray[2] * 0.2434064;
netsum += inarray[3] * 0.1094243;
netsum += inarray[4] * -9.822383E-02;
netsum += inarray[5] * 0.2600475;
feature3[14] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.2970661;
netsum += inarray[0] * 2.114946E-02;
netsum += inarray[1] * -0.2881813;
netsum += inarray[2] * -3.236846E-02;
netsum += inarray[3] * 0.2553767;
netsum += inarray[4] * -0.3710573;
netsum += inarray[5] * -0.2826948;
feature3[15] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.1553667;
netsum += inarray[0] * -0.1695899;
netsum += inarray[1] * 1.381556E-02;
netsum += inarray[2] * 5.971845E-03;
netsum += inarray[3] * -0.1838583;
netsum += inarray[4] * -0.3387045;
netsum += inarray[5] * -0.3394055;
feature3[16] = 2 / (1 + exp(-netsum)) - 1;

netsum = 5.424221E-02;
netsum += inarray[0] * 0.1143664;
netsum += inarray[1] * -0.1815583;
netsum += inarray[2] * 0.1738695;
netsum += inarray[3] * 1.353002E-02;
netsum += inarray[4] * 0.2025092;
netsum += inarray[5] * 0.2566315;
feature3[17] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.203296;
netsum += inarray[0] * -0.1052924;
netsum += inarray[1] * 1.779747E-02;
netsum += inarray[2] * -3.792686E-02;
netsum += inarray[3] * 0.2422994;
netsum += inarray[4] * 0.1942204;
netsum += inarray[5] * 3.240249E-02;
feature3[18] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.1823413;
netsum += inarray[0] * -0.0469526;
netsum += inarray[1] * 0.2009117;
netsum += inarray[2] * -0.2790664;
netsum += inarray[3] * 0.2683001;
netsum += inarray[4] * -4.416018E-02;
netsum += inarray[5] * 2.026811E-02;
feature3[19] = 2 / (1 + exp(-netsum)) - 1;

netsum = -5.280435E-02;
netsum += inarray[0] * 0.5004903;
netsum += inarray[1] * 0.3620402;
netsum += inarray[2] * 0.5840747;
netsum += inarray[3] * -0.333115;
netsum += inarray[4] * 0.2482204;
netsum += inarray[5] * 0.2651443;
feature4[0] = tanh(1.5 * netsum);

netsum = 5.385444E-02;
netsum += inarray[0] * 0.4136027;
netsum += inarray[1] * -0.3835627;
netsum += inarray[2] * -0.3468212;
netsum += inarray[3] * -0.230848;
netsum += inarray[4] * 0.1753895;
netsum += inarray[5] * -0.256072;
feature4[1] = tanh(1.5 * netsum);

netsum = 0.1189801;
netsum += inarray[0] * -1.446006E-02;
netsum += inarray[1] * -0.7133192;
netsum += inarray[2] * -0.3617613;
netsum += inarray[3] * -0.4000092;
netsum += inarray[4] * 6.966039E-02;
netsum += inarray[5] * -0.5704128;
feature4[2] = tanh(1.5 * netsum);

netsum = 1.130842;
netsum += inarray[0] * 1.945711;
netsum += inarray[1] * -0.8967102;
netsum += inarray[2] * -1.183123;
netsum += inarray[3] * -1.369436;
netsum += inarray[4] * 1.159359;
netsum += inarray[5] * -1.000148;
feature4[3] = tanh(1.5 * netsum);

netsum = -0.928385;
netsum += inarray[0] * -0.9949765;
netsum += inarray[1] * 0.976635;
netsum += inarray[2] * -0.2637514;
netsum += inarray[3] * 0.1093401;
netsum += inarray[4] * -0.456215;
netsum += inarray[5] * -0.4894192;
feature4[4] = tanh(1.5 * netsum);

netsum = 0.4579218;
netsum += inarray[0] * -0.5343518;
netsum += inarray[1] * 2.096555;
netsum += inarray[2] * -0.2100652;
netsum += inarray[3] * -1.47646;
netsum += inarray[4] * -0.5632629;
netsum += inarray[5] * -1.359775;
feature4[5] = tanh(1.5 * netsum);

netsum = 1.10289;
netsum += inarray[0] * 1.965906;
netsum += inarray[1] * -1.145052;
netsum += inarray[2] * -1.03076;
netsum += inarray[3] * -1.6051;
netsum += inarray[4] * 1.437531;
netsum += inarray[5] * -1.187893;
feature4[6] = tanh(1.5 * netsum);

netsum = -0.3570893;
netsum += inarray[0] * 0.1190443;
netsum += inarray[1] * 0.489033;
netsum += inarray[2] * 0.6270974;
netsum += inarray[3] * -0.2026271;
netsum += inarray[4] * 0.3890141;
netsum += inarray[5] * 0.2341042;
feature4[7] = tanh(1.5 * netsum);

netsum = -0.6636403;
netsum += inarray[0] * -0.116309;
netsum += inarray[1] * 1.013074;
netsum += inarray[2] * 0.9504861;
netsum += inarray[3] * 0.6475263;
netsum += inarray[4] * -1.029086;
netsum += inarray[5] * 0.1129752;
feature4[8] = tanh(1.5 * netsum);

netsum = -1.501394;
netsum += inarray[0] * -0.6592285;
netsum += inarray[1] * 2.270337;
netsum += inarray[2] * 1.710966;
netsum += inarray[3] * 2.358285;
netsum += inarray[4] * -3.082308;
netsum += inarray[5] * -0.7982506;
feature4[9] = tanh(1.5 * netsum);

netsum = -1.364243;
netsum += inarray[0] * 6.893337E-02;
netsum += inarray[1] * -8.944127E-02;
netsum += inarray[2] * 1.579165;
netsum += inarray[3] * 1.602971;
netsum += inarray[4] * -0.2409213;
netsum += inarray[5] * 1.603944;
feature4[10] = tanh(1.5 * netsum);

netsum = 0.1690149;
netsum += inarray[0] * 0.2112996;
netsum += inarray[1] * 0.4236899;
netsum += inarray[2] * 0.4441457;
netsum += inarray[3] * -0.234581;
netsum += inarray[4] * 1.840745E-02;
netsum += inarray[5] * 0.2813962;
feature4[11] = tanh(1.5 * netsum);

netsum = 0.0755134;
netsum += inarray[0] * -0.3635265;
netsum += inarray[1] * -0.4892099;
netsum += inarray[2] * -0.5627924;
netsum += inarray[3] * -0.3279944;
netsum += inarray[4] * 3.774653E-02;
netsum += inarray[5] * -3.930025E-02;
feature4[12] = tanh(1.5 * netsum);

netsum = -0.6373785;
netsum += inarray[0] * -0.9429321;
netsum += inarray[1] * -0.7050451;
netsum += inarray[2] * -0.1852855;
netsum += inarray[3] * -8.253275E-02;
netsum += inarray[4] * 0.3568192;
netsum += inarray[5] * 0.6065335;
feature4[13] = tanh(1.5 * netsum);

netsum = 0.6911118;
netsum += inarray[0] * 0.5651432;
netsum += inarray[1] * -5.028652E-02;
netsum += inarray[2] * 4.044602E-02;
netsum += inarray[3] * -0.1767005;
netsum += inarray[4] * 0.3357077;
netsum += inarray[5] * 8.067961E-02;
feature4[14] = tanh(1.5 * netsum);

netsum = -0.4213112;
netsum += inarray[0] * -0.9825904;
netsum += inarray[1] * 0.4844164;
netsum += inarray[2] * 1.027554;
netsum += inarray[3] * 1.25037;
netsum += inarray[4] * -0.2505077;
netsum += inarray[5] * 1.121841;
feature4[15] = tanh(1.5 * netsum);

netsum = 1.108017;
netsum += inarray[0] * -0.4954459;
netsum += inarray[1] * -1.388459;
netsum += inarray[2] * -0.8746663;
netsum += inarray[3] * -0.2215056;
netsum += inarray[4] * -0.5241733;
netsum += inarray[5] * -4.154977E-02;
feature4[16] = tanh(1.5 * netsum);

netsum = 0.2118785;
netsum += inarray[0] * -4.474436E-02;
netsum += inarray[1] * -7.554981E-02;
netsum += inarray[2] * -2.713441E-02;
netsum += inarray[3] * 8.688205E-03;
netsum += inarray[4] * 0.6242619;
netsum += inarray[5] * 0.26304;
feature4[17] = tanh(1.5 * netsum);

netsum = 0.0519742;
netsum += inarray[0] * -1.570361;
netsum += inarray[1] * 0.1403211;
netsum += inarray[2] * -0.5718735;
netsum += inarray[3] * 0.7042204;
netsum += inarray[4] * 0.1536792;
netsum += inarray[5] * 1.073115;
feature4[18] = tanh(1.5 * netsum);

netsum = -6.514069E-02;
netsum += inarray[0] * 0.2546216;
netsum += inarray[1] * -1.982311;
netsum += inarray[2] * 0.9450154;
netsum += inarray[3] * 1.22247;
netsum += inarray[4] * 0.1573528;
netsum += inarray[5] * 1.599616;
feature4[19] = tanh(1.5 * netsum);

netsum = 0.5029458;
netsum += feature2[0] * 0.3734125;
netsum += feature2[1] * -7.646488E-02;
netsum += feature2[2] * -3.086728E-02;
netsum += feature2[3] * -0.1112821;
netsum += feature2[4] * 0.2464961;
netsum += feature2[5] * -6.159315E-02;
netsum += feature2[6] * 0.1274551;
netsum += feature2[7] * 0.152825;
netsum += feature2[8] * 0.2856139;
netsum += feature2[9] * -6.930707E-02;
netsum += feature2[10] * 0.7678486;
netsum += feature2[11] * 0.3825893;
netsum += feature2[12] * -9.722213E-02;
netsum += feature2[13] * -0.1054285;
netsum += feature2[14] * 1.346381E-02;
netsum += feature2[15] * -6.794335E-02;
netsum += feature2[16] * -0.2415585;
netsum += feature2[17] * -0.282502;
netsum += feature2[18] * 0.0662608;
netsum += feature2[19] * 0.2217603;
netsum += 0.7935963;
netsum += feature3[0] * -2.512379E-02;
netsum += feature3[1] * -3.061627E-02;
netsum += feature3[2] * 0.3212983;
netsum += feature3[3] * -7.657795E-02;
netsum += feature3[4] * -0.393534;
netsum += feature3[5] * 0.1853516;
netsum += feature3[6] * -3.487117E-02;
netsum += feature3[7] * -0.1067874;
netsum += feature3[8] * 0.2193447;
netsum += feature3[9] * 9.360956E-02;
netsum += feature3[10] * -0.1464485;
netsum += feature3[11] * -0.2969636;
netsum += feature3[12] * -0.1846546;
netsum += feature3[13] * 1.377043E-02;
netsum += feature3[14] * -0.1574036;
netsum += feature3[15] * 0.3552923;
netsum += feature3[16] * 0.1209264;
netsum += feature3[17] * -0.1096251;
netsum += feature3[18] * 0.0453308;
netsum += feature3[19] * 8.227438E-02;
netsum += 0.2385496;
netsum += feature4[0] * 0.3263265;
netsum += feature4[1] * 0.1971735;
netsum += feature4[2] * 0.2878035;
netsum += feature4[3] * -1.366272;
netsum += feature4[4] * -1.254956;
netsum += feature4[5] * 0.7535468;
netsum += feature4[6] * -1.52794;
netsum += feature4[7] * 0.1528469;
netsum += feature4[8] * -0.4587618;
netsum += feature4[9] * 2.279151;
netsum += feature4[10] * 0.8595973;
netsum += feature4[11] * -1.266154E-02;
netsum += feature4[12] * -6.252453E-02;
netsum += feature4[13] * -0.8379557;
netsum += feature4[14] * 0.1069293;
netsum += feature4[15] * -1.323868;
netsum += feature4[16] * -0.7429547;
netsum += feature4[17] * 0.1559195;
netsum += feature4[18] * 0.6031213;
netsum += feature4[19] * 0.9988207;
outarray[0] = 1 / (1 + exp(-netsum));


outarray[0] = 0.162 *  (outarray[0] - .1) / .8 ;
if (outarray[0]<0) outarray[0] = 0;
if (outarray[0]>0.162) outarray[0] = 0.162;

               
} /* end navistarCO() */

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
    /* Call the navistarCO function. */
    navistarCO(&inarray[currIndex],&tmp);
    outarray[i]=tmp; /* assign to outarray */
  }
} /* end mexFunction() */

/* 
to test:
out=navistarCO([[60:70];diff([60:71]);diff([60:71]);[60:70];diff([60:71]);diff([60:71])]) 
*/