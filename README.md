<div align="center">

# 🛰️ GPS Satellite Tracker

<img src="https://img.shields.io/badge/Flutter-3.10.1+-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter SDK">
<img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green?style=for-the-badge" alt="Platform">
<img src="https://img.shields.io/badge/version-1.0.0-blue?style=for-the-badge" alt="Version">
<img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge" alt="License">

**A modern Flutter application for tracking GPS satellites and comparing location data**

[Features](#-features) • [Getting Started](#-getting-started) • [Architecture](#-architecture) • [Testing](#-testing)

</div>

---

## 📖 Overview

GPS Satellite Tracker is a cross-platform mobile application built with Flutter that provides real-time GPS satellite information and location tracking. The app compares **offline GNSS** (Global Navigation Satellite System) location data with **online location services**, offering users comprehensive insights into their positioning accuracy and satellite visibility.

> **Note**: This app requires a physical device with GPS hardware for full functionality. Emulators may have limited GPS support.

## ✨ Features

| Feature | Description |
|---------|-------------|
| 📍 **Dual Location Tracking** | Simultaneously tracks online (network-based) and offline (GNSS native) locations |
| 🛰️ **Satellite Information** | View detailed satellite data including PRN, signal strength (CN0), elevation, and azimuth |
| 🔄 **Real-time Comparison** | Compare GNSS offline location with online location services side-by-side with live metrics |
| 📊 **Accuracy Metrics** | Visualize horizontal distance difference, altitude variance, and accuracy comparison |
| 🧭 **Multi-Constellation Support** | Track satellites from GPS, GLONASS, and BeiDou constellations |
| 🔐 **Permission Management** | Graceful handling of location permissions with user-friendly prompts and retry options |
| 🎨 **Modern Material 3 UI** | Clean interface with card-based layout, smooth animations, and pull-to-refresh |
| 📱 **Cross-Platform** | Works seamlessly on both Android and iOS devices |
| ⚡ **Stream-based Architecture** | Real-time updates using Dart Streams without BLoC/Cubit complexity |

### Satellite Data Details

The app provides comprehensive satellite information:

| Data Point | Description |
|------------|-------------|
| **SVID** | Satellite Vehicle ID (unique identifier) |
| **CN0 (dB-Hz)** | Signal-to-noise ratio - indicates signal quality |
| **Elevation** | Angle above the horizon (0°-90°) |
| **Azimuth** | Compass direction from user (0°-360°) |
| **Used in Fix** | Whether satellite contributes to position calculation |
| **Ephemeris/Almanac** | Data availability status |

**Signal Quality Indicators:**
- 🟢 **Strong**: >35 dB-Hz (Excellent for positioning)
- 🟠 **Medium**: 25-35 dB-Hz (Acceptable)
- 🔴 **Weak**: <25 dB-Hz (May not be used in fix)

## 🏗️ Architecture

The project follows a **Feature-First Architecture** with clear separation of concerns:

```
lib/
├── main.dart                          # App entry point & MaterialApp configuration
└── features/
    └── home/
        ├── data/
        │   ├── models/
        │   │   ├── gnss_location.dart      # GNSS location model with Haversine distance
        │   │   ├── location_comparison.dart # Comparison logic & metrics
        │   │   └── satellite_info.dart     # Satellite data model
        │   └── services/
        │       ├── gnss_service.dart       # Native GNSS via Platform Channels
        │       └── online_location_service.dart # Geolocator-based location
        └── presentation/
            ├── views/
            │   └── home_screen.dart        # Main screen with StreamBuilder
            └── widgets/
                ├── comparison_widget.dart   # Location comparison UI
                ├── location_display_widget.dart # Dual location cards
                └── satellite_info_widget.dart  # Satellite list & summary
```

### Key Components

| Component | Description |
|-----------|-------------|
| **GnssService** | Communicates with native Android/iOS via `MethodChannel` to access raw GNSS data and satellite status |
| **OnlineLocationService** | Uses Geolocator package for network-based location with stream-based updates |
| **GnssLocation Model** | Contains `distanceTo()` method using Haversine formula for accurate distance calculations |
| **SatelliteInfo Model** | Type-safe representation of satellite data including constellation type and signal quality |
| **Widgets** | Reusable UI components with `StreamBuilder` for reactive updates |

### Data Flow

```
┌─────────────────┐    Platform Channel    ┌──────────────────┐
│   GnssService   │ ◄───────────────────► │  Android/iOS     │
│  (EventChannel) │                        │  GNSS Callbacks  │
└────────┬────────┘                        └──────────────────┘
         │ Stream<GnssLocation>
         │ Stream<List<SatelliteInfo>>
         ▼
┌─────────────────┐    Geolocator API     ┌──────────────────┐
│ OnlineLocation  │ ◄───────────────────► │  Platform GPS    │
│    Service      │                        │  (Network)       │
└────────┬────────┘                        └──────────────────┘
         │ Stream<Position>
         ▼
┌─────────────────────────────────────────┐
│            HomeScreen (State)           │
│  - Combines both streams                │
│  - Updates UI via setState()            │
│  - Handles permissions & errors         │
└─────────────────────────────────────────┘
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.10.1 or higher
- Dart SDK 3.10.1 or higher
- Android Studio / Xcode (for platform-specific builds)
- **Physical device with GPS hardware** (emulators have limited GPS support)
- Android 7.0+ (API 24+) for full GnssStatus API support

### Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/gps_app.git
cd gps_app

# Install dependencies
flutter pub get

# Run on connected device
flutter run
```

Or use the included setup script:
```bash
setup.bat
```

### Platform-Specific Setup

<details>
<summary>📱 Android Setup</summary>

1. Add these permissions to `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
   <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
   <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
   ```

2. Ensure minimum SDK version is set correctly in `android/app/build.gradle`:
   ```gradle
   android {
       defaultConfig {
           minSdkVersion 21
       }
   }
   ```

</details>

<details>
<summary>🍎 iOS Setup</summary>

1. Add to `ios/Runner/Info.plist`:
   ```xml
   <key>NSLocationWhenInUseUsageDescription</key>
   <string>This app needs access to location for GPS tracking</string>
   <key>NSLocationAlwaysUsageDescription</key>
   <string>This app needs access to location for background GPS tracking</string>
   ```

2. Run `pod install` in the `ios` directory:
   ```bash
   cd ios && pod install && cd ..
   ```

</details>

## 📦 Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| [geolocator](https://pub.dev/packages/geolocator) | ^11.0.0 | Cross-platform GPS location |
| [permission_handler](https://pub.dev/packages/permission_handler) | ^11.3.0 | Runtime permissions |
| [cupertino_icons](https://pub.dev/packages/cupertino_icons) | ^1.0.8 | iOS-style icons |



## 🧪 Testing

Run the test suite:

```bash
# Run unit tests
flutter test

# Run with coverage
flutter test --coverage
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Geolocator Package](https://pub.dev/packages/geolocator)
- [Android GNSS Documentation](https://developer.android.com/reference/android/location/GnssStatus)
- [Apple Core Location](https://developer.apple.com/documentation/corelocation)

---

<div align="center">

**Built with ❤️ using Flutter**

[⬆ Back to Top](#-gps-satellite-tracker)

</div>