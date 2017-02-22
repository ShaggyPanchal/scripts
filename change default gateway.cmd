@echo off
for /f "tokens=4,5 delims=. " %%a in ('ver') do set version=%%a.%%b
if NOT "%version%"=="10.0" goto :eof
rem backup ip config to tex file.
ipconfig >> backup.txt
setlocal EnableDelayedExpansion
set ip_address_string="IPv4 Address"
set subnet_string="Subnet Mask"
set default_dateway_string="Default Gateway"
set count=0
set limit=1
for /f "skip=1 tokens=4 delims= " %%f in ('netsh interface ipv4 show addresses') do (
if !count! EQU 1 goto :eofor
rem echo !count!
set name=%%f
SET /a count=count+1
)
endlocal
:eofor
for /f "usebackq tokens=2 delims=:" %%f in (`ipconfig ^| findstr /c:%ip_address_string%`) do set ip=%%f
for /f "usebackq tokens=2 delims=:" %%f in (`ipconfig ^| findstr /c:%subnet_string%`) do set subnet=%%f
for /f "usebackq tokens=2 delims=:" %%f in (`ipconfig ^| findstr /c:%default_dateway_string%`) do set dns=%%f
set ip=%ip: =%
set subnet=%subnet: =%
set dns=%dns: =%
echo.
echo ************************************************
echo Current default gateway address is %dns%

for /f "tokens=1,2,3,4 delims=." %%a in ("%dns%") do set dg1ip=%%a&&set dg2ip=%%b&&set dg3ip=%%c&&set dg4ip=%%d
if NOT ("%dg4ip%"=="252" OR "%dg4ip%"=="253") goto :failed
if "%dg4ip%"=="252" (set dg4ip=253) else (set dg4ip=252)
set new_gateway=%dg1ip%.%dg2ip%.%dg3ip%.%dg4ip%
echo Default gateway address changed to %new_gateway%
echo ************************************************
echo.
rem everything is set now just fire the command 
netsh interface ip set address name=%name% static %ip% %subnet% %new_gateway%
echo Default gateway address changed...
echo.
goto :exits
:failed
echo Degault gateway address is not in range.
echo.
:exits
echo Program now exits...
echo.
pause