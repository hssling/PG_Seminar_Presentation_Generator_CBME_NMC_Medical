@echo off
REM Simple build script for the Android app
REM Run this from the android-app directory

echo === Building Android App ===
echo.

REM Check if we're in the right directory
if not exist "gradlew.bat" (
    echo Error: gradlew.bat not found. Please run this script from the android-app directory.
    pause
    exit /b 1
)

echo Building APK...
gradlew.bat assembleDebug

if %errorlevel% equ 0 (
    echo.
    echo === Build Successful! ===
    echo APK created at: app/build/outputs/apk/debug/app-debug.apk
    echo.
    echo To install on device, run: gradlew.bat installDebug
    echo.
    echo To install manually:
    echo 1. Connect Android device via USB
    echo 2. Enable USB debugging in Developer Options
    echo 3. Run: gradlew.bat installDebug
    echo.
    echo Or transfer the APK file to your device and install manually.
) else (
    echo.
    echo === Build Failed ===
    echo Check the error messages above.
)

echo.
pause
