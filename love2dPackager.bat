@echo off
setlocal enabledelayedexpansion

set /p "Groot=Game root path: "
set /p "Name=Output name: "

:: EDIT THIS: Default LÖVE installation path
:: Change this if your LÖVE is installed elsewhere
set "LoveDir=C:\Program Files\LOVE"
if not exist "%LoveDir%\love.exe" (
    set /p "LoveDir=Path to LOVE folder: "
)

:: EDIT THIS: Default ResourceHacker installation path
:: Change this if ResourceHacker is installed elsewhere
set "ResourceHacker=C:\Program Files (x86)\Resource Hacker\ResourceHacker.exe"
if not exist "%ResourceHacker%" (
    set /p "ResourceHacker=Path to ResourceHacker.exe: "
)

:: EDIT THIS: Output directory for the final .zip file
:: Change this to your preferred download location
set "OutDownloads=C:\Users\wbish\Downloads"

set "Out=%~dp0%Name%_Windows"
set "Love=%~dp0%Name%.love"

echo.
echo Creating .love file...
powershell -Command "Add-Type -A System.IO.Compression.FileSystem; [IO.Compression.ZipFile]::CreateFromDirectory('%Groot%', '%Love%')"
if not exist "%Love%" (
    echo ERROR: Failed to create .love file
    pause
    exit /b
)

echo Creating output folder...
if exist "%Out%" rd /s /q "%Out%"
mkdir "%Out%"

echo Fusing exe...
copy /b "%LoveDir%\love.exe"+"%Love%" "%Name%.exe" >nul
if not exist "%Name%.exe" (
    echo ERROR: Failed to create exe
    pause
    exit /b
)

:: Find first .ico file in root folder
set "IconFile="
for %%f in ("%Groot%\*.ico") do (
    set "IconFile=%%f"
    goto :found_icon
)
:found_icon

if defined IconFile (
    echo Applying custom icon...
    "%ResourceHacker%" -open "%Name%.exe" -save "%Name%.exe" -action addskip -res "%IconFile%" -mask ICONGROUP,MAINICON,
)

echo Moving exe to output folder...
move "%Name%.exe" "%Out%\%Name%.exe" >nul

echo Copying DLLs...
copy "%LoveDir%\*.dll" "%Out%\" >nul
copy "%LoveDir%\license.txt" "%Out%\" >nul 2>nul

echo Creating final zip...
if not exist "%OutDownloads%" mkdir "%OutDownloads%"
if exist "%OutDownloads%\%Name%_Windows.zip" del "%OutDownloads%\%Name%_Windows.zip"
powershell -Command "Add-Type -A System.IO.Compression.FileSystem; [IO.Compression.ZipFile]::CreateFromDirectory('%Out%', '%OutDownloads%\%Name%_Windows.zip')"

if not exist "%OutDownloads%\%Name%_Windows.zip" (
    echo ERROR: Failed to create final zip
    pause
    exit /b
)

echo Cleaning up...
del "%Love%"
rd /s /q "%Out%"

echo.
echo Done! Output: %OutDownloads%\%Name%_Windows.zip
pause
