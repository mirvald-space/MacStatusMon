# Installation Guide for MacStatusMon

## Method 1: Using the App Bundle (Recommended)

1. Download the latest `MacStatusMon-app-v1.0.0.zip` from the [Releases page](https://github.com/mirvald-space/MacStatusMon/releases)
2. Unzip the file
3. Drag `MacStatusMon.app` to your Applications folder
4. Right-click on the app and select "Open" (required only the first time due to security settings)
5. The app will appear in your menu bar

## Method 2: Manual Installation

1. Download the latest `MacStatusMon-v1.0.0.zip` from the [Releases page](https://github.com/mirvald-space/MacStatusMon/releases)
2. Unzip the file
3. Open Terminal
4. Make the file executable (if it's not already):
   ```bash
   chmod +x /path/to/MacStatusMon
   ```
5. Run the application:
   ```bash
   /path/to/MacStatusMon
   ```

## Method 3: Building from Source

1. Clone the repository:
   ```bash
   git clone https://github.com/mirvald-space/MacStatusMon.git
   ```
2. Navigate to the project directory:
   ```bash
   cd MacStatusMon
   ```
3. Compile the application:
   ```bash
   swiftc SystemMonitor.swift -o MacStatusMon
   ```
4. Run the application:
   ```bash
   ./MacStatusMon
   ```

## Adding to Login Items

To make MacStatusMon start automatically when you log in:

1. Go to System Preferences > Users & Groups
2. Select your user account
3. Click on "Login Items"
4. Click the "+" button
5. Navigate to and select MacStatusMon.app
6. Click "Add"

## Uninstalling

To uninstall MacStatusMon:

1. Quit the application by clicking on its menu bar icon and selecting "Quit"
2. Delete the application from your Applications folder or wherever you installed it
3. If you added it to Login Items, remove it from there as well 