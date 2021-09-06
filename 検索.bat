@echo off


for /f "usebackq" %%a in (`dir /b %CD%^| find "OUTPUT_"`) do call :ser1 %%a
exit /b

:ser1
set FILE=%1
set LOTNAME=%FILE:OUTPUT_=%
set LOTNAME=%LOTNAME:.xlsx=%

set LOTTXT=PAT_%LOTNAME%.txt
echo %LOTTXT%
findstr ".csv" %LOTTXT% 

for /f "usebackq" %%b in (`dir /b %CD%^| find "%LOTNAME%"`) do call :ser2 %%b
echo ---------------

exit /b
:ser2
set LOTDATA=%1
echo %LOTDATA%