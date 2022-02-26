#ifndef navistarCO2func_c
#define navistarCO2func_c
/* Insert this code into your C program to fire the 
   C:\NeuroShell 2\Nav Pos CO2 (04-05-02) network */
/* This code is designed to be simple and fast for porting to any machine */
/* Therefore all code and weights are inline without looping or data storage */
/*   which might be harder to port between compilers. */

/* 
% Neural Network Mex file for Use with ADVISOR: navistarCO2func.c
%
% Data source: Testing by West Virginia University
%
% Data confidence level:  no comparison has been performed
%
% Notes:  Neural Network predicts CO2 emissions of Navistar CI Engine
% Navistar T 444E (model year 1994), 8-cylinder, 7.3 liter, rated power of 
% 175 HP, peak torque 460 Nm@1400 rpm, speed governed at 2600 rpm
%
% Integrated into Advisor on:  05 April 2002
% Integrated into Advisor by:  Michael O'Keefe, National Renewable 
%                        Energy Laboratory, Michael_OKeefe@nrel.gov
% Original file provided by: West Virginia University
%
% Revision history at end of file.
*/

#include "wvuNN.h"

void navistarCO2func(double *inarray, double *outarray)
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

netsum = -0.323631;
netsum += inarray[0] * 0.2867476;
netsum += inarray[1] * 0.2612309;
netsum += inarray[2] * -0.0710944;
netsum += inarray[3] * 0.1200773;
netsum += inarray[4] * -0.2381298;
netsum += inarray[5] * 0.1554058;
feature2[0] = tanh(netsum);

netsum = 7.101534E-02;
netsum += inarray[0] * -1.078418E-02;
netsum += inarray[1] * 0.1658076;
netsum += inarray[2] * -0.2284006;
netsum += inarray[3] * 5.920656E-02;
netsum += inarray[4] * 0.2130473;
netsum += inarray[5] * -0.0260464;
feature2[1] = tanh(netsum);

netsum = -0.2292217;
netsum += inarray[0] * -0.2892908;
netsum += inarray[1] * 0.2687733;
netsum += inarray[2] * 0.1022955;
netsum += inarray[3] * 9.831869E-02;
netsum += inarray[4] * -0.2206894;
netsum += inarray[5] * -0.1448839;
feature2[2] = tanh(netsum);

netsum = 0.2085845;
netsum += inarray[0] * -0.2936035;
netsum += inarray[1] * 0.2427701;
netsum += inarray[2] * -0.2792214;
netsum += inarray[3] * 1.317114E-02;
netsum += inarray[4] * 0.2649259;
netsum += inarray[5] * 4.192197E-02;
feature2[3] = tanh(netsum);

netsum = 3.354641E-02;
netsum += inarray[0] * -0.3077169;
netsum += inarray[1] * 1.633811E-03;
netsum += inarray[2] * -0.2787597;
netsum += inarray[3] * -8.083126E-02;
netsum += inarray[4] * 0.2087568;
netsum += inarray[5] * 0.1165813;
feature2[4] = tanh(netsum);

netsum = 6.432194E-03;
netsum += inarray[0] * -5.474559E-02;
netsum += inarray[1] * -0.211025;
netsum += inarray[2] * 0.2529462;
netsum += inarray[3] * 0.108932;
netsum += inarray[4] * -0.2295443;
netsum += inarray[5] * 0.1691768;
feature2[5] = tanh(netsum);

netsum = -0.1777748;
netsum += inarray[0] * 1.561165E-02;
netsum += inarray[1] * -3.974592E-02;
netsum += inarray[2] * -0.1337087;
netsum += inarray[3] * -0.3596317;
netsum += inarray[4] * 4.343656E-02;
netsum += inarray[5] * 0.1031753;
feature2[6] = tanh(netsum);

netsum = 0.2796187;
netsum += inarray[0] * 0.1111061;
netsum += inarray[1] * -0.1374347;
netsum += inarray[2] * -0.127296;
netsum += inarray[3] * -0.110648;
netsum += inarray[4] * -0.2602932;
netsum += inarray[5] * 5.591644E-04;
feature2[7] = tanh(netsum);

netsum = 0.2339911;
netsum += inarray[0] * 9.929896E-02;
netsum += inarray[1] * 0.2216132;
netsum += inarray[2] * 5.321257E-02;
netsum += inarray[3] * -3.427906E-02;
netsum += inarray[4] * 0.287497;
netsum += inarray[5] * -0.2189569;
feature2[8] = tanh(netsum);

netsum = 0.1783891;
netsum += inarray[0] * 8.553798E-02;
netsum += inarray[1] * -0.2088944;
netsum += inarray[2] * 0.0997932;
netsum += inarray[3] * 8.057357E-02;
netsum += inarray[4] * 0.1735669;
netsum += inarray[5] * -0.1029186;
feature2[9] = tanh(netsum);

netsum = -0.1994326;
netsum += inarray[0] * -0.2028025;
netsum += inarray[1] * 0.1912548;
netsum += inarray[2] * 0.211774;
netsum += inarray[3] * 7.620879E-03;
netsum += inarray[4] * -0.303081;
netsum += inarray[5] * 0.1686456;
feature2[10] = tanh(netsum);

netsum = 0.2258467;
netsum += inarray[0] * -1.617962E-02;
netsum += inarray[1] * 0.2679105;
netsum += inarray[2] * 0.1469385;
netsum += inarray[3] * 0.4601335;
netsum += inarray[4] * 8.937593E-02;
netsum += inarray[5] * -0.2498348;
feature2[11] = tanh(netsum);

netsum = 0.1616008;
netsum += inarray[0] * -0.0387549;
netsum += inarray[1] * 0.305155;
netsum += inarray[2] * 2.857619E-03;
netsum += inarray[3] * 0.1519639;
netsum += inarray[4] * 0.1889088;
netsum += inarray[5] * 2.429778E-02;
feature2[12] = tanh(netsum);

netsum = 3.647619E-03;
netsum += inarray[0] * -8.911694E-02;
netsum += inarray[1] * 0.2977237;
netsum += inarray[2] * -0.1788099;
netsum += inarray[3] * -0.1175175;
netsum += inarray[4] * 5.731081E-02;
netsum += inarray[5] * 9.912121E-02;
feature2[13] = tanh(netsum);

netsum = -0.2041582;
netsum += inarray[0] * -0.3790331;
netsum += inarray[1] * 0.0587531;
netsum += inarray[2] * 0.2029321;
netsum += inarray[3] * -0.1595363;
netsum += inarray[4] * -0.3326504;
netsum += inarray[5] * -3.743119E-02;
feature2[14] = tanh(netsum);

netsum = -0.3942393;
netsum += inarray[0] * 0.1063004;
netsum += inarray[1] * -6.413536E-02;
netsum += inarray[2] * -3.232817E-02;
netsum += inarray[3] * -0.1456499;
netsum += inarray[4] * -0.1053316;
netsum += inarray[5] * -0.311824;
feature2[15] = tanh(netsum);

netsum = -0.3537013;
netsum += inarray[0] * 0.3102469;
netsum += inarray[1] * -5.674818E-02;
netsum += inarray[2] * -1.594766E-02;
netsum += inarray[3] * 0.3556342;
netsum += inarray[4] * 0.1428098;
netsum += inarray[5] * 0.3750918;
feature2[16] = tanh(netsum);

netsum = -0.1208438;
netsum += inarray[0] * 0.2068319;
netsum += inarray[1] * -0.1099988;
netsum += inarray[2] * 0.2915794;
netsum += inarray[3] * -0.248726;
netsum += inarray[4] * 1.408605E-02;
netsum += inarray[5] * 0.2594101;
feature2[17] = tanh(netsum);

netsum = -0.2938548;
netsum += inarray[0] * -5.487107E-02;
netsum += inarray[1] * 0.1751244;
netsum += inarray[2] * 0.1338124;
netsum += inarray[3] * -8.817804E-03;
netsum += inarray[4] * -0.1682336;
netsum += inarray[5] * -7.856915E-03;
feature2[18] = tanh(netsum);

netsum = -0.2383515;
netsum += inarray[0] * -0.1309066;
netsum += inarray[1] * -0.2868786;
netsum += inarray[2] * -0.2378933;
netsum += inarray[3] * -4.472247E-03;
netsum += inarray[4] * 7.334261E-03;
netsum += inarray[5] * -9.365303E-02;
feature2[19] = tanh(netsum);

netsum = -0.2116476;
netsum += inarray[0] * -0.2321572;
netsum += inarray[1] * -0.178107;
netsum += inarray[2] * -0.2804916;
netsum += inarray[3] * 5.623566E-02;
netsum += inarray[4] * 0.1215534;
netsum += inarray[5] * -3.945963E-02;
feature3[0] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.2291652;
netsum += inarray[0] * -0.2815042;
netsum += inarray[1] * 6.809029E-02;
netsum += inarray[2] * 0.2507757;
netsum += inarray[3] * 0.1143296;
netsum += inarray[4] * 0.1022575;
netsum += inarray[5] * -3.550257E-02;
feature3[1] = 2 / (1 + exp(-netsum)) - 1;

netsum = 9.538095E-02;
netsum += inarray[0] * -0.262715;
netsum += inarray[1] * 2.753907E-02;
netsum += inarray[2] * -0.1172725;
netsum += inarray[3] * 0.2817805;
netsum += inarray[4] * -0.305651;
netsum += inarray[5] * -0.1123981;
feature3[2] = 2 / (1 + exp(-netsum)) - 1;

netsum = 8.646312E-02;
netsum += inarray[0] * 0.1818601;
netsum += inarray[1] * 6.904394E-02;
netsum += inarray[2] * -0.1720249;
netsum += inarray[3] * -0.1963439;
netsum += inarray[4] * 0.1303293;
netsum += inarray[5] * -2.684059E-02;
feature3[3] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.2297988;
netsum += inarray[0] * 0.1927021;
netsum += inarray[1] * -0.2215114;
netsum += inarray[2] * 0.1412855;
netsum += inarray[3] * -0.2930582;
netsum += inarray[4] * 0.3456696;
netsum += inarray[5] * -2.728329E-02;
feature3[4] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.2102134;
netsum += inarray[0] * -0.1739627;
netsum += inarray[1] * 6.960427E-04;
netsum += inarray[2] * -5.306826E-02;
netsum += inarray[3] * 5.873267E-02;
netsum += inarray[4] * -0.1120612;
netsum += inarray[5] * -0.2081638;
feature3[5] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.2479845;
netsum += inarray[0] * -0.2542284;
netsum += inarray[1] * 0.2669393;
netsum += inarray[2] * -0.1867135;
netsum += inarray[3] * 0.0648806;
netsum += inarray[4] * 6.564589E-02;
netsum += inarray[5] * -0.1166257;
feature3[6] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.2502397;
netsum += inarray[0] * 1.506869E-02;
netsum += inarray[1] * 0.1095183;
netsum += inarray[2] * 7.221095E-02;
netsum += inarray[3] * 1.489277E-02;
netsum += inarray[4] * -0.1038629;
netsum += inarray[5] * 0.1344728;
feature3[7] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.1559836;
netsum += inarray[0] * -0.2810202;
netsum += inarray[1] * 0.274898;
netsum += inarray[2] * 8.380884E-02;
netsum += inarray[3] * -1.136439E-03;
netsum += inarray[4] * -0.2440708;
netsum += inarray[5] * -8.985224E-02;
feature3[8] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.1211278;
netsum += inarray[0] * -0.2406952;
netsum += inarray[1] * -0.1856544;
netsum += inarray[2] * -2.700392E-02;
netsum += inarray[3] * 1.70338E-03;
netsum += inarray[4] * -0.2427123;
netsum += inarray[5] * 0.1958698;
feature3[9] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.2752035;
netsum += inarray[0] * -8.535209E-03;
netsum += inarray[1] * -9.629207E-02;
netsum += inarray[2] * -1.732044E-02;
netsum += inarray[3] * -0.2359046;
netsum += inarray[4] * 0.2237867;
netsum += inarray[5] * 0.2810757;
feature3[10] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.1384833;
netsum += inarray[0] * 0.1395428;
netsum += inarray[1] * -0.2083043;
netsum += inarray[2] * 4.406552E-02;
netsum += inarray[3] * 0.063316;
netsum += inarray[4] * 0.2503369;
netsum += inarray[5] * 0.2045463;
feature3[11] = 2 / (1 + exp(-netsum)) - 1;

netsum = -9.524747E-02;
netsum += inarray[0] * 0.1108108;
netsum += inarray[1] * 0.3038424;
netsum += inarray[2] * 8.457664E-02;
netsum += inarray[3] * 8.341757E-02;
netsum += inarray[4] * 0.1387337;
netsum += inarray[5] * 0.1396158;
feature3[12] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.2300213;
netsum += inarray[0] * 1.296035E-02;
netsum += inarray[1] * -2.839668E-02;
netsum += inarray[2] * 0.2098724;
netsum += inarray[3] * 5.342971E-02;
netsum += inarray[4] * -0.2026678;
netsum += inarray[5] * -0.126679;
feature3[13] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.1497061;
netsum += inarray[0] * -0.2589721;
netsum += inarray[1] * 0.3007909;
netsum += inarray[2] * 0.2013763;
netsum += inarray[3] * 0.1211613;
netsum += inarray[4] * -0.1133663;
netsum += inarray[5] * 0.270062;
feature3[14] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.2242967;
netsum += inarray[0] * -2.844514E-02;
netsum += inarray[1] * -0.2179498;
netsum += inarray[2] * 9.468169E-02;
netsum += inarray[3] * 0.2666225;
netsum += inarray[4] * -0.2926692;
netsum += inarray[5] * -0.2024349;
feature3[15] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.1176173;
netsum += inarray[0] * -0.1806288;
netsum += inarray[1] * 7.106337E-02;
netsum += inarray[2] * 0.1292363;
netsum += inarray[3] * -0.2336148;
netsum += inarray[4] * -0.2439312;
netsum += inarray[5] * -0.2668516;
feature3[16] = 2 / (1 + exp(-netsum)) - 1;

netsum = 6.143833E-02;
netsum += inarray[0] * 0.1199773;
netsum += inarray[1] * -0.2501622;
netsum += inarray[2] * 3.537197E-02;
netsum += inarray[3] * 2.207679E-02;
netsum += inarray[4] * 9.945289E-02;
netsum += inarray[5] * 0.1653704;
feature3[17] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.1742336;
netsum += inarray[0] * -0.1183807;
netsum += inarray[1] * -2.706737E-02;
netsum += inarray[2] * -6.429283E-02;
netsum += inarray[3] * 0.2780986;
netsum += inarray[4] * 0.1644291;
netsum += inarray[5] * 0.0313971;
feature3[18] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.1392958;
netsum += inarray[0] * -3.707854E-02;
netsum += inarray[1] * 0.2701443;
netsum += inarray[2] * -0.1827916;
netsum += inarray[3] * 0.2758186;
netsum += inarray[4] * 6.951077E-03;
netsum += inarray[5] * 0.0733706;
feature3[19] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.2007472;
netsum += inarray[0] * 0.543793;
netsum += inarray[1] * -0.1723166;
netsum += inarray[2] * -7.278498E-02;
netsum += inarray[3] * -0.5326043;
netsum += inarray[4] * -3.635935E-02;
netsum += inarray[5] * -8.160102E-02;
feature4[0] = tanh(1.5 * netsum);

netsum = -0.5436414;
netsum += inarray[0] * 4.992722E-02;
netsum += inarray[1] * 1.495871E-02;
netsum += inarray[2] * -3.491844E-02;
netsum += inarray[3] * -0.5481531;
netsum += inarray[4] * 0.3602279;
netsum += inarray[5] * -0.2485594;
feature4[1] = tanh(1.5 * netsum);

netsum = -0.3519191;
netsum += inarray[0] * -0.4108571;
netsum += inarray[1] * -9.563286E-02;
netsum += inarray[2] * -0.1049917;
netsum += inarray[3] * -3.370793E-02;
netsum += inarray[4] * -1.303601E-02;
netsum += inarray[5] * -0.2013845;
feature4[2] = tanh(1.5 * netsum);

netsum = 1.666059;
netsum += inarray[0] * -1.120499;
netsum += inarray[1] * -0.5683812;
netsum += inarray[2] * 0.1448882;
netsum += inarray[3] * -0.9059377;
netsum += inarray[4] * -0.241608;
netsum += inarray[5] * 0.1126683;
feature4[3] = tanh(1.5 * netsum);

netsum = -0.318507;
netsum += inarray[0] * -8.413736E-02;
netsum += inarray[1] * 0.2521763;
netsum += inarray[2] * 0.1020254;
netsum += inarray[3] * -0.4809475;
netsum += inarray[4] * 4.510671E-02;
netsum += inarray[5] * -0.3926768;
feature4[4] = tanh(1.5 * netsum);

netsum = 0.2705578;
netsum += inarray[0] * 0.2108045;
netsum += inarray[1] * 0.197946;
netsum += inarray[2] * -0.1255423;
netsum += inarray[3] * 0.2611166;
netsum += inarray[4] * -0.5012343;
netsum += inarray[5] * 6.750923E-02;
feature4[5] = tanh(1.5 * netsum);

netsum = 0.7146004;
netsum += inarray[0] * -0.4186002;
netsum += inarray[1] * -0.3330168;
netsum += inarray[2] * 0.1242415;
netsum += inarray[3] * -0.2676266;
netsum += inarray[4] * -0.1911986;
netsum += inarray[5] * -0.345802;
feature4[6] = tanh(1.5 * netsum);

netsum = -8.296363E-02;
netsum += inarray[0] * 0.3251362;
netsum += inarray[1] * 4.363211E-02;
netsum += inarray[2] * 0.3344064;
netsum += inarray[3] * -7.017101E-02;
netsum += inarray[4] * 0.3634968;
netsum += inarray[5] * 0.1842355;
feature4[7] = tanh(1.5 * netsum);

netsum = -0.2675353;
netsum += inarray[0] * 0.2935708;
netsum += inarray[1] * 0.1278005;
netsum += inarray[2] * 0.6212131;
netsum += inarray[3] * -0.118005;
netsum += inarray[4] * 6.829708E-03;
netsum += inarray[5] * 0.4642099;
feature4[8] = tanh(1.5 * netsum);

netsum = 8.158213E-02;
netsum += inarray[0] * 0.1901978;
netsum += inarray[1] * 0.3309102;
netsum += inarray[2] * 0.2971257;
netsum += inarray[3] * 4.167358E-03;
netsum += inarray[4] * -0.3592246;
netsum += inarray[5] * -0.2687769;
feature4[9] = tanh(1.5 * netsum);

netsum = -0.4954935;
netsum += inarray[0] * 0.3482187;
netsum += inarray[1] * -0.1032646;
netsum += inarray[2] * -2.469785E-02;
netsum += inarray[3] * 0.4050888;
netsum += inarray[4] * 0.2169838;
netsum += inarray[5] * 0.2203864;
feature4[10] = tanh(1.5 * netsum);

netsum = -0.122869;
netsum += inarray[0] * -1.418493E-02;
netsum += inarray[1] * 3.537663E-02;
netsum += inarray[2] * -6.464771E-03;
netsum += inarray[3] * -0.4607056;
netsum += inarray[4] * -0.1011246;
netsum += inarray[5] * 3.243311E-02;
feature4[11] = tanh(1.5 * netsum);

netsum = -3.338526E-02;
netsum += inarray[0] * -0.2785592;
netsum += inarray[1] * -4.266075E-02;
netsum += inarray[2] * -7.567511E-02;
netsum += inarray[3] * -0.2270142;
netsum += inarray[4] * 0.1158632;
netsum += inarray[5] * 0.1237439;
feature4[12] = tanh(1.5 * netsum);

netsum = 0.4561281;
netsum += inarray[0] * -0.2207277;
netsum += inarray[1] * -0.5920309;
netsum += inarray[2] * 0.2466553;
netsum += inarray[3] * -0.2648003;
netsum += inarray[4] * 0.2316024;
netsum += inarray[5] * 0.1530373;
feature4[13] = tanh(1.5 * netsum);

netsum = 0.3748522;
netsum += inarray[0] * 0.2419296;
netsum += inarray[1] * -0.206239;
netsum += inarray[2] * -0.149553;
netsum += inarray[3] * -9.057707E-02;
netsum += inarray[4] * -4.735028E-02;
netsum += inarray[5] * 2.991265E-02;
feature4[14] = tanh(1.5 * netsum);

netsum = 0.1839778;
netsum += inarray[0] * 0.143281;
netsum += inarray[1] * 0.2169484;
netsum += inarray[2] * 0.2126099;
netsum += inarray[3] * 0.2051368;
netsum += inarray[4] * 0.2881507;
netsum += inarray[5] * 0.1171319;
feature4[15] = tanh(1.5 * netsum);

netsum = 0.2760108;
netsum += inarray[0] * 6.610055E-02;
netsum += inarray[1] * -0.8896892;
netsum += inarray[2] * 0.1325382;
netsum += inarray[3] * -7.848669E-02;
netsum += inarray[4] * -0.589202;
netsum += inarray[5] * -0.2070271;
feature4[16] = tanh(1.5 * netsum);

netsum = -8.369929E-02;
netsum += inarray[0] * -0.2454501;
netsum += inarray[1] * -0.1340755;
netsum += inarray[2] * -0.175513;
netsum += inarray[3] * -0.2465968;
netsum += inarray[4] * 0.5377798;
netsum += inarray[5] * 0.1607894;
feature4[17] = tanh(1.5 * netsum);

netsum = -0.1227859;
netsum += inarray[0] * -2.903524E-02;
netsum += inarray[1] * 0.1211681;
netsum += inarray[2] * 0.0262451;
netsum += inarray[3] * 0.3223937;
netsum += inarray[4] * 8.268819E-02;
netsum += inarray[5] * 0.1452146;
feature4[18] = tanh(1.5 * netsum);

netsum = 0.1177575;
netsum += inarray[0] * 0.3183255;
netsum += inarray[1] * -0.1850143;
netsum += inarray[2] * 0.1228439;
netsum += inarray[3] * 0.6389957;
netsum += inarray[4] * 5.754457E-02;
netsum += inarray[5] * 0.1751316;
feature4[19] = tanh(1.5 * netsum);

netsum = 0.1334851;
netsum += feature2[0] * 0.1238723;
netsum += feature2[1] * 4.480818E-02;
netsum += feature2[2] * 1.461839E-02;
netsum += feature2[3] * -6.595355E-02;
netsum += feature2[4] * -0.1764207;
netsum += feature2[5] * 0.2848035;
netsum += feature2[6] * -0.2605602;
netsum += feature2[7] * 0.0878962;
netsum += feature2[8] * -3.384214E-02;
netsum += feature2[9] * -0.1098362;
netsum += feature2[10] * 0.214159;
netsum += feature2[11] * 0.3263437;
netsum += feature2[12] * 4.510899E-02;
netsum += feature2[13] * -5.145135E-02;
netsum += feature2[14] * 0.2766178;
netsum += feature2[15] * -0.2784339;
netsum += feature2[16] * 0.3464128;
netsum += feature2[17] * -8.224934E-02;
netsum += feature2[18] * -0.1039126;
netsum += feature2[19] * -4.426635E-02;
netsum += 0.4241188;
netsum += feature3[0] * -0.2699684;
netsum += feature3[1] * 0.2262144;
netsum += feature3[2] * 0.2043408;
netsum += feature3[3] * -0.1681279;
netsum += feature3[4] * -0.3694547;
netsum += feature3[5] * 2.950078E-02;
netsum += feature3[6] * -0.1536922;
netsum += feature3[7] * -7.428414E-02;
netsum += feature3[8] * 0.2642981;
netsum += feature3[9] * 5.313167E-02;
netsum += feature3[10] * -4.446358E-03;
netsum += feature3[11] * -0.2078057;
netsum += feature3[12] * 4.059022E-02;
netsum += feature3[13] * -0.0172529;
netsum += feature3[14] * 0.1063812;
netsum += feature3[15] * 0.2702938;
netsum += feature3[16] * -4.067272E-02;
netsum += feature3[17] * -6.187136E-02;
netsum += feature3[18] * 0.1628981;
netsum += feature3[19] * 0.1099327;
netsum += -0.1309124;
netsum += feature4[0] * 0.426853;
netsum += feature4[1] * -0.4858257;
netsum += feature4[2] * 0.1228273;
netsum += feature4[3] * -1.283292;
netsum += feature4[4] * -0.2606785;
netsum += feature4[5] * 0.3335853;
netsum += feature4[6] * -0.4529989;
netsum += feature4[7] * -0.2577626;
netsum += feature4[8] * -0.3709499;
netsum += feature4[9] * 0.2795342;
netsum += feature4[10] * 0.3194565;
netsum += feature4[11] * -0.1699559;
netsum += feature4[12] * -3.707585E-02;
netsum += feature4[13] * -0.3658507;
netsum += feature4[14] * 0.1099212;
netsum += feature4[15] * -7.018337E-02;
netsum += feature4[16] * -0.598437;
netsum += feature4[17] * -0.344157;
netsum += feature4[18] * 4.352035E-02;
netsum += feature4[19] * 0.384508;
outarray[0] = 1 / (1 + exp(-netsum));


outarray[0] = 37.8 *  (outarray[0] - .1) / .8  + 0.1;
if (outarray[0]<0.1) outarray[0] = 0.1;
if (outarray[0]>37.9) outarray[0] = 37.9;

               
} /* end navistarCO2func() */
#endif
