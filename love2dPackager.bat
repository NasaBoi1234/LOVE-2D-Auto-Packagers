@echo off
setlocal enabledelayedexpansion

set /p "Groot=Game root path: "
set /p "Name=Output name: "

set "LoveDir=C:\Program Files\LOVE" :: REPLACE WITH THE FOLDER THAT HAS LOVE.EXE
if not exist "%LoveDir%\love.exe" (
    set /p "LoveDir=Path to LOVE folder: "
)

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

echo Moving exe to output folder...
move "%Name%.exe" "%Out%\%Name%.exe" >nul

echo Copying DLLs...
copy "%LoveDir%\*.dll" "%Out%\" >nul
copy "%LoveDir%\license.txt" "%Out%\" >nul 2>nul

echo Creating final zip...
if not exist "C:\Users\wbish\Downloads" mkdir "C:\Users\wbish\Downloads" :: REPLACE "C:\Users\wbish\Downloads" WITH YOUR OUTPUT FOLDER
if exist "C:\Users\wbish\Downloads\%Name%_Windows.zip" del "C:\Users\wbish\Downloads\%Name%_Windows.zip" :: REPLACE "C:\Users\wbish\Downloads" WITH YOUR OUTPUT FOLDER
powershell -Command "Add-Type -A System.IO.Compression.FileSystem; [IO.Compression.ZipFile]::CreateFromDirectory('%Out%', 'C:\Users\wbish\Downloads\%Name%_Windows.zip')" :: REPLACE "C:\Users\wbish\Downloads" WITH YOUR OUTPUT FOLDER

if not exist "C:\Users\wbish\Downloads\%Name%_Windows.zip" ( :: REPLACE "C:\Users\wbish\Downloads" WITH YOUR OUTPUT FOLDER
    echo ERROR: Failed to create final zip
    pause
    exit /b
)

echo Cleaning up...
del "%Love%"
rd /s /q "%Out%"

echo.
echo Done! Output: C:\Users\wbish\Downloads\%Name%_Windows.zip :: REPLACE "C:\Users\wbish\Downloads" WITH YOUR OUTPUT FOLDER
pause
