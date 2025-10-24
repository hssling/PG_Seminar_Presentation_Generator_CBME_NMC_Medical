#!/bin/bash

# PG Seminar Presentation Generator - Android App Deployment Script
# This script helps build and deploy the Android application

echo "=== PG Seminar Presentation Generator - Android Deployment ==="
echo ""

# Check if Android SDK is available
if [ -z "$ANDROID_HOME" ]; then
    echo "Warning: ANDROID_HOME environment variable not set"
    echo "Please set it to your Android SDK path or use Android Studio"
    echo ""
fi

# Function to build the app
build_app() {
    echo "Building Android application..."
    echo ""

    if command -v ./gradlew &> /dev/null; then
        echo "Using Gradle Wrapper..."
        ./gradlew assembleDebug
    else
        echo "Gradle Wrapper not found. Please use Android Studio or install Gradle."
        echo "Alternatively, you can:"
        echo "1. Open the project in Android Studio"
        echo "2. Run 'gradle assembleDebug' if you have Gradle installed"
        return 1
    fi

    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Build successful!"
        echo "APK location: app/build/outputs/apk/debug/app-debug.apk"
        return 0
    else
        echo ""
        echo "❌ Build failed!"
        return 1
    fi
}

# Function to install to connected device
install_to_device() {
    echo "Installing to connected device..."
    echo ""

    if command -v ./gradlew &> /dev/null; then
        ./gradlew installDebug
    else
        echo "Gradle Wrapper not found."
        return 1
    fi

    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Installation successful!"
        return 0
    else
        echo ""
        echo "❌ Installation failed!"
        return 1
    fi
}

# Function to setup Streamlit server
setup_streamlit() {
    echo "Setting up Streamlit server for testing..."
    echo ""
    echo "To test the Android app locally:"
    echo ""
    echo "1. Start the Streamlit server:"
    echo "   streamlit run ../streamlit_app.py --server.port 8501 --server.address 0.0.0.0"
    echo ""
    echo "2. Find your machine's IP address:"
    echo "   Windows: ipconfig"
    echo "   macOS/Linux: ifconfig | grep inet"
    echo ""
    echo "3. Update the URL in MainActivity.java:"
    echo "   String streamlitUrl = \"http://YOUR_IP:8501\";"
    echo ""
    echo "4. Rebuild and install the app"
    echo ""
}

# Function to show help
show_help() {
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  build       Build the Android APK"
    echo "  install     Build and install to connected device"
    echo "  setup       Show Streamlit setup instructions"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 build     # Build the APK"
    echo "  $0 install   # Build and install to device"
    echo "  $0 setup     # Show setup instructions"
    echo ""
}

# Main script logic
case "${1:-help}" in
    "build")
        build_app
        ;;
    "install")
        build_app && install_to_device
        ;;
    "setup")
        setup_streamlit
        ;;
    "help"|*)
        show_help
        ;;
esac
