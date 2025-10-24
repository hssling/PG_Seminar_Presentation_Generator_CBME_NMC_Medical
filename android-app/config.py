#!/usr/bin/env python3
"""
Configuration helper for PG Seminar Presentation Generator Android App
This script helps set up the Streamlit server URL for the Android app
"""

import os
import sys
import socket
import subprocess

def get_local_ip():
    """Get the local IP address of this machine"""
    try:
        # Create a socket to determine local IP
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        local_ip = s.getsockname()[0]
        s.close()
        return local_ip
    except:
        return "127.0.0.1"

def check_streamlit_running(port=8501):
    """Check if Streamlit is running on the specified port"""
    try:
        import urllib.request
        urllib.request.urlopen(f"http://localhost:{port}", timeout=5)
        return True
    except:
        return False

def start_streamlit_server(port=8501, address="0.0.0.0"):
    """Start the Streamlit server"""
    print(f"Starting Streamlit server on {address}:{port}")
    print("Press Ctrl+C to stop the server")
    print()

    try:
        cmd = [
            sys.executable, "-m", "streamlit", "run",
            "../streamlit_app.py",
            "--server.port", str(port),
            "--server.address", address
        ]

        subprocess.run(cmd, cwd=os.path.dirname(os.path.abspath(__file__)))
    except KeyboardInterrupt:
        print("\nServer stopped.")
    except Exception as e:
        print(f"Error starting server: {e}")

def generate_config_instructions():
    """Generate configuration instructions for the Android app"""
    local_ip = get_local_ip()
    streamlit_running = check_streamlit_running()

    print("=== PG Seminar Presentation Generator - Android App Configuration ===")
    print()
    print(f"Local IP Address: {local_ip}")
    print(f"Streamlit Running: {'Yes' if streamlit_running else 'No'}")
    print()

    if streamlit_running:
        print("✅ Streamlit server is running!")
        print(f"📱 Android app can connect to: http://{local_ip}:8501")
        print()
        print("To configure the Android app:")
        print("1. Open android-app/app/src/main/java/com/pgseminar/presentationgenerator/MainActivity.java")
        print(f"2. Find line with 'String streamlitUrl' and update it to: http://{local_ip}:8501")
        print("3. Rebuild and install the Android app")
    else:
        print("❌ Streamlit server is not running.")
        print()
        print("To start the server:")
        print(f"python config.py start")
        print("or manually run:")
        print(f"streamlit run ../streamlit_app.py --server.port 8501 --server.address 0.0.0.0")

    print()
    print("=== Network Setup ===")
    print("Make sure your Android device and development machine are on the same network.")
    print("If using an emulator, use 10.0.2.2 instead of localhost to access the host machine.")
    print()

def main():
    if len(sys.argv) > 1:
        command = sys.argv[1].lower()

        if command == "start":
            start_streamlit_server()
        elif command == "check":
            streamlit_running = check_streamlit_running()
            print(f"Streamlit running: {'Yes' if streamlit_running else 'No'}")
        elif command == "ip":
            print(f"Local IP: {get_local_ip()}")
        else:
            print("Usage: python config.py [start|check|ip]")
            print("  start - Start the Streamlit server")
            print("  check - Check if Streamlit is running")
            print("  ip    - Show local IP address")
    else:
        generate_config_instructions()

if __name__ == "__main__":
    main()
