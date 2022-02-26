/*
 *	Adv32Win.c
 *  
 *  Format: adv32win(ScriptFileName,ADVISOR_ROOT,WORK_DIR,SUPPORT_DIR)
 *
 *	This is a simple program is based on engwindemo.c in the 
 *      MATLAB examples on how to call the MATLAB
 *	Engine functions from a C program for windows.
 *
 *	This program,
 *	1) opens a matlab engine
 *	2) updates the current path information
 *	3) runs the specified m-file
 *	4) closes the matlab engine
 *
 *	Input arguements to this program include,
 *	name			description
 *	ScriptFileName	matlab script file to be executed - must be present in the matlab path
 *	ADVISOR_ROOT	root directory of the advisor installation to be used
 *	WORK_DIR		current working directory for the analysis
 *	SUPPORT_DIR		directory with additional support files [optional]
 *
 * 	Created by: Tony Markel, National Renewable Energy Laboratory
 * 	Created on: 10/30/01:tm
 * 	Last Revised: 10/30/01:tm
 * 	Revision Number: 1.0			
 */

#include <windows.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "engine.h"


int PASCAL WinMain (HINSTANCE hInstance,
                    HINSTANCE hPrevInstance,
                    LPSTR     lpszCmdLine,
                    int       nCmdShow) //lpszCmdLine is a space delimited list of command line arguments

{
	//pointer to Matlab engine
	Engine *ep; 
	
	// pointers to mxArray elements in matlab
	mxArray *WORK_DIR = NULL;
	mxArray *ScriptFileName = NULL;	
	mxArray *ADVISOR_ROOT = NULL;	
	mxArray *SUPPORT_DIR = NULL;
	
	// pointers to command line arguments
    char *arg1;
	char *arg2;
	char *arg3;
	char *arg4;
    
	// break command line into four arguments
	arg1=strtok((char *) lpszCmdLine," ");
	arg2=strtok((char *) NULL," ");  // NULL because first instance stores remainder of lpszCmdLine in memory
	arg3=strtok((char *) NULL," ");
	arg4=strtok((char *) NULL," ");

	/*
	 * Start the MATLAB engine 
	 */
	if (!(ep = engOpen(NULL))) {
		MessageBox ((HWND)NULL, (LPSTR)"Can't start MATLAB engine", 
			(LPSTR) "adv32win.c", MB_OK);
		exit(-1);
	}

	/*
	 * Pass input strings to Matlab 
	 */
	WORK_DIR = mxCreateString(arg1); //assign string to pointer
	mxSetName(WORK_DIR, "WORK_DIR"); //assign name in Matlab
	memcpy((char *) mxGetPr(WORK_DIR), (char *) arg1, sizeof(char)); //copy contents from one pointer to the other
	engPutArray(ep, WORK_DIR); //assign value in Matlab workspace
	
	ScriptFileName = mxCreateString(arg2);  
	mxSetName(ScriptFileName, "ScriptFileName");
	memcpy((char *) mxGetPr(ScriptFileName), (char *) arg2, sizeof(char));
	engPutArray(ep, ScriptFileName);

	ADVISOR_ROOT = mxCreateString(arg3);
	mxSetName(ADVISOR_ROOT, "ADVISOR_ROOT");
	memcpy((char *) mxGetPr(ADVISOR_ROOT), (char *) arg3, sizeof(char));
	engPutArray(ep, ADVISOR_ROOT);

	SUPPORT_DIR = mxCreateString(arg4);
	mxSetName(SUPPORT_DIR, "SUPPORT_DIR");
	memcpy((char *) mxGetPr(SUPPORT_DIR), (char *) arg4, sizeof(char));
	engPutArray(ep, SUPPORT_DIR);
	
	/*
	 * Envoke messagebox for debugging MATLAB workspace contents
	 */
	 /*MessageBox ((HWND)NULL, (LPSTR)lpszCmdLine, (LPSTR) "MATLAB - whos", MB_OK);

	/*
	 * Make ADVISOR_ROOT current working directory 
	 */
	engEvalString(ep, "cd(ADVISOR_ROOT)"); //make current directory ADVISOR root directory

	/*
	 * Add ADVISOR Paths and Supplemental Path 
	 */
	engEvalString(ep, "SetAdvisorPath(SUPPORT_DIR)"); //add necessary ADVISOR paths to Matlab

	/*
	 * Make WORK_DIR current working directory 
	 */
	engEvalString(ep, "cd(WORK_DIR)"); //adjust current working directory

	/*
	 * Envoke messagebox for debugging MATLAB workspace contents
	 */
	/*MessageBox ((HWND)NULL, (LPSTR)lpszCmdLine, (LPSTR) "MATLAB - whos", MB_OK);

	/*
	 * Evaluate user script 
	 */
	engEvalString(ep, "eval(ScriptFileName)"); //run the specified script file
	
	/*
	 * Envoke messagebox for debugging MATLAB workspace contents
	 */
	/*MessageBox ((HWND)NULL, (LPSTR)lpszCmdLine, (LPSTR) "MATLAB - whos", MB_OK);

	/*
	 * Remove pointers to free memory 
	 */
	mxDestroyArray(ADVISOR_ROOT);
	mxDestroyArray(SUPPORT_DIR);
	mxDestroyArray(ScriptFileName);
	mxDestroyArray(WORK_DIR);

	free(arg1);
	free(arg2);
	free(arg3);
	free(arg4);

	/*
	 * Close the MATLAB engine 
	 */
	if ((engClose(ep))) {
		MessageBox ((HWND)NULL, (LPSTR)"Can't close MATLAB engine", 
			(LPSTR) "adv32win.c", MB_OK);
		exit(-1);
	}

	return(0);
}