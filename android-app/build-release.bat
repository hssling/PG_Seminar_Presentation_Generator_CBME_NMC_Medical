@echo off
REM Release build script for distribution APK
REM Creates a signed APK for Google Play Store or direct distribution

echo === Building Release APK for Distribution ===
echo.

REM Check if we're in the right directory
if not exist "gradlew.bat" (
    echo Error: gradlew.bat not found. Please run this script from the android-app directory.
    pause
    exit /b 1
)

echo This will create a release APK that can be distributed.
echo.
echo Note: For Google Play Store, you'll need to:
echo 1. Create a signing key (if you don't have one)
echo 2. Configure signing in build.gradle
echo 3. Build with: gradlew.bat assembleRelease
echo.
echo For direct distribution (sideload), debug build is sufficient.
echo.

set /p choice="Do you want to build (D)ebug APK or (R)elease APK? (D/R): "

if /i "%choice%"=="R" goto release_build
if /i "%choice%"=="D" goto debug_build
goto debug_build

:release_build
echo.
echo Building Release APK...
echo Note: Make sure you have configured signing in build.gradle first
gradlew.bat assembleRelease
goto build_result

:debug_build
echo.
echo Building Debug APK (for testing/sideload distribution)...
gradlew.bat assembleDebug
goto build_result

:build_result
if %errorlevel% equ 0 (
    echo.
    echo === Build Successful! ===
    if /i "%choice%"=="R" (
        echo Release APK created at: app/build/outputs/apk/release/app-release.apk
        echo.
        echo For Google Play Store distribution:
        echo 1. The APK is already signed and optimized
        echo 2. Upload to Google Play Console
        echo 3. Fill in store listing details
    ) else (
        echo Debug APK created at: app/build/outputs/apk/debug/app-debug.apk
        echo.
        echo For direct distribution:
        echo 1. Transfer the APK to target devices
        echo 2. Enable "Install from Unknown Sources"
        echo 3. Install the APK file
        echo.
        echo Note: Debug APK will only work when the Streamlit server is running
    )
    echo.
    echo APK files are ready for distribution!
) else (
    echo.
    echo === Build Failed ===
    echo Check the error messages above and ensure:
    echo - Java JDK is installed and in PATH
    echo - Android SDK is properly configured
    echo - All dependencies are downloaded
)

echo.
pause
