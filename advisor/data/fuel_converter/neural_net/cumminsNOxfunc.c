#ifndef cumminsNOxfunc_c
#define cumminsNOxfunc_c
/* Insert this code into your C program to fire the 
    C:\NeuroShell 2\CmnsAllPosNOx 04-04-02 network */
/* This code is designed to be simple and fast for porting to any machine */
/* Therefore all code and weights are inline without looping or data storage */
/*   which might be harder to port between compilers. */

/* 
% Neural Network Mex file for Use with ADVISOR: cumminsNOxfunc.c
%
% Data source: Testing by West Virginia University
%
% Data confidence level:  no comparison has been performed
%
% Notes:  Neural Network predicts NOx emissions of Cummins CI Engine
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

void cumminsNOxfunc(double *inarray, double *outarray)
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

inarray[0] =  2 * (inarray[0] - 367.0703) / 1794.497 -1;

inarray[1] =  2 * (inarray[1] + 182.4661) / 341.5552 -1;

inarray[2] =  2 * (inarray[2] + 95.71754) / 213.7816 -1;

inarray[3] =  2 * (inarray[3] + 226.2746) / 1998.555 -1;

inarray[4] =  2 * (inarray[4] + 362.0183) / 715.5645 -1;

inarray[5] =  2 * (inarray[5] + 179.5587) / 349.8234 -1;

netsum = -1.16476;
netsum += inarray[0] * -0.1449175;
netsum += inarray[1] * 0.1807681;
netsum += inarray[2] * -1.132235E-02;
netsum += inarray[3] * -0.3665499;
netsum += inarray[4] * -0.1986626;
netsum += inarray[5] * 7.447707E-02;
feature2[0] = tanh(netsum);

netsum = 0.7273005;
netsum += inarray[0] * 0.5230953;
netsum += inarray[1] * 0.228047;
netsum += inarray[2] * -0.483307;
netsum += inarray[3] * 0.4090267;
netsum += inarray[4] * 0.4559508;
netsum += inarray[5] * 6.773045E-02;
feature2[1] = tanh(netsum);

netsum = -0.9086496;
netsum += inarray[0] * -0.7478838;
netsum += inarray[1] * 0.1902613;
netsum += inarray[2] * 0.1627522;
netsum += inarray[3] * -0.2502607;
netsum += inarray[4] * -0.2844416;
netsum += inarray[5] * -0.2288394;
feature2[2] = tanh(netsum);

netsum = 1.017604;
netsum += inarray[0] * 0.2140239;
netsum += inarray[1] * 0.3334369;
netsum += inarray[2] * -0.3793828;
netsum += inarray[3] * 0.5237837;
netsum += inarray[4] * 0.2907672;
netsum += inarray[5] * 0.1399952;
feature2[3] = tanh(netsum);

netsum = -0.4347494;
netsum += inarray[0] * -0.8390742;
netsum += inarray[1] * -2.903293E-03;
netsum += inarray[2] * -0.2194363;
netsum += inarray[3] * -0.4290437;
netsum += inarray[4] * -2.675449E-02;
netsum += inarray[5] * 3.20105E-03;
feature2[4] = tanh(netsum);

netsum = -0.8390128;
netsum += inarray[0] * -0.4748633;
netsum += inarray[1] * -0.2453533;
netsum += inarray[2] * 0.2566584;
netsum += inarray[3] * -0.3587011;
netsum += inarray[4] * -0.1061206;
netsum += inarray[5] * 4.183766E-02;
feature2[5] = tanh(netsum);

netsum = -0.6162658;
netsum += inarray[0] * -0.3890783;
netsum += inarray[1] * -0.0400741;
netsum += inarray[2] * -6.312767E-02;
netsum += inarray[3] * -0.8143687;
netsum += inarray[4] * -9.308763E-02;
netsum += inarray[5] * 8.182206E-02;
feature2[6] = tanh(netsum);

netsum = 1.034684;
netsum += inarray[0] * 0.6039133;
netsum += inarray[1] * -8.392154E-02;
netsum += inarray[2] * -0.2105849;
netsum += inarray[3] * 0.2606432;
netsum += inarray[4] * -0.1980352;
netsum += inarray[5] * 0.1110549;
feature2[7] = tanh(netsum);

netsum = 0.9876034;
netsum += inarray[0] * 0.5606674;
netsum += inarray[1] * 0.2532609;
netsum += inarray[2] * -2.985209E-02;
netsum += inarray[3] * 0.3223388;
netsum += inarray[4] * 0.3940661;
netsum += inarray[5] * -0.116619;
feature2[8] = tanh(netsum);

netsum = 0.9148973;
netsum += inarray[0] * 0.4678285;
netsum += inarray[1] * -0.1409886;
netsum += inarray[2] * 0.1072965;
netsum += inarray[3] * 0.5696473;
netsum += inarray[4] * 8.612846E-02;
netsum += inarray[5] * 2.895703E-02;
feature2[9] = tanh(netsum);

netsum = -0.9813698;
netsum += inarray[0] * -0.6665763;
netsum += inarray[1] * 9.838653E-02;
netsum += inarray[2] * 0.1944671;
netsum += inarray[3] * -0.3507825;
netsum += inarray[4] * -0.2353287;
netsum += inarray[5] * 7.658689E-02;
feature2[10] = tanh(netsum);

netsum = 0.6534418;
netsum += inarray[0] * 0.3429901;
netsum += inarray[1] * 0.2279942;
netsum += inarray[2] * 6.998679E-02;
netsum += inarray[3] * 0.9090097;
netsum += inarray[4] * 0.3512944;
netsum += inarray[5] * -0.2008388;
feature2[11] = tanh(netsum);

netsum = 0.8599541;
netsum += inarray[0] * 0.4409243;
netsum += inarray[1] * 0.3530341;
netsum += inarray[2] * -9.277236E-02;
netsum += inarray[3] * 0.611836;
netsum += inarray[4] * 0.2232369;
netsum += inarray[5] * 0.1296852;
feature2[12] = tanh(netsum);

netsum = 0.3937167;
netsum += inarray[0] * 0.1093307;
netsum += inarray[1] * 0.36638;
netsum += inarray[2] * -0.1845376;
netsum += inarray[3] * -5.478407E-03;
netsum += inarray[4] * 8.939502E-02;
netsum += inarray[5] * 0.253444;
feature2[13] = tanh(netsum);

netsum = -0.8087175;
netsum += inarray[0] * -0.7487522;
netsum += inarray[1] * 8.253905E-03;
netsum += inarray[2] * 0.1375763;
netsum += inarray[3] * -0.6171936;
netsum += inarray[4] * -0.1902241;
netsum += inarray[5] * -0.1696873;
feature2[14] = tanh(netsum);

netsum = -1.05331;
netsum += inarray[0] * -0.4252438;
netsum += inarray[1] * -0.1778998;
netsum += inarray[2] * 0.1606897;
netsum += inarray[3] * -0.5255667;
netsum += inarray[4] * -0.257596;
netsum += inarray[5] * -0.3454484;
feature2[15] = tanh(netsum);

netsum = -1.578013;
netsum += inarray[0] * 0.1771415;
netsum += inarray[1] * -0.3272697;
netsum += inarray[2] * -0.1807293;
netsum += inarray[3] * 2.541097E-02;
netsum += inarray[4] * 0.4332318;
netsum += inarray[5] * 3.236147E-02;
feature2[16] = tanh(netsum);

netsum = -0.7787634;
netsum += inarray[0] * -0.1865407;
netsum += inarray[1] * -0.1334882;
netsum += inarray[2] * 0.4657256;
netsum += inarray[3] * -0.7801035;
netsum += inarray[4] * -5.011237E-02;
netsum += inarray[5] * 0.1903791;
feature2[17] = tanh(netsum);

netsum = -0.9034649;
netsum += inarray[0] * -0.5235555;
netsum += inarray[1] * 0.1900478;
netsum += inarray[2] * 0.4168977;
netsum += inarray[3] * -0.419822;
netsum += inarray[4] * -0.3832814;
netsum += inarray[5] * -7.973979E-02;
feature2[18] = tanh(netsum);

netsum = -0.9328582;
netsum += inarray[0] * -0.6244296;
netsum += inarray[1] * -0.3405886;
netsum += inarray[2] * -0.1962593;
netsum += inarray[3] * -0.4250652;
netsum += inarray[4] * -2.540136E-02;
netsum += inarray[5] * -0.2142263;
feature2[19] = tanh(netsum);

netsum = -0.4987966;
netsum += inarray[0] * -0.5211087;
netsum += inarray[1] * -0.1695467;
netsum += inarray[2] * -0.2020912;
netsum += inarray[3] * -9.999392E-02;
netsum += inarray[4] * -2.984002E-02;
netsum += inarray[5] * -5.263922E-02;
feature3[0] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.3379442;
netsum += inarray[0] * -0.1564397;
netsum += inarray[1] * 4.710863E-02;
netsum += inarray[2] * 0.1876608;
netsum += inarray[3] * 0.2084475;
netsum += inarray[4] * 0.1951214;
netsum += inarray[5] * -6.555779E-02;
feature3[1] = 2 / (1 + exp(-netsum)) - 1;

netsum = 8.672649E-02;
netsum += inarray[0] * -0.2314031;
netsum += inarray[1] * 2.103237E-02;
netsum += inarray[2] * -0.1592724;
netsum += inarray[3] * 0.3139364;
netsum += inarray[4] * -0.2671273;
netsum += inarray[5] * -0.1475342;
feature3[2] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.3078339;
netsum += inarray[0] * 0.2862973;
netsum += inarray[1] * 8.895126E-02;
netsum += inarray[2] * -0.1584143;
netsum += inarray[3] * -0.1072012;
netsum += inarray[4] * 9.708288E-02;
netsum += inarray[5] * 0.0147886;
feature3[3] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.411903;
netsum += inarray[0] * -1.329537E-02;
netsum += inarray[1] * -0.2162073;
netsum += inarray[2] * 0.2390588;
netsum += inarray[3] * -0.4324189;
netsum += inarray[4] * 0.2134033;
netsum += inarray[5] * -2.752309E-03;
feature3[4] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.3701139;
netsum += inarray[0] * -9.429017E-02;
netsum += inarray[1] * 1.687995E-02;
netsum += inarray[2] * -7.070339E-02;
netsum += inarray[3] * 0.135681;
netsum += inarray[4] * -0.1264154;
netsum += inarray[5] * -0.2048863;
feature3[5] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.5505068;
netsum += inarray[0] * -0.5018393;
netsum += inarray[1] * 0.2774904;
netsum += inarray[2] * -0.1339064;
netsum += inarray[3] * -0.1124817;
netsum += inarray[4] * -2.372995E-02;
netsum += inarray[5] * -0.1128511;
feature3[6] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.5035046;
netsum += inarray[0] * -0.1850033;
netsum += inarray[1] * 0.1225144;
netsum += inarray[2] * 0.1284599;
netsum += inarray[3] * -0.1460361;
netsum += inarray[4] * -0.1751649;
netsum += inarray[5] * 0.1546052;
feature3[7] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.1474735;
netsum += inarray[0] * -0.2357244;
netsum += inarray[1] * 0.2774569;
netsum += inarray[2] * 0.0327885;
netsum += inarray[3] * -4.178123E-02;
netsum += inarray[4] * -0.1664096;
netsum += inarray[5] * -0.1067565;
feature3[8] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.3851621;
netsum += inarray[0] * -0.4274765;
netsum += inarray[1] * -0.1811798;
netsum += inarray[2] * -3.975299E-03;
netsum += inarray[3] * -0.1658064;
netsum += inarray[4] * -0.277105;
netsum += inarray[5] * 0.1965558;
feature3[9] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.5677181;
netsum += inarray[0] * 0.1728706;
netsum += inarray[1] * -7.796853E-02;
netsum += inarray[2] * -4.628129E-02;
netsum += inarray[3] * -9.977008E-02;
netsum += inarray[4] * 0.2669208;
netsum += inarray[5] * 0.332352;
feature3[10] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.1670316;
netsum += inarray[0] * 6.069103E-02;
netsum += inarray[1] * -0.2072611;
netsum += inarray[2] * 9.383678E-02;
netsum += inarray[3] * 9.003658E-02;
netsum += inarray[4] * 0.1786762;
netsum += inarray[5] * 0.241683;
feature3[11] = 2 / (1 + exp(-netsum)) - 1;

netsum = -8.942997E-02;
netsum += inarray[0] * 0.1482483;
netsum += inarray[1] * 0.2938887;
netsum += inarray[2] * 7.824691E-02;
netsum += inarray[3] * 0.1028958;
netsum += inarray[4] * 0.1775052;
netsum += inarray[5] * 0.1425894;
feature3[12] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.5220894;
netsum += inarray[0] * -0.1973107;
netsum += inarray[1] * -3.510033E-02;
netsum += inarray[2] * 0.259055;
netsum += inarray[3] * -0.1155481;
netsum += inarray[4] * -0.2653382;
netsum += inarray[5] * -0.1474739;
feature3[13] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.2403937;
netsum += inarray[0] * -0.2480179;
netsum += inarray[1] * 0.3471906;
netsum += inarray[2] * 0.2139414;
netsum += inarray[3] * 0.1366539;
netsum += inarray[4] * -0.1191114;
netsum += inarray[5] * 0.349154;
feature3[14] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.4001542;
netsum += inarray[0] * 0.1519236;
netsum += inarray[1] * -0.254677;
netsum += inarray[2] * 1.549295E-02;
netsum += inarray[3] * 0.4099329;
netsum += inarray[4] * -0.2046658;
netsum += inarray[5] * -0.2702973;
feature3[15] = 2 / (1 + exp(-netsum)) - 1;

netsum = 8.806092E-02;
netsum += inarray[0] * -0.2698386;
netsum += inarray[1] * 0.1088166;
netsum += inarray[2] * 0.1648394;
netsum += inarray[3] * -0.3295577;
netsum += inarray[4] * -0.301318;
netsum += inarray[5] * -0.2168628;
feature3[16] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.2138964;
netsum += inarray[0] * 0.198427;
netsum += inarray[1] * -0.2461311;
netsum += inarray[2] * 3.493697E-02;
netsum += inarray[3] * 0.1263625;
netsum += inarray[4] * 8.872706E-02;
netsum += inarray[5] * 0.1866154;
feature3[17] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.3765291;
netsum += inarray[0] * 7.550788E-02;
netsum += inarray[1] * -5.876968E-02;
netsum += inarray[2] * -0.1405548;
netsum += inarray[3] * 0.465081;
netsum += inarray[4] * 0.2628486;
netsum += inarray[5] * -1.848758E-02;
feature3[18] = 2 / (1 + exp(-netsum)) - 1;

netsum = -0.2195091;
netsum += inarray[0] * -3.001456E-02;
netsum += inarray[1] * 0.242274;
netsum += inarray[2] * -0.2086998;
netsum += inarray[3] * 0.2778305;
netsum += inarray[4] * 0.0640683;
netsum += inarray[5] * 4.121444E-02;
feature3[19] = 2 / (1 + exp(-netsum)) - 1;

netsum = 0.9995733;
netsum += inarray[0] * 1.779871;
netsum += inarray[1] * 0.389796;
netsum += inarray[2] * 0.8233953;
netsum += inarray[3] * -0.6196861;
netsum += inarray[4] * -0.7459354;
netsum += inarray[5] * -0.1310656;
feature4[0] = tanh(1.5 * netsum);

netsum = -0.5422934;
netsum += inarray[0] * -0.1991782;
netsum += inarray[1] * -0.5522863;
netsum += inarray[2] * -0.5962456;
netsum += inarray[3] * -0.8865439;
netsum += inarray[4] * 0.2562874;
netsum += inarray[5] * -0.5470524;
feature4[1] = tanh(1.5 * netsum);

netsum = -0.6241033;
netsum += inarray[0] * -0.8688831;
netsum += inarray[1] * 0.1511206;
netsum += inarray[2] * -2.724824E-03;
netsum += inarray[3] * -0.8950544;
netsum += inarray[4] * -0.1087441;
netsum += inarray[5] * 0.2761037;
feature4[2] = tanh(1.5 * netsum);

netsum = 3.513779;
netsum += inarray[0] * -2.279087;
netsum += inarray[1] * -1.223757;
netsum += inarray[2] * -3.740658E-02;
netsum += inarray[3] * -2.12959;
netsum += inarray[4] * 1.31363;
netsum += inarray[5] * -0.5318566;
feature4[3] = tanh(1.5 * netsum);

netsum = -0.8371187;
netsum += inarray[0] * -0.3221342;
netsum += inarray[1] * -0.1976579;
netsum += inarray[2] * 0.1428983;
netsum += inarray[3] * -0.9121368;
netsum += inarray[4] * 2.762017E-02;
netsum += inarray[5] * -0.5767658;
feature4[4] = tanh(1.5 * netsum);

netsum = 0.7144471;
netsum += inarray[0] * 0.7403618;
netsum += inarray[1] * 1.046417;
netsum += inarray[2] * -0.6772559;
netsum += inarray[3] * -0.2062731;
netsum += inarray[4] * -0.8606434;
netsum += inarray[5] * 0.8513752;
feature4[5] = tanh(1.5 * netsum);

netsum = 1.296356;
netsum += inarray[0] * -0.1863166;
netsum += inarray[1] * 0.2908974;
netsum += inarray[2] * -7.786506E-02;
netsum += inarray[3] * -0.4702086;
netsum += inarray[4] * -0.9609934;
netsum += inarray[5] * -0.6298849;
feature4[6] = tanh(1.5 * netsum);

netsum = -0.3660636;
netsum += inarray[0] * 0.4799878;
netsum += inarray[1] * 2.8704;
netsum += inarray[2] * 4.357143;
netsum += inarray[3] * 0.225549;
netsum += inarray[4] * -4.668816E-02;
netsum += inarray[5] * -0.1365127;
feature4[7] = tanh(1.5 * netsum);

netsum = 0.4166017;
netsum += inarray[0] * 1.535694;
netsum += inarray[1] * 0.3125215;
netsum += inarray[2] * 1.055047;
netsum += inarray[3] * -1.394253;
netsum += inarray[4] * 0.1978296;
netsum += inarray[5] * 0.8906843;
feature4[8] = tanh(1.5 * netsum);

netsum = 0.9988114;
netsum += inarray[0] * 0.6998251;
netsum += inarray[1] * 0.4005711;
netsum += inarray[2] * 7.638311E-02;
netsum += inarray[3] * 0.0187459;
netsum += inarray[4] * -0.1591637;
netsum += inarray[5] * -7.035755E-02;
feature4[9] = tanh(1.5 * netsum);

netsum = -1.471767;
netsum += inarray[0] * 0.1768145;
netsum += inarray[1] * -0.2093821;
netsum += inarray[2] * -1.426713E-03;
netsum += inarray[3] * 4.672345E-02;
netsum += inarray[4] * 0.2773115;
netsum += inarray[5] * 4.701225E-02;
feature4[10] = tanh(1.5 * netsum);

netsum = 0.9706695;
netsum += inarray[0] * 0.5536398;
netsum += inarray[1] * 0.1234346;
netsum += inarray[2] * 0.2493996;
netsum += inarray[3] * -3.768539E-02;
netsum += inarray[4] * -0.1428144;
netsum += inarray[5] * 0.315592;
feature4[11] = tanh(1.5 * netsum);

netsum = 1.54029;
netsum += inarray[0] * -0.9680094;
netsum += inarray[1] * 0.1102359;
netsum += inarray[2] * -0.3503889;
netsum += inarray[3] * -1.789317;
netsum += inarray[4] * 1.394279;
netsum += inarray[5] * 1.083453;
feature4[12] = tanh(1.5 * netsum);

netsum = 3.311321;
netsum += inarray[0] * -1.995675;
netsum += inarray[1] * -0.8945962;
netsum += inarray[2] * 1.065134E-02;
netsum += inarray[3] * -2.051849;
netsum += inarray[4] * 1.102686;
netsum += inarray[5] * 2.391575;
feature4[13] = tanh(1.5 * netsum);

netsum = 0.9022573;
netsum += inarray[0] * 0.6620551;
netsum += inarray[1] * -0.1694729;
netsum += inarray[2] * -0.258114;
netsum += inarray[3] * 0.2259856;
netsum += inarray[4] * -3.503741E-02;
netsum += inarray[5] * 0.1627631;
feature4[14] = tanh(1.5 * netsum);

netsum = 0.5453782;
netsum += inarray[0] * 0.7230551;
netsum += inarray[1] * 0.2972477;
netsum += inarray[2] * 0.2121152;
netsum += inarray[3] * 0.8343752;
netsum += inarray[4] * 0.3969353;
netsum += inarray[5] * -4.618372E-02;
feature4[15] = tanh(1.5 * netsum);

netsum = 0.2122064;
netsum += inarray[0] * -1.005119;
netsum += inarray[1] * -2.70129;
netsum += inarray[2] * -3.151926;
netsum += inarray[3] * -0.5137669;
netsum += inarray[4] * -0.2214564;
netsum += inarray[5] * 0.5376168;
feature4[16] = tanh(1.5 * netsum);

netsum = -0.5204934;
netsum += inarray[0] * -0.8955315;
netsum += inarray[1] * -0.1353954;
netsum += inarray[2] * -7.431106E-02;
netsum += inarray[3] * -0.5112603;
netsum += inarray[4] * 0.2158004;
netsum += inarray[5] * -6.353354E-02;
feature4[17] = tanh(1.5 * netsum);

netsum = -1.035887;
netsum += inarray[0] * -0.5469006;
netsum += inarray[1] * -9.691891E-03;
netsum += inarray[2] * 1.241818E-02;
netsum += inarray[3] * 2.734321E-03;
netsum += inarray[4] * -2.265317E-02;
netsum += inarray[5] * -6.667715E-02;
feature4[18] = tanh(1.5 * netsum);

netsum = 1.044167;
netsum += inarray[0] * -0.4903725;
netsum += inarray[1] * -0.4240095;
netsum += inarray[2] * 0.9098265;
netsum += inarray[3] * 0.8558397;
netsum += inarray[4] * 1.26545;
netsum += inarray[5] * -0.5234163;
feature4[19] = tanh(1.5 * netsum);

netsum = 2.253285E-04;
netsum += feature2[0] * -0.2133553;
netsum += feature2[1] * 0.1441804;
netsum += feature2[2] * -0.0897139;
netsum += feature2[3] * 0.1811156;
netsum += feature2[4] * -0.1542166;
netsum += feature2[5] * -8.157378E-02;
netsum += feature2[6] * -0.2310877;
netsum += feature2[7] * 5.022503E-02;
netsum += feature2[8] * 0.1190531;
netsum += feature2[9] * 0.1522862;
netsum += feature2[10] * -4.864423E-02;
netsum += feature2[11] * 0.216653;
netsum += feature2[12] * 0.1121585;
netsum += feature2[13] * -0.1024556;
netsum += feature2[14] * 3.363129E-03;
netsum += feature2[15] * -0.2215999;
netsum += feature2[16] * 0.2574892;
netsum += feature2[17] * -0.3189799;
netsum += feature2[18] * -0.1221137;
netsum += feature2[19] * -1.90652E-03;
netsum += 0.2908565;
netsum += feature3[0] * -9.584853E-02;
netsum += feature3[1] * 8.375838E-02;
netsum += feature3[2] * 8.931218E-02;
netsum += feature3[3] * -1.224578E-03;
netsum += feature3[4] * -0.1297803;
netsum += feature3[5] * 6.748571E-02;
netsum += feature3[6] * -0.1416572;
netsum += feature3[7] * -0.1796455;
netsum += feature3[8] * -4.346181E-02;
netsum += feature3[9] * -0.1542723;
netsum += feature3[10] * -3.456936E-02;
netsum += feature3[11] * -0.0255288;
netsum += feature3[12] * -2.021177E-02;
netsum += feature3[13] * -0.0803099;
netsum += feature3[14] * -0.193548;
netsum += feature3[15] * 0.259162;
netsum += feature3[16] * -0.1311858;
netsum += feature3[17] * 4.260677E-02;
netsum += feature3[18] * 0.2161355;
netsum += feature3[19] * 5.260583E-02;
netsum += -0.2641589;
netsum += feature4[0] * 0.6166842;
netsum += feature4[1] * -0.2026278;
netsum += feature4[2] * 0.7155799;
netsum += feature4[3] * -1.782484;
netsum += feature4[4] * -0.3619494;
netsum += feature4[5] * 0.9951746;
netsum += feature4[6] * -0.5251399;
netsum += feature4[7] * -0.7543113;
netsum += feature4[8] * -0.4241785;
netsum += feature4[9] * -2.413808E-02;
netsum += feature4[10] * 0.1664077;
netsum += feature4[11] * 2.064518E-02;
netsum += feature4[12] * 0.4368076;
netsum += feature4[13] * -2.07518;
netsum += feature4[14] * -8.175965E-02;
netsum += feature4[15] * -0.3162676;
netsum += feature4[16] * -0.7002403;
netsum += feature4[17] * 1.184418E-02;
netsum += feature4[18] * -0.1595735;
netsum += feature4[19] * 0.7172135;
outarray[0] = 1 / (1 + exp(-netsum));


outarray[0] = 0.7 *  (outarray[0] - .1) / .8 ;
if (outarray[0]<0) outarray[0] = 0;
if (outarray[0]>0.7) outarray[0] = 0.7;

               
} /* end cumminsNOxfunc() */
#endif
