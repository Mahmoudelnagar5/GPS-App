<div align="center">

# 🛰️ GPS Satellite Tracker

<img src="https://img.shields.io/badge/Flutter-3.10.1+-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter SDK">
<img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green?style=for-the-badge" alt="Platform">
<img src="https://img.shields.io/badge/License-MIT-blue?style=for-the-badge" alt="License">

**A modern Flutter application for tracking GPS satellites and comparing location data**

[Features](#-features) • [Getting Started](#-getting-started) • [Architecture](#-architecture) • [Screenshots](#-screenshots)

</div>

---

## 📖 Overview

GPS Satellite Tracker is a cross-platform mobile application built with Flutter that provides real-time GPS satellite information and location tracking. The app compares offline GNSS (Global Navigation Satellite System) location data with online location services, offering users comprehensive insights into their positioning accuracy and satellite visibility.

## ✨ Features

| Feature | Description |
|---------|-------------|
| 📍 **Real-time Location Tracking** | Get continuous GPS position updates with high accuracy |
| 🛰️ **Satellite Information** | View detailed satellite data including PRN, signal strength, elevation, and azimuth |
| 🔄 **Location Comparison** | Compare GNSS offline location with online location services side-by-side |
| 📊 **Accuracy Metrics** | Visualize the accuracy difference between location providers |
| 🔐 **Permission Management** | Graceful handling of location permissions with user-friendly prompts |
| 🎨 **Modern UI** | Clean Material Design 3 interface with smooth animations |
| 📱 **Cross-Platform** | Works seamlessly on both Android and iOS devices |

## 🏗️ Architecture

The project follows a **Feature-First Architecture** with clear separation of concerns:

```
lib/
├── main.dart                          # App entry point
└── features/
    └── home/
        ├── data/
        │   ├── models/
        │   │   ├── gnss_location.dart      # GNSS location model
        │   │   ├── location_comparison.dart # Comparison logic
        │   │   └── satellite_info.dart     # Satellite data model
        │   └── services/
        │       ├── gnss_service.dart       # Native GNSS communication
        │       └── online_location_service.dart # Online location provider
        └── presentation/
            ├── views/
            │   └── home_screen.dart        # Main screen
            └── widgets/
                ├── comparison_widget.dart   # Location comparison UI
                ├── location_display_widget.dart # Location cards
                └── satellite_info_widget.dart  # Satellite list view
```

### Key Components

- **GnssService**: Communicates with native platform channels to access raw GNSS data
- **OnlineLocationService**: Fetches location from online providers
- **Models**: Type-safe data models for location and satellite information
- **Widgets**: Reusable UI components following Flutter best practices

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.10.1 or higher
- Dart SDK 3.10.1 or higher
- Android Studio / Xcode (for platform-specific builds)
- A physical device (GPS features may not work properly on emulators)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/gps_app.git
   cd gps_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
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

See [TESTING.md](TESTING.md) for detailed testing documentation.

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