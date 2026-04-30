@echo off
::needed since we are using loops and the variable count is constantly changing
setlocal enabledelayedexpansion

:menu
cls
title TERMINAL.GUI DESIGNER TOOLKIT
echo ======================================================
echo        TERMINAL.GUI DESIGNER TOOLKIT- PROJECT FILES
echo ======================================================
echo.
echo Select a file to edit:
echo.

set count=0

for %%f in (*.cs) do (
    set "filename=%%~nf"
    echo %%f | findstr /i ".Designer.cs Program.cs" >nul
    if errorlevel 1 (
        if exist "%%~nf.Designer.cs" (
            set /a count+=1
            set "file[!count!]=%%f"
            echo  [!count!] %%f
        )
    )
)

if %count%==0 (
    echo [!] No pairable .cs and .Designer.cs files found.
)

echo.
echo  [0] Create new TUI
echo  [M] Installation Options
echo  [Q] Quit
echo.
set /p choice="Enter option: "

if /i "%choice%"=="Q" exit /b
if /i "%choice%"=="M" goto submenu
if "%choice%"=="0" (
    set /p newfile="Enter file name (e.g. MyDialog.cs): "
    TerminalGuiDesigner "!newfile!"
    goto menu
)

if defined file[%choice%] (
    echo Launching Designer for !file[%choice%]!...
    TerminalGuiDesigner "!file[%choice%]!"
    goto menu
) else (
    echo.
    echo [!] Invalid selection.
    pause
    goto menu
)

:submenu
cls
echo ======================================================
echo               INSTALLATION OPTIONS
echo ======================================================
echo.
echo NOTE: To install the packages below you must run this script from your project's root directory otherwise they may FAIL to install
echo.
echo  [1] Install Terminal.Gui (Nuget package)
echo  [2] Install GUI Designer (Global tool)
echo  [B] Back to Main Menu
echo.
set /p subchoice="Select an option: "

if /i "%subchoice%"=="B" goto menu
if "%subchoice%"=="1" goto install_pkg
if "%subchoice%"=="2" goto install_tool

echo Invalid selection.
pause
goto submenu

:install_pkg
echo Adding Terminal.Gui to project...
dotnet add package Terminal.Gui
pause
goto submenu

:install_tool
echo Installing TerminalGuiDesigner globally...
dotnet tool install --global TerminalGuiDesigner
pause
goto submenu