/* Insert this code into your C program to fire the C:\NeuroShell 2\CmnsAllPosCO 04-04-02 network */
/* This code is designed to be simple and fast for porting to any machine */
/* Therefore all code and weights are inline without looping or data storage */
/*   which might be harder to port between compilers. */

/* 
% Neural Network Mex file for Use with ADVISOR: cumminsCO.c
%
% Data source: Testing by West Virginia University
%
% Data confidence level:  no comparison has been performed
%
% Notes:  Neural Network predicts CO emissions of 
% Cummins ISM 370 CI Engine (model year 1999) 6 cylinder, 10.8 L, 370 HP, peak torque 995 Nm@1200 rpm,
% governed speed of 2100 rpm
%
% Created on:  05 April 2002
% By:  Michael O'Keefe, National Renewable Energy Laboratory, Michael_OKeefe@nrel.gov
%
% Revision history at end of file.
*/

#include <math.h>
#include "mex.h"

void cumminsCO(double *inarray, double *outarray)
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

inarray[0] =  2 * (inarray[0] - 367.0703) / 1794.497 -1;

inarray[1] =  2 * (inarray[1] + 182.4661) / 341.5552 -1;

inarray[2] =  2 * (inarray[2] + 95.71754) / 213.7816 -1;

inarray[3] =  2 * (inarray[3] + 226.2746) / 1998.555 -1;

inarray[4] =  2 * (inarray[4] + 362.0183) / 715.5645 -1;

inarray[5] =  2 * (inarray[5] + 179.5587) / 349.8234 -1;

netsum = -0.4476136;
netsum += inarray[0] * 0.3310176;
netsum += inarray[1] * 0.1752501;
netsum += inarray[2] * -5.195923E-02;
netsum += inarray[3] * 2.401437E-02;
netsum += inarray[4] * -0.2361246;
netsum += inarray[5] * 5.362022E-02;
feature2[0] = tanh(netsum);

netsum = -1.894027E-02;
netsum += inarray[0] * -0.0899324;
netsum += inarray[1] * 0.1290638;
netsum += inarray[2] * -0.2853578;
netsum += inarray[3] * -2.614031E-02;
netsum += inarray[4] * 0.2581937;
netsum += inarray[5] * -6.215788E-02;
feature2[1] = tanh(netsum);

netsum = -0.3867925;
netsum += inarray[0] * -0.2662052;
netsum += inarray[1] * 0.2058507;
netsum += inarray[2] * 0.0429896;
netsum += inarray[3] * 0.1285328;
netsum += inarray[4] * -0.2474044;
netsum += inarray[5] * -0.2686615;
feature2[2] = tanh(netsum);

netsum = 0.3258351;
netsum += inarray[0] * -0.2516289;
netsum += inarray[1] * 0.3361826;
netsum += inarray[2] * -0.2127973;
netsum += inarray[3] * 0.1110867;
netsum += inarray[4] * 0.31266;
netsum += inarray[5] * 0.1697951;
feature2[3] = tanh(netsum);

netsum = 0.1050454;
netsum += inarray[0] * -0.289599;
netsum += inarray[1] * 2.198881E-02;
netsum += inarray[2] * -0.3558618;
netsum += inarray[3] * 4.407008E-02;
netsum += inarray[4] * 0.1636663;
netsum += inarray[5] * 0.1333333;
feature2[4] = tanh(netsum);

netsum = -0.3162074;
netsum += inarray[0] * -0.2719708;
netsum += inarray[1] * -0.3569578;
netsum += inarray[2] * 0.1733154;
netsum += inarray[3] * -5.286982E-02;
netsum += inarray[4] * -0.2350978;
netsum += inarray[5] * 3.220032E-02;
feature2[5] = tanh(netsum);

netsum = -0.1758973;
netsum += inarray[0] * 5.954291E-02;
netsum += inarray[1] * -4.683238E-02;
netsum += inarray[2] * -0.1257004;
netsum += inarray[3] * -0.2967366;
netsum += inarray[4] * -3.736195E-02;
netsum += inarray[5] * 9.074376E-02;
feature2[6] = tanh(netsum);

netsum = 0.351068;
netsum += inarray[0] * 4.601394E-02;
netsum += inarray[1] * -0.1130925;
netsum += inarray[2] * -0.1083404;
netsum += inarray[3] * -0.1495688;
netsum += inarray[4] * -0.2305199;
netsum += inarray[5] * 4.685413E-02;
feature2[7] = tanh(netsum);

netsum = 0.3309367;
netsum += inarray[0] * 0.1301173;
netsum += inarray[1] * 0.288054;
netsum += inarray[2] * 0.143871;
netsum += inarray[3] * -2.726265E-02;
netsum += inarray[4] * 0.3172244;
netsum += inarray[5] * -0.129724;
feature2[8] = tanh(netsum);

netsum = 0.328468;
netsum += inarray[0] * 0.1617905;
netsum += inarray[1] * -0.1066402;
netsum += inarray[2] * 0.2360455;
netsum += inarray[3] * 0.1341208;
netsum += inarray[4] * 0.1883512;
netsum += inarray[5] * -1.734828E-02;
feature2[9] = tanh(netsum);

netsum = -0.6722606;
netsum += inarray[0] * -0.4423692;
netsum += inarray[1] * 7.591745E-02;
netsum += inarray[2] * 0.1720167;
netsum += inarray[3] * -0.1074658;
netsum += inarray[4] * -0.4349464;
netsum += inarray[5] * 0.1761569;
feature2[10] = tanh(netsum);

netsum = 0.3924476;
netsum += inarray[0] * 0.0608625;
netsum += inarray[1] * 0.3004642;
netsum += inarray[2] * 0.199073;
netsum += inarray[3] * 0.4191951;
netsum += inarray[4] * 0.1388875;
netsum += inarray[5] * -0.1923139;
feature2[11] = tanh(netsum);

netsum = 0.2847287;
netsum += inarray[0] * 2.948242E-02;
netsum += inarray[1] * 0.4014344;
netsum += inarray[2] * 7.574911E-02;
netsum += inarray[3] * 0.1771106;
netsum += inarray[4] * 0.2641418;
netsum += inarray[5] * 0.1620935;
feature2[12] = tanh(netsum);

netsum = 3.301931E-02;
netsum += inarray[0] * -8.342991E-02;
netsum += inarray[1] * 0.3281491;
netsum += inarray[2] * -0.1472147;
netsum += inarray[3] * -0.1014783;
netsum += inarray[4] * 5.657034E-02;
netsum += inarray[5] * 0.1274825;
feature2[13] = tanh(netsum);

netsum = -0.3404528;
netsum += inarray[0] * -0.3548341;
netsum += inarray[1] * -3.490974E-02;
netsum += inarray[2] * 9.101991E-02;
netsum += inarray[3] * -0.195155;
netsum += inarray[4] * -0.3248235;
netsum += inarray[5] * -9.609048E-02;
feature2[14] = tanh(netsum);

netsum = -0.4606949;
netsum += inarray[0] * 0.1150089;
netsum += inarray[1] * -7.588478E-02;
netsum += inarray[2] * -5.276518E-02;
netsum += inarray[3] * 0.1771609;
netsum += inarray[4] * -0.2350614;
netsum += inarray[5] * -0.3342406;
feature2[15] = tanh(netsum);

netsum = -0.3942233;
netsum += inarray[0] * -5.205522E-02;
netsum += inarray[1] * -0.1443895;
netsum += inarray[2] * -0.1361821;
netsum += inarray[3] * 0.2298767;
netsum += inarray[4] * 0.3590625;
netsum += inarray[5] * 0.4067146;
feature2[16] = tanh(netsum);

netsum = -0.1255241;
netsum += inarray[0] * 0.2154751;
netsum += inarray[1] * -0.1337962;
netsum += inarray[2] * 0.3278812;
netsum += inarray[3] * -0.2701457;
netsum += inarray[4] * -4.190225E-02;
netsum += inarray[5] * 0.2667899;
feature2[17] = tanh(netsum);

netsum = -0.3349035;
netsum += inarray[0] * 7.652968E-02;
netsum += inarray[1] * 0.1632823;
netsum += inarray[2] * 0.1304546;
netsum += inarray[3] * 8.859627E-02;
netsum += inarray[4] * -0.212418;
netsum += inarray[5] * -6.382043E-02;
feature2[18] = tanh(netsum);

netsum = -0.3256131;
netsum += inarray[0] * -0.1379603;
netsum += inarray[1] * -0.3427956;
netsum += inarray[2] * -0.3173006;
netsum += inarray[3] * -1.573937E-02;
netsum += inarray[4] * -9.523318E-03;
netsum += inarray[5] * -0.2187365;
feature2[19] = tanh(netsum);

netsum = -0.2127167;
netsum += inarray[0] * -0.1963431;
netsum += inarray[1] * -0.1802096;
netsum += inarray[2] * -0.2832831;
netsum += inarray[3] * 0.1087853;
netsum += inarray[4] * 7.088649E-02;
netsum += inarray[5] * -6.093854E-02;
feature3[0] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.2166327;
netsum += inarray[0] * -0.3525123;
netsum += inarray[1] * 4.991593E-02;
netsum += inarray[2] * 0.2066689;
netsum += inarray[3] * 5.994089E-02;
netsum += inarray[4] * 0.135865;
netsum += inarray[5] * -4.809501E-02;
feature3[1] = 2 / (1 + exp(-netsum)) - 1;

netsum = 9.404926E-02;
netsum += inarray[0] * -0.2989646;
netsum += inarray[1] * 1.483952E-02;
netsum += inarray[2] * -0.1649989;
netsum += inarray[3] * 0.2709948;
netsum += inarray[4] * -0.2659851;
netsum += inarray[5] * -0.1272591;
feature3[2] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.1214704;
netsum += inarray[0] * 0.2233239;
netsum += inarray[1] * 9.751362E-02;
netsum += inarray[2] * -0.1254938;
netsum += inarray[3] * -0.1729919;
netsum += inarray[4] * 0.1049544;
netsum += inarray[5] * -5.904102E-03;
feature3[3] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.2120904;
netsum += inarray[0] * 0.2753894;
netsum += inarray[1] * -0.1975257;
netsum += inarray[2] * 0.2090618;
netsum += inarray[3] * -0.244315;
netsum += inarray[4] * 0.2786963;
netsum += inarray[5] * 4.763126E-03;
feature3[4] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.2292694;
netsum += inarray[0] * -0.1754689;
netsum += inarray[1] * 0.0128312;
netsum += inarray[2] * -0.0548577;
netsum += inarray[3] * 0.0605987;
netsum += inarray[4] * -0.1047045;
netsum += inarray[5] * -0.2047693;
feature3[5] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.2647122;
netsum += inarray[0] * -0.2225055;
netsum += inarray[1] * 0.2683817;
netsum += inarray[2] * -0.1769941;
netsum += inarray[3] * 9.223205E-02;
netsum += inarray[4] * 3.780447E-02;
netsum += inarray[5] * -0.1373244;
feature3[6] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.2607338;
netsum += inarray[0] * 5.195002E-02;
netsum += inarray[1] * 0.1078701;
netsum += inarray[2] * 0.0864347;
netsum += inarray[3] * 3.787418E-02;
netsum += inarray[4] * -0.1213253;
netsum += inarray[5] * 0.1299252;
feature3[7] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.1509683;
netsum += inarray[0] * -0.3536;
netsum += inarray[1] * 0.2596298;
netsum += inarray[2] * 0.0326792;
netsum += inarray[3] * -6.666759E-02;
netsum += inarray[4] * -0.197464;
netsum += inarray[5] * -0.1090929;
feature3[8] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.140615;
netsum += inarray[0] * -0.2613657;
netsum += inarray[1] * -0.2043155;
netsum += inarray[2] * -6.365569E-02;
netsum += inarray[3] * 2.579869E-03;
netsum += inarray[4] * -0.2408777;
netsum += inarray[5] * 0.1745151;
feature3[9] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.3090016;
netsum += inarray[0] * -3.542019E-02;
netsum += inarray[1] * -8.287278E-02;
netsum += inarray[2] * -1.022226E-02;
netsum += inarray[3] * -0.245866;
netsum += inarray[4] * 0.2300773;
netsum += inarray[5] * 0.3044911;
feature3[10] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.1285886;
netsum += inarray[0] * 0.1990401;
netsum += inarray[1] * -0.191809;
netsum += inarray[2] * 8.738117E-02;
netsum += inarray[3] * 0.1228046;
netsum += inarray[4] * 0.2114633;
netsum += inarray[5] * 0.2209253;
feature3[11] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.1010863;
netsum += inarray[0] * 0.117272;
netsum += inarray[1] * 0.3007589;
netsum += inarray[2] * 9.624118E-02;
netsum += inarray[3] * 7.253879E-02;
netsum += inarray[4] * 0.1450023;
netsum += inarray[5] * 0.1475621;
feature3[12] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.2514319;
netsum += inarray[0] * 3.307648E-02;
netsum += inarray[1] * -3.998762E-02;
netsum += inarray[2] * 0.2059398;
netsum += inarray[3] * 6.423515E-02;
netsum += inarray[4] * -0.2150165;
netsum += inarray[5] * -0.1423186;
feature3[13] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.1575728;
netsum += inarray[0] * -0.2569849;
netsum += inarray[1] * 0.3115712;
netsum += inarray[2] * 0.2160012;
netsum += inarray[3] * 0.1225132;
netsum += inarray[4] * -0.1008858;
netsum += inarray[5] * 0.2886409;
feature3[14] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.2265925;
netsum += inarray[0] * -8.296683E-02;
netsum += inarray[1] * -0.2420845;
netsum += inarray[2] * 3.790633E-02;
netsum += inarray[3] * 0.2311381;
netsum += inarray[4] * -0.2475924;
netsum += inarray[5] * -0.221181;
feature3[15] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.1248816;
netsum += inarray[0] * -0.1740497;
netsum += inarray[1] * 7.779688E-02;
netsum += inarray[2] * 0.1388845;
netsum += inarray[3] * -0.2253474;
netsum += inarray[4] * -0.2599261;
netsum += inarray[5] * -0.2702005;
feature3[16] = 2 / (1 + exp(-netsum)) - 1;

netsum = 7.954898E-02;
netsum += inarray[0] * 0.1359067;
netsum += inarray[1] * -0.2359469;
netsum += inarray[2] * 5.556536E-02;
netsum += inarray[3] * 4.205397E-02;
netsum += inarray[4] * 8.956171E-02;
netsum += inarray[5] * 0.1815037;
feature3[17] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.168297;
netsum += inarray[0] * -0.1584719;
netsum += inarray[1] * -3.507496E-02;
netsum += inarray[2] * -9.286426E-02;
netsum += inarray[3] * 0.246203;
netsum += inarray[4] * 0.1943262;
netsum += inarray[5] * 2.571096E-02;
feature3[18] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.1629307;
netsum += inarray[0] * -5.682419E-02;
netsum += inarray[1] * 0.2523063;
netsum += inarray[2] * -0.2099506;
netsum += inarray[3] * 0.2578562;
netsum += inarray[4] * 2.961151E-02;
netsum += inarray[5] * 6.109715E-02;
feature3[19] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.5280291;
netsum += inarray[0] * 0.5027615;
netsum += inarray[1] * 4.476096E-02;
netsum += inarray[2] * 0.1727245;
netsum += inarray[3] * -0.300114;
netsum += inarray[4] * 0.1085019;
netsum += inarray[5] * 0.2567664;
feature4[0] = tanh(1.5 * netsum);

netsum = -6.822899E-02;
netsum += inarray[0] * 0.2032826;
netsum += inarray[1] * -0.2163751;
netsum += inarray[2] * -0.3281189;
netsum += inarray[3] * -0.2450196;
netsum += inarray[4] * 0.238042;
netsum += inarray[5] * -0.4412134;
feature4[1] = tanh(1.5 * netsum);

netsum = -0.5551144;
netsum += inarray[0] * -0.1406209;
netsum += inarray[1] * -0.1546869;
netsum += inarray[2] * -0.2687985;
netsum += inarray[3] * 6.771986E-02;
netsum += inarray[4] * 0.2245713;
netsum += inarray[5] * -0.3039937;
feature4[2] = tanh(1.5 * netsum);

netsum = 0.7081068;
netsum += inarray[0] * 0.7939626;
netsum += inarray[1] * 0.8534906;
netsum += inarray[2] * -1.326877;
netsum += inarray[3] * -0.1294345;
netsum += inarray[4] * 1.296621;
netsum += inarray[5] * -0.6729105;
feature4[3] = tanh(1.5 * netsum);

netsum = -0.1404789;
netsum += inarray[0] * -1.234502;
netsum += inarray[1] * 0.3575107;
netsum += inarray[2] * 4.310929E-02;
netsum += inarray[3] * -0.5410336;
netsum += inarray[4] * 0.4008828;
netsum += inarray[5] * -0.4459039;
feature4[4] = tanh(1.5 * netsum);

netsum = -0.3933078;
netsum += inarray[0] * -9.312454E-02;
netsum += inarray[1] * 2.426896E-02;
netsum += inarray[2] * -0.4350739;
netsum += inarray[3] * -0.1802133;
netsum += inarray[4] * -0.4975087;
netsum += inarray[5] * -8.327097E-02;
feature4[5] = tanh(1.5 * netsum);

netsum = 0.2622616;
netsum += inarray[0] * -7.668743E-02;
netsum += inarray[1] * -1.022445;
netsum += inarray[2] * -1.340178;
netsum += inarray[3] * 0.3342811;
netsum += inarray[4] * -0.3861185;
netsum += inarray[5] * -0.8067337;
feature4[6] = tanh(1.5 * netsum);

netsum = -0.4263929;
netsum += inarray[0] * 0.3262443;
netsum += inarray[1] * 0.1144286;
netsum += inarray[2] * 0.258187;
netsum += inarray[3] * -0.3927883;
netsum += inarray[4] * 0.1536084;
netsum += inarray[5] * -7.504717E-02;
feature4[7] = tanh(1.5 * netsum);

netsum = 0.5944074;
netsum += inarray[0] * 8.262286E-02;
netsum += inarray[1] * 8.370181E-02;
netsum += inarray[2] * 0.3429931;
netsum += inarray[3] * -0.1748786;
netsum += inarray[4] * -0.4739658;
netsum += inarray[5] * 0.4550289;
feature4[8] = tanh(1.5 * netsum);

netsum = -6.846026E-02;
netsum += inarray[0] * 1.221164;
netsum += inarray[1] * 0.1944619;
netsum += inarray[2] * 0.549284;
netsum += inarray[3] * -0.1343279;
netsum += inarray[4] * -0.8820813;
netsum += inarray[5] * -0.2326743;
feature4[9] = tanh(1.5 * netsum);

netsum = 0.0809129;
netsum += inarray[0] * 0.1348164;
netsum += inarray[1] * -0.2024828;
netsum += inarray[2] * 0.2667048;
netsum += inarray[3] * 0.4407691;
netsum += inarray[4] * 0.3014015;
netsum += inarray[5] * 0.7880598;
feature4[10] = tanh(1.5 * netsum);

netsum = 0.9769298;
netsum += inarray[0] * 2.405075E-02;
netsum += inarray[1] * -0.2824394;
netsum += inarray[2] * 0.7998446;
netsum += inarray[3] * -0.5435835;
netsum += inarray[4] * -1.15774;
netsum += inarray[5] * 0.3229056;
feature4[11] = tanh(1.5 * netsum);

netsum = 0.2870511;
netsum += inarray[0] * -1.470369;
netsum += inarray[1] * 0.2340699;
netsum += inarray[2] * 0.4417478;
netsum += inarray[3] * -0.5390877;
netsum += inarray[4] * 0.9634678;
netsum += inarray[5] * 0.5621754;
feature4[12] = tanh(1.5 * netsum);

netsum = -1.272748;
netsum += inarray[0] * -0.1343579;
netsum += inarray[1] * -0.4399107;
netsum += inarray[2] * 0.4467365;
netsum += inarray[3] * -1.044164;
netsum += inarray[4] * 1.212377;
netsum += inarray[5] * 0.9209435;
feature4[13] = tanh(1.5 * netsum);

netsum = 0.6377102;
netsum += inarray[0] * 0.1936966;
netsum += inarray[1] * -8.148422E-02;
netsum += inarray[2] * -4.919619E-02;
netsum += inarray[3] * -0.1005662;
netsum += inarray[4] * 2.176321E-02;
netsum += inarray[5] * 0.1609467;
feature4[14] = tanh(1.5 * netsum);

netsum = 0.2171277;
netsum += inarray[0] * -0.2629767;
netsum += inarray[1] * 1.168559;
netsum += inarray[2] * 0.4966065;
netsum += inarray[3] * 0.4963672;
netsum += inarray[4] * 0.6158248;
netsum += inarray[5] * 0.5083223;
feature4[15] = tanh(1.5 * netsum);

netsum = -0.1603131;
netsum += inarray[0] * -0.3838133;
netsum += inarray[1] * -0.240807;
netsum += inarray[2] * -0.2869551;
netsum += inarray[3] * 5.304382E-02;
netsum += inarray[4] * -0.2940493;
netsum += inarray[5] * -0.4535162;
feature4[16] = tanh(1.5 * netsum);

netsum = -0.3522585;
netsum += inarray[0] * -0.3607131;
netsum += inarray[1] * -0.1579615;
netsum += inarray[2] * -0.2352532;
netsum += inarray[3] * -0.2671024;
netsum += inarray[4] * 0.279782;
netsum += inarray[5] * -5.158551E-02;
feature4[17] = tanh(1.5 * netsum);

netsum = -1.262553;
netsum += inarray[0] * -1.233947;
netsum += inarray[1] * 1.037065;
netsum += inarray[2] * -0.1787276;
netsum += inarray[3] * 0.2044888;
netsum += inarray[4] * -0.2542723;
netsum += inarray[5] * 0.9215064;
feature4[18] = tanh(1.5 * netsum);

netsum = -4.203023E-02;
netsum += inarray[0] * 0.2055688;
netsum += inarray[1] * -9.862898E-02;
netsum += inarray[2] * 0.4270696;
netsum += inarray[3] * 0.3981422;
netsum += inarray[4] * 0.3217502;
netsum += inarray[5] * 0.5476896;
feature4[19] = tanh(1.5 * netsum);

netsum = -7.227364E-02;
netsum += feature2[0] * -0.1074022;
netsum += feature2[1] * 0.1138955;
netsum += feature2[2] * -0.0402135;
netsum += feature2[3] * 4.000732E-02;
netsum += feature2[4] * 5.446662E-02;
netsum += feature2[5] * 0.1069765;
netsum += feature2[6] * -6.531706E-02;
netsum += feature2[7] * 2.313184E-02;
netsum += feature2[8] * 9.207441E-03;
netsum += feature2[9] * -0.1017999;
netsum += feature2[10] * 0.1851426;
netsum += feature2[11] * 0.1353421;
netsum += feature2[12] * -3.181901E-02;
netsum += feature2[13] * 0.0399802;
netsum += feature2[14] * 0.1326634;
netsum += feature2[15] * -0.1628723;
netsum += feature2[16] * 5.920979E-02;
netsum += feature2[17] * -0.1170718;
netsum += feature2[18] * -0.1232513;
netsum += feature2[19] * 2.902944E-02;
netsum += 0.2183668;
netsum += feature3[0] * -0.1067909;
netsum += feature3[1] * 0.1995754;
netsum += feature3[2] * 0.1719656;
netsum += feature3[3] * -0.1126805;
netsum += feature3[4] * -0.269825;
netsum += feature3[5] * 5.323652E-02;
netsum += feature3[6] * -4.511452E-02;
netsum += feature3[7] * -0.108529;
netsum += feature3[8] * 0.2335067;
netsum += feature3[9] * 7.839732E-02;
netsum += feature3[10] * 6.775925E-02;
netsum += feature3[11] * -0.1952595;
netsum += feature3[12] * -3.258206E-02;
netsum += feature3[13] * -7.611435E-02;
netsum += feature3[14] * 5.297588E-03;
netsum += feature3[15] * 0.1637626;
netsum += feature3[16] * -1.324109E-03;
netsum += feature3[17] * -7.424973E-02;
netsum += feature3[18] * 0.144706;
netsum += feature3[19] * 7.489504E-02;
netsum += -0.3366729;
netsum += feature4[0] * 0.1668622;
netsum += feature4[1] * 0.1185609;
netsum += feature4[2] * 0.1036596;
netsum += feature4[3] * -1.08214;
netsum += feature4[4] * -0.3935391;
netsum += feature4[5] * 0.1340917;
netsum += feature4[6] * -0.6063204;
netsum += feature4[7] * -0.1973476;
netsum += feature4[8] * -0.2820922;
netsum += feature4[9] * 0.5554369;
netsum += feature4[10] * 0.2825599;
netsum += feature4[11] * -0.7936514;
netsum += feature4[12] * 0.4950723;
netsum += feature4[13] * -1.262146;
netsum += feature4[14] * 4.056804E-02;
netsum += feature4[15] * -0.7415621;
netsum += feature4[16] * 3.343021E-02;
netsum += feature4[17] * -3.948854E-02;
netsum += feature4[18] * 1.006092;
netsum += feature4[19] * 0.2099238;
outarray[0] = 1 / (1 + exp(-netsum));


outarray[0] = 0.3 *  (outarray[0] - .1) / .8 ;
if (outarray[0]<0) outarray[0] = 0;
if (outarray[0]>0.3) outarray[0] = 0.3;


}/* end cumminsCO() */

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
    /* Call the cumminsCO function. */
    cumminsCO(&inarray[currIndex],&tmp);
    outarray[i]=tmp; /* assign to outarray */
  }
} /* end mexFunction() */

/* 
to test:
out=cumminsCO([[60:70];diff([60:71]);diff([60:71]);[60:70];diff([60:71]);diff([60:71])]) 
*/