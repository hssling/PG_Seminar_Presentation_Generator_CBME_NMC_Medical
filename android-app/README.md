# PG Seminar Presentation Generator - Android App

An Android WebView wrapper application for the PG Seminar Presentation Generator Streamlit web application. This app allows users to access the presentation generator functionality on Android devices.

## Features

- **WebView Integration**: Seamlessly loads the Streamlit web application
- **File Downloads**: Handles PowerPoint presentation downloads directly to device
- **Mobile Optimized**: Responsive design for mobile devices
- **Offline Support**: Basic offline functionality with error handling
- **Progress Tracking**: Visual progress indicators during loading and downloads

## Project Structure

```
android-app/
├── app/
│   ├── build.gradle              # App-level build configuration
│   ├── proguard-rules.pro        # ProGuard rules for code obfuscation
│   └── src/main/
│       ├── AndroidManifest.xml   # App manifest with permissions
│       ├── java/com/pgseminar/presentationgenerator/
│       │   └── MainActivity.java # Main activity with WebView implementation
│       └── res/
│           ├── layout/
│           │   └── activity_main.xml # Main layout with WebView and controls
│           └── values/
│               ├── colors.xml    # Color resources
│               ├── strings.xml   # String resources
│               └── styles.xml    # Theme and style definitions
├── build.gradle                  # Project-level build configuration
├── gradle.properties            # Gradle configuration properties
├── settings.gradle              # Project settings
└── README.md                    # This file
```

## Prerequisites

- **Android Studio**: Arctic Fox (2020.3.1) or later
- **Android SDK**: API level 24 (Android 7.0) or higher
- **Java JDK**: Version 8 or higher
- **Streamlit Application**: The original Python/Streamlit app must be running and accessible

## Setup Instructions

### 1. Clone and Setup

```bash
# Navigate to the android-app directory
cd android-app

# Open in Android Studio or build with Gradle
```

### 2. Configure Streamlit Server

The Android app needs to connect to the Streamlit application. You have two options:

#### Option A: Local Development (Testing)
1. Start the Streamlit app on your development machine:
```bash
streamlit run ../streamlit_app.py --server.port 8501 --server.address 0.0.0.0
```

2. Find your machine's IP address (e.g., 192.168.1.100)

3. Update the URL in `MainActivity.java`:
```java
// Replace this line in MainActivity.java
String streamlitUrl = "http://192.168.1.100:8501";
```

#### Option B: Production Deployment
1. Deploy the Streamlit app to a public server (Heroku, AWS, Google Cloud, etc.)
2. Get the public URL (e.g., https://your-app.herokuapp.com)
3. Update the URL in `MainActivity.java`:
```java
String streamlitUrl = "https://your-app.herokuapp.com";
```

### 3. Build the Android App

#### Using Android Studio:
1. Open the project in Android Studio
2. Wait for Gradle sync to complete
3. Connect an Android device or start an emulator
4. Click "Run" to build and install the app

#### Using Command Line:
```bash
# Build the APK
./gradlew assembleDebug

# Install to connected device
./gradlew installDebug
```

## Usage

1. **Launch the App**: Open the PG Seminar Presentation Generator app on your Android device
2. **Wait for Loading**: The app will attempt to connect to the Streamlit server
3. **Generate Presentations**: Use the web interface to create presentations as usual
4. **Download Files**: Presentations will be automatically downloaded to your Downloads folder

## Key Features Explained

### WebView Configuration
- **JavaScript Enabled**: Full JavaScript support for Streamlit functionality
- **File Access**: Allows file downloads and uploads
- **Zoom Controls**: Built-in zoom for better mobile experience
- **Cache Management**: Optimized caching for better performance

### Download Management
- **Automatic Downloads**: PowerPoint files are automatically downloaded
- **Download Manager**: Uses Android's built-in DownloadManager
- **Notification Support**: Shows download progress and completion notifications
- **File Organization**: Downloads are saved to the Downloads directory

### Error Handling
- **Network Errors**: Graceful handling of connection issues
- **Server Unavailable**: Shows helpful instructions when server is not accessible
- **Retry Mechanism**: Users can retry connection with a button tap

## Permissions

The app requires the following permissions:
- **Internet Access**: To connect to the Streamlit server
- **Network State**: To check connectivity status
- **Storage**: To save downloaded presentation files

## Troubleshooting

### Common Issues

1. **"Error loading application"**
   - Check if the Streamlit server is running
   - Verify the server URL in MainActivity.java
   - Ensure the device can reach the server (network connectivity)

2. **Downloads not working**
   - Grant storage permissions when prompted
   - Check if device has enough storage space
   - Verify the Downloads folder exists and is writable

3. **App crashes on startup**
   - Ensure Android SDK API level 24+ is installed
   - Check that all dependencies are properly synced
   - Verify Java JDK version compatibility

### Development Tips

1. **Testing on Emulator**:
   - Use Android Studio's emulator with API level 28+
   - Configure network settings to access localhost if needed

2. **Debugging**:
   - Use Android Studio's debugger for Java code
   - Check Logcat for WebView and network errors
   - Use Chrome DevTools for WebView debugging

3. **Performance Optimization**:
   - Enable hardware acceleration in WebView settings
   - Optimize image loading in the Streamlit app
   - Consider implementing offline caching

## Deployment

### Building Release APK

```bash
# Generate signed release APK
./gradlew assembleRelease

# The APK will be in app/build/outputs/apk/release/
```

### Publishing to Google Play Store

1. Generate a signed release APK or App Bundle
2. Create a Google Play Developer account
3. Prepare store listing with screenshots and descriptions
4. Upload the APK/App Bundle to the Play Console
5. Set pricing and distribution options

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on multiple devices/emulators
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:
1. Check the troubleshooting section above
2. Review Android Studio logs and error messages
3. Test with different network configurations
4. Ensure Streamlit server is properly configured

## Integration with Original Project

This Android app is designed to work with the main PG Seminar Presentation Generator project. Make sure:

1. The Streamlit application is running and accessible
2. The server allows CORS requests from the Android app
3. File generation scripts are working correctly
4. Network security policies allow the connection

## Future Enhancements

- **Offline Mode**: Cache frequently used content
- **Push Notifications**: Notify users when presentations are ready
- **File Management**: Built-in file browser for saved presentations
- **Customization**: Theme customization options
- **Performance**: Further optimization for low-end devices
