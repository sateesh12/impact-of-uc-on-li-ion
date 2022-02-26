::get the host computers name
echo %COMPUTERNAME%

:: call batch file that sets system path (batch file must be on execute machine)
call %condor_scratch_dir%\..\..\condor_load_path.bat
echo updated host computer path

::Run the self-extracting advisor zip file
advisor_limited.exe
echo extracted ADVISOR

::Open Matlab and automatically run file
matlab.exe -r advisor_dist
echo all done
