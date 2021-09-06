@echo off


set str1=A
set str2=B

set delimiter=_

set head1=%str1%%delimiter%
set head2=%str2%%delimiter%

for %%i in (*.txt) do call :sub "%%i"
exit /b

:sub

ren %1 %head1%%1
copy %head1%%1 %CD%\old
del %head1%%1
goto :EOF
 