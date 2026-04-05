import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    private var locationHandler: LocationHandler!
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let controller = window?.rootViewController as! FlutterViewController
        let locationChannel = FlutterMethodChannel(
            name: "com.example.gps_app/location",
            binaryMessenger: controller.binaryMessenger
        )
        
        locationHandler = LocationHandler()
        
        locationChannel.setMethodCallHandler { [weak self] (call, result) in
            guard let self = self else { return }
            
            switch call.method {
            case "checkPermissions":
                result([
                    "granted": self.locationHandler.hasLocationPermission(),
                    "gpsEnabled": self.locationHandler.isLocationEnabled(),
                    "networkEnabled": true // iOS always has network if connected
                ])
                
            case "requestPermissions":
                self.locationHandler.requestPermissions()
                // Wait a bit for the permission dialog
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    result([
                        "granted": self.locationHandler.hasLocationPermission(),
                        "gpsEnabled": self.locationHandler.isLocationEnabled(),
                        "networkEnabled": true
                    ])
                }
                
            case "getOnlineLocation":
                guard self.locationHandler.hasLocationPermission() else {
                    result(FlutterError(code: "PERMISSION_DENIED",
                                       message: "Location permission not granted",
                                       details: nil))
                    return
                }
                
                self.locationHandler.getOnlineLocation { locationData in
                    if let data = locationData {
                        result(data)
                    } else {
                        result(FlutterError(code: "LOCATION_ERROR",
                                           message: "Failed to get online location",
                                           details: nil))
                    }
                }
                
            case "getOfflineLocation":
                guard self.locationHandler.hasLocationPermission() else {
                    result(FlutterError(code: "PERMISSION_DENIED",
                                       message: "Location permission not granted",
                                       details: nil))
                    return
                }
                
                self.locationHandler.getOfflineLocation { locationData in
                    if let data = locationData {
                        result(data)
                    } else {
                        result(FlutterError(code: "LOCATION_ERROR",
                                           message: "Failed to get offline location",
                                           details: nil))
                    }
                }
                
            case "getSatelliteInfo":
                guard self.locationHandler.hasLocationPermission() else {
                    result(FlutterError(code: "PERMISSION_DENIED",
                                       message: "Location permission not granted",
                                       details: nil))
                    return
                }
                
                result(self.locationHandler.getSatelliteInfo())
                
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
