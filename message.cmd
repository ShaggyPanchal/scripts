@echo off
set /p server_name=Enter PC name:
set /p message=Enter your message:
msg /server:%server_name% * %message%
echo.
pause