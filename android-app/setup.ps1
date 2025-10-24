# PowerShell script to set up the Android project
# Run this script in PowerShell as Administrator

Write-Host "=== PG Seminar Presentation Generator - Android Setup ===" -ForegroundColor Green
Write-Host ""

# Check if Java is installed
try {
    $javaVersion = java -version 2>&1
    Write-Host "✅ Java is installed" -ForegroundColor Green
} catch {
    Write-Host "❌ Java is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Java JDK 8 or higher from https://adoptium.net/" -ForegroundColor Yellow
    exit 1
}

# Download Gradle Wrapper JAR if it doesn't exist
$gradleWrapperJar = "gradle/wrapper/gradle-wrapper.jar"
if (-not (Test-Path $gradleWrapperJar)) {
    Write-Host "📥 Downloading Gradle Wrapper..." -ForegroundColor Yellow

    # Create the directory if it doesn't exist
    New-Item -ItemType Directory -Force -Path "gradle/wrapper" | Out-Null

    # Download gradle-wrapper.jar
    $gradleWrapperUrl = "https://github.com/gradle/gradle/raw/v8.1.1/gradle/wrapper/gradle-wrapper.jar"
    Invoke-WebRequest -Uri $gradleWrapperUrl -OutFile $gradleWrapperJar

    if (Test-Path $gradleWrapperJar) {
        Write-Host "✅ Gradle Wrapper downloaded successfully" -ForegroundColor Green
    } else {
        Write-Host "❌ Failed to download Gradle Wrapper" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "✅ Gradle Wrapper already exists" -ForegroundColor Green
}

# Make gradlew executable (for Unix-like systems)
if (Test-Path "gradlew") {
    # On Windows, we don't need to change permissions
    Write-Host "✅ Gradle Wrapper script ready" -ForegroundColor Green
}

Write-Host ""
Write-Host "=== Setup Complete! ===" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Make sure the Streamlit server is running:"
Write-Host "   streamlit run ../streamlit_app.py --server.port 8501 --server.address 0.0.0.0"
Write-Host ""
Write-Host "2. Build the Android app:"
Write-Host "   .\gradlew.bat assembleDebug"
Write-Host ""
Write-Host "3. Install to connected device:"
Write-Host "   .\gradlew.bat installDebug"
Write-Host ""
Write-Host "4. Or use Android Studio to open and build the project"
Write-Host ""

# Check if Streamlit is running
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8501" -TimeoutSec 5
    Write-Host "✅ Streamlit server is running!" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Streamlit server is not running on localhost:8501" -ForegroundColor Yellow
    Write-Host "Start it with: streamlit run ../streamlit_app.py --server.port 8501 --server.address 0.0.0.0"
}
