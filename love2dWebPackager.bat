@echo off
setlocal enabledelayedexpansion

title LOVE 2D Web Packager

echo.
echo  ============================================
echo   LOVE 2D  ^|  Web / HTML Packager
echo   Powered by love.js (Davidobot/love.js)
echo  ============================================
echo.

:: -------------------------------------------------------
:: STEP 1: Collect inputs
:: -------------------------------------------------------

set /p "GameRoot=Game root path (folder or .love file): "

if not exist "%GameRoot%" (
    echo ERROR: Path does not exist: %GameRoot%
    pause
    exit /b 1
)

set /p "Name=Output game name: "

if "%Name%"=="" (
    echo ERROR: Output name cannot be empty.
    pause
    exit /b 1
)

:: -------------------------------------------------------
:: STEP 2: Output folder
:: -------------------------------------------------------

:: EDIT THIS: Change to your preferred output location
set "OutDir=%~dp0%Name%_web"

echo.
set /p "CustomOut=Output folder [press Enter for default: %OutDir%]: "
if not "%CustomOut%"=="" set "OutDir=%CustomOut%"

:: -------------------------------------------------------
:: STEP 3: Compatibility mode
:: -------------------------------------------------------

echo.
echo Compatibility mode (-c) skips SharedArrayBuffer/pthreads.
echo Use this for itch.io or hosts that don't set COOP/COEP headers.
echo.
set /p "CompatMode=Use compatibility mode? (Y/N) [default Y]: "
if /i "%CompatMode%"=="N" (
    set "CompatFlag="
) else (
    set "CompatFlag=-c"
)

:: -------------------------------------------------------
:: STEP 4: Check for Node.js
:: -------------------------------------------------------

echo.
echo Checking for Node.js...
where node >nul 2>&1
if errorlevel 1 (
    echo.
    echo ERROR: Node.js was not found on PATH.
    echo Please install Node.js from https://nodejs.org/ and re-run this script.
    pause
    exit /b 1
)
for /f "tokens=*" %%v in ('node -v 2^>nul') do set "NodeVer=%%v"
echo   Found Node.js %NodeVer%

:: -------------------------------------------------------
:: STEP 5: Check / install love.js
:: -------------------------------------------------------

echo.
echo Checking for love.js...

:: Try global install first
where love.js >nul 2>&1
if not errorlevel 1 (
    echo   Found love.js (global^)
    set "LoveJsCmd=love.js"
    goto :lovejs_ready
)

:: Windows cmd/powershell shim
where love.js.cmd >nul 2>&1
if not errorlevel 1 (
    echo   Found love.js.cmd (global^)
    set "LoveJsCmd=love.js.cmd"
    goto :lovejs_ready
)

:: Check via npx (works even if only locally installed)
call npx --no-install love.js --version >nul 2>&1
if not errorlevel 1 (
    echo   Found love.js via npx
    set "LoveJsCmd=npx love.js"
    goto :lovejs_ready
)

:: Not found — offer to install globally
echo   love.js not found.
echo.
set /p "DoInstall=Install love.js globally via npm now? (Y/N) [default Y]: "
if /i "%DoInstall%"=="N" (
    echo.
    echo Skipping install. Run the following command yourself and re-run this script:
    echo   npm install -g love.js
    pause
    exit /b 1
)

echo.
echo Installing love.js globally (npm install -g love.js)...
call npm install -g love.js
if errorlevel 1 (
    echo.
    echo ERROR: npm install failed. Check your npm configuration and try again.
    pause
    exit /b 1
)
echo   love.js installed successfully.
set "LoveJsCmd=love.js.cmd"

:lovejs_ready

:: -------------------------------------------------------
:: STEP 6: Create .love file if input is a folder
:: -------------------------------------------------------

set "LoveInput=%GameRoot%"

:: Detect if input is a folder (not already a .love file)
set "IsFolder=0"
if exist "%GameRoot%\main.lua" set "IsFolder=1"

if "%IsFolder%"=="1" (
    echo.
    echo Creating .love archive from folder...
    set "LoveFile=%~dp0%Name%.love"

    if exist "!LoveFile!" del "!LoveFile!"
    powershell -Command "Add-Type -A System.IO.Compression.FileSystem; [IO.Compression.ZipFile]::CreateFromDirectory('%GameRoot%', '!LoveFile!')"

    if not exist "!LoveFile!" (
        echo ERROR: Failed to create .love file. Make sure the folder contains main.lua.
        pause
        exit /b 1
    )
    echo   Created: !LoveFile!
    set "LoveInput=!LoveFile!"
)

:: -------------------------------------------------------
:: STEP 7: Run love.js packager
:: -------------------------------------------------------

echo.
echo Packaging for web with love.js...
echo   Input : %LoveInput%
echo   Output: %OutDir%
echo   Title : %Name%
if defined CompatFlag echo   Mode  : Compatibility (-c)
if not defined CompatFlag echo   Mode  : Standard (SharedArrayBuffer / pthreads)
echo.

if exist "%OutDir%" (
    echo Removing old output folder...
    rd /s /q "%OutDir%"
)
mkdir "%OutDir%"

call %LoveJsCmd% %CompatFlag% --title "%Name%" "%LoveInput%" "%OutDir%"

if errorlevel 1 (
    echo.
    echo ERROR: love.js packaging failed. See output above for details.
    if "%IsFolder%"=="1" if exist "%LoveInput%" del "%LoveInput%"
    pause
    exit /b 1
)

:: -------------------------------------------------------
:: STEP 8: Cleanup temp .love (if we created it)
:: -------------------------------------------------------

if "%IsFolder%"=="1" (
    if exist "%LoveInput%" (
        del "%LoveInput%"
        echo Cleaned up temporary .love file.
    )
)

:: -------------------------------------------------------
:: STEP 9: Optional — zip the output
:: -------------------------------------------------------

echo.
set /p "DoZip=Create a distributable .zip of the web output? (Y/N) [default Y]: "
if /i not "%DoZip%"=="N" (
    set "ZipPath=%~dp0%Name%_web.zip"
    if exist "!ZipPath!" del "!ZipPath!"
    echo Creating zip: !ZipPath!
    powershell -Command "Add-Type -A System.IO.Compression.FileSystem; [IO.Compression.ZipFile]::CreateFromDirectory('%OutDir%', '!ZipPath!')"
    if exist "!ZipPath!" (
        echo   Zip created: !ZipPath!
    ) else (
        echo   WARNING: Zip creation failed. The web folder is still available.
    )
)

:: -------------------------------------------------------
:: STEP 10: Done
:: -------------------------------------------------------

echo.
echo  ============================================
echo   Done!
echo.
echo   Web output folder : %OutDir%
echo.
echo   To test locally, run a web server inside
echo   the output folder, e.g.:
echo     cd "%OutDir%"
echo     python -m http.server 8000
echo   Then open http://localhost:8000
echo.
echo   NOTE: The page will NOT work when opened
echo   directly as a file:// URL in a browser.
echo  ============================================
echo.
pause
