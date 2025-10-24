@echo off
REM Build script for MCP server
REM Run this from the seminar-generator directory

echo === Building MCP Server ===
echo.

REM Check if we're in the right directory
if not exist "package.json" (
    echo Error: package.json not found. Please run this script from the seminar-generator directory.
    pause
    exit /b 1
)

echo Installing dependencies...
npm install

if %errorlevel% equ 0 (
    echo.
    echo Dependencies installed successfully!
    echo.
    echo Building MCP server...
    npm run build

    if %errorlevel% equ 0 (
        echo.
        echo === MCP Server Built Successfully! ===
        echo.
        echo The build/index.js file should now exist.
        echo.
        echo Next steps:
        echo 1. Restart the Streamlit server:
        echo    streamlit run ../streamlit_app.py --server.port 8501 --server.address 0.0.0.0
        echo.
        echo 2. Check the web interface - it should show "MCP Server is built and ready"
        echo.
        echo 3. Build the Android app:
        echo    cd ../android-app
        echo    gradlew.bat assembleDebug
    ) else (
        echo.
        echo === Build Failed ===
        echo Check the error messages above.
    )
) else (
    echo.
    echo === Installation Failed ===
    echo Check the error messages above.
)

echo.
pause
