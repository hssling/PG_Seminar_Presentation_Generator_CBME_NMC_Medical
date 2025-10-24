@echo off
REM PG Seminar Presentation Generator - Android App Deployment Script for Windows
REM This script helps build and deploy the Android application on Windows

echo === PG Seminar Presentation Generator - Android Deployment ===
echo.

REM Check if Java is available
java -version >nul 2>&1
if errorlevel 1 (
    echo Warning: Java is not installed or not in PATH
    echo Please install Java JDK 8 or higher
    echo.
)

REM Function to build the app
:build_app
echo Building Android application...
echo.

if exist "gradlew.bat" (
    echo Using Gradle Wrapper...
    call gradlew.bat assembleDebug
) else (
    echo Gradle Wrapper not found. Please use Android Studio or install Gradle.
    echo Alternatively, you can:
    echo 1. Open the project in Android Studio
    echo 2. Run "gradle assembleDebug" if you have Gradle installed
    goto :error
)

if %errorlevel% equ 0 (
    echo.
    echo ✅ Build successful!
    echo APK location: app/build/outputs/apk/debug/app-debug.apk
    goto :success
) else (
    echo.
    echo ❌ Build failed!
    goto :error
)

REM Function to install to connected device
:install_to_device
echo Installing to connected device...
echo.

if exist "gradlew.bat" (
    call gradlew.bat installDebug
) else (
    echo Gradle Wrapper not found.
    goto :error
)

if %errorlevel% equ 0 (
    echo.
    echo ✅ Installation successful!
    goto :success
) else (
    echo.
    echo ❌ Installation failed!
    goto :error
)

REM Function to setup Streamlit server
:setup_streamlit
echo Setting up Streamlit server for testing...
echo.
echo To test the Android app locally:
echo.
echo 1. Start the Streamlit server:
echo    streamlit run ../streamlit_app.py --server.port 8501 --server.address 0.0.0.0
echo.
echo 2. Find your machine's IP address:
echo    ipconfig
echo.
echo 3. Update the URL in MainActivity.java:
echo    String streamlitUrl = "http://YOUR_IP:8501";
echo.
echo 4. Rebuild and install the app
echo.
goto :end

REM Function to show help
:show_help
echo Usage: deploy.bat [OPTION]
echo.
echo Options:
echo   build       Build the Android APK
echo   install     Build and install to connected device
echo   setup       Show Streamlit setup instructions
echo   help        Show this help message
echo.
echo Examples:
echo   deploy.bat build     # Build the APK
echo   deploy.bat install   # Build and install to device
echo   deploy.bat setup     # Show setup instructions
echo.
goto :end

REM Main script logic
if "%1"=="build" goto build_app
if "%1"=="install" (
    call :build_app
    if %errorlevel% equ 0 call :install_to_device
    goto :end
)
if "%1"=="setup" goto setup_streamlit
if "%1"=="help" goto show_help
goto show_help

:success
exit /b 0

:error
exit /b 1

:end
