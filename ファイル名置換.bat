
rem ------- 置換前・置換後の文字列を設定 -------
set TARGET=lotname1
set REPLACE_WITH=lotname2
rem -----------------------------------------

for %%F in ( * ) do call :sub "%%F"
exit /b

:sub
set FILE_NAME=%1
call set FILE_NAME=%%FILE_NAME:%TARGET%=%REPLACE_WITH%%%
ren %1 %FILE_NAME%

goto :EOF