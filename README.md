# MacStatusMon

Lightweight and compact system resource monitor for macOS that displays in the menu bar.

## Features

- CPU usage display in percentage
- RAM usage monitoring
- Automatic updates every 2 seconds
- Minimal resource consumption

## Functions

- **Refresh (⌘+R)**: Update statistics manually
- **Restart (⌘+P)**: Restart the application
- **Quit (⌘+Q)**: Close the application

## Installation

1. Download the latest version from [Releases](https://github.com/mirvald-space/MacStatusMon/releases)
2. Move the application to your Applications folder
3. Launch the application

## Building from source

```bash
git clone https://github.com/mirvald-space/MacStatusMon.git
cd MacStatusMon
swiftc SystemMonitor.swift -o MacStatusMon
```

## License

MIT 