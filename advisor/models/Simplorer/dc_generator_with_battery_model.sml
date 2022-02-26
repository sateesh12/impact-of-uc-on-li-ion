//*************************************************************************************************
//                                               SML-File                                         *
//              created by Simplorer Schematic for Windows9x, Windows ME, NT4.0 & Win2k           *
//                                      SIMPLORER SIMULATION CENTER 5.0                           *
//                                                                                                *
//*************************************************************************************************

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Natural Constants %%
#define MATH_PI		3.141592654		// PI
#define MATH_E		2.718281828		// Euler constant
#define PHYS_E0		8.85419E-12		// Permittivity of vacuum
#define PHYS_MU0	1.25664E-06		// Permeability of vacuum
#define PHYS_K		1.38066E-23		// Boltzmann constant	
#define PHYS_Q		1.60217733E-19		// Elementary charge	
#define PHYS_C		299792458		// Speed of Light
#define PHYS_G		9.80665			// Acceleration due to gravitiy
#define PHYS_H		6.6260755E-34		// Planck constant
#define PHYS_T0		-273.15			// Absolute zero
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


MODELDEF Macro2 
{



PORT electrical : p_pin;
PORT electrical : n_pin;
PORT real out : I = Rbs.I;
PORT real out : V = VM1.V;

INTERN  R   Rbs   N1:=N0003,  N2:=p_pin  ( R := 10m  ) ;
INTERN  E 	ET11   N1:=n_pin,  N2:=N0003  ( EMF := BateryVoltage.VAL, PARTDERIV := 1  );
INTERN EQU {Vo := 250 ;
	Vn := 380 ;
	Qo := 6.5 ;
	Qn := 6.5 ; } DST: SIM(Type:=SFML, Sequ:=INIT);
INTERN  VM  VM1  N1:=p_pin,  N2:=n_pin  ( ) ;
INTERN  GAIN  EXT1   ( INPUT:=Rbs.I,KP:=1,TS:=0) ;
INTERN  CONST  Ini_Q   ( CONST:=Qo,TS:=0) ;
INTERN  CONST  Qrat   ( CONST:=Qn,TS:=0) ;
INTERN  CONST  Vnor   ( CONST:=Vn,TS:=0) ;
INTERN  CONST  Voffset   ( CONST:=Vo,TS:=0) ;
INTERN  CONST  Voffset1   ( CONST:=Vo,TS:=0) ;
INTERN  INTG  I_PART1   ( INPUT:=EXT1.VAL,KI:=1,Y0:=0,UL:=1k,LL:=0,TRIGSIG:=0,TRIGVAL:=0,CTRL:=0,TS:=0) ;
INTERN  NEG  NEG1   ( INPUT:=I_PART1.VAL,TS:=0) ;
INTERN  SUM  SUM2_3   (  INPUT[0] := NEG1.VAL,INPUT[1] := Ini_Q.VAL,TS := 0) ;
INTERN	MUL	SOC	( INPUT[0] := SUM2_3.VAL, INPUT[1] := 1 / (Qrat.VAL), TS := 0 );
INTERN  NEG  NEG2   ( INPUT:=Voffset.VAL,TS:=0) ;
INTERN  SUM  SUM2_1   (  INPUT[0] := Vnor.VAL,INPUT[1] := NEG2.VAL,TS := 0) ;
INTERN  MUL  MUL1   (  INPUT[0] := SOC.VAL,INPUT[1] := ,TS := 0,INPUT[2] := SUM2_1.VAL) ;
INTERN  SUM  BateryVoltage   (  INPUT[0] := MUL1.VAL,INPUT[1] := Voffset1.VAL,TS := 0) ;






}
//------------------------------------------------------------------------------------------------





//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MODELDEF SIM2SIM1
{
	PORT real inout:Torque;

	COUPL SIM2SIM SIM2SIM1B
	(
		OUT:={ Torque }
	) DST: SIM(Type:=SIM2SIM );
}//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


INTERN  DCMP  DCMP1   N1:=N0001,  N2:=GND  ( LOAD := SIM2SIM1.Torque, RA := 1, LA := 10m, KE := 1, J := 75m, IA0 := 0, N0 := 0, PHI0 := 0  ) ;

MODEL SIM2SIM1 SIM2SIM1 ();
INTERN  VM  BatteryVoltage  N1:=N0001,  N2:=GND  ( ) ;

MODEL Macro2 Battery p_pin:=N0001,n_pin:=GND ( );
INTERN  GAIN  GAIN1   ( INPUT:=0,KP:=1,TS:=1) ;



SIMCTL SimCtl1
{

SIMCFG SIMPLORER_AC Simplorer2 ( Fstart := 1, Fend := 1k, Fstep := 10, Theta := 23 );
SIMCFG SIMPLORER_TR Simplorer1 ( Tend := 1369, Hmin := 3m, Hmax := 100m, Theta := 23 );

SIMCFG SECM SECM1 ( Solver := 1, LDF := 1, Iteratmax := 40, IEmax := 0.001, VEmax := 0.001 );


}

OUTCTL OutCtl1
{

OUTCFG VIEWTOOL Out1 ( Xmin := 0, Xmax := Tend, Ymin := -400, Ymax := 400 );

RESULT SDB SDB_0(  DCMP1.LOAD );
RESULT SDB SDB_1(  DCMP1.N );
RESULT SDB SDB_2(  DCMP1.MI );
RESULT SDB SDB_3(  DCMP1.PHI );
RESULT SDB SDB_4(  DCMP1.VA );
RESULT SDB SDB_5(  DCMP1.IA );
RESULT SDB SDB_6(  Battery.I );
RESULT VIEW VANALOG_7 (  Battery.I, Type:=ANALOG );
RESULT SDB SDB_8(  Battery.V );
RESULT VIEW VANALOG_9 (  Battery.V, Type:=ANALOG );
RESULT SDB SDB_10(  GAIN1.VAL );
RESULT VIEW VANALOG_11 (  DCMP1.N, Type:=ANALOG );
RESULT VIEW VANALOG_12 (  SIM2SIM1.Torque, Type:=ANALOG );
RESULT VIEW VANALOG_13 (  DCMP1.LOAD, Type:=ANALOG );
RESULT SDB SDB_14(  DCMP1.PSIA );
RESULT VIEW VANALOG_15 (  DCMP1.PSIA, Type:=ANALOG );
RESULT VIEW VANALOG_16 (  DCMP1.IA, Type:=ANALOG );
RESULT VIEW VANALOG_17 (  DCMP1.VA, Type:=ANALOG );
RESULT VIEW VANALOG_18 (  DCMP1.PHI, Type:=ANALOG );
RESULT VIEW VANALOG_19 (  DCMP1.PHIDEG, Type:=ANALOG );
RESULT SDB SDB_20(  DCMP1.PHIDEG );
RESULT SDB SDB_21(  DCMP1.ALPHA );
RESULT VIEW VANALOG_22 (  DCMP1.ALPHA, Type:=ANALOG );
RESULT SDB SDB_23(  DCMP1.OMEGA );
RESULT VIEW VANALOG_24 (  DCMP1.OMEGA, Type:=ANALOG );
RESULT VIEW VANALOG_25 (  DCMP1.MI, Type:=ANALOG );
RESULT SDB SDB_26(  SIM2SIM1.Torque );
RESULT SDB SDB_27(  BatteryVoltage.V );
RESULT SDB SDB_28(  BatteryVoltage.dV );

OUTCFG SimplorerDB DB1 ( Xmin := 0, Xmax := Tend, Reduce := 0, StepNo := 2, StepWidth := 10u );
}


RUN ( Model:=, Out := OutCtl1, Sim := SimCtl1 );


