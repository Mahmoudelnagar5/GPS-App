import Foundation
import CoreLocation

/// Handler for iOS Location Services
/// Note: iOS doesn't expose individual satellite systems like Android does
/// It uses a combined approach with all available GNSS systems
class LocationHandler: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    private var onlineCompletion: ((Dictionary<String, Any>?) -> Void)?
    private var offlineCompletion: ((Dictionary<String, Any>?) -> Void)?
    private var isOnlineMode = true
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    /// Check if location permissions are granted
    func hasLocationPermission() -> Bool {
        let status = CLLocationManager.authorizationStatus()
        return status == .authorizedWhenInUse || status == .authorizedAlways
    }
    
    /// Check if location services are enabled
    func isLocationEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    /// Request location permissions
    func requestPermissions() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    /// Get location in Online mode (uses network assistance)
    func getOnlineLocation(completion: @escaping (Dictionary<String, Any>?) -> Void) {
        guard hasLocationPermission() else {
            completion(nil)
            return
        }
        
        isOnlineMode = true
        onlineCompletion = completion
        
        // Online mode: use best accuracy with network assistance
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        // Timeout after 15 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) { [weak self] in
            if self?.onlineCompletion != nil {
                self?.locationManager.stopUpdatingLocation()
                self?.onlineCompletion?(nil)
                self?.onlineCompletion = nil
            }
        }
    }
    
    /// Get location in Offline mode (pure GPS)
    func getOfflineLocation(completion: @escaping (Dictionary<String, Any>?) -> Void) {
        guard hasLocationPermission() else {
            completion(nil)
            return
        }
        
        isOnlineMode = false
        offlineCompletion = completion
        
        // Offline mode: GPS only accuracy
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
        
        // Longer timeout for pure satellite fix
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) { [weak self] in
            if self?.offlineCompletion != nil {
                self?.locationManager.stopUpdatingLocation()
                self?.offlineCompletion?(nil)
                self?.offlineCompletion = nil
            }
        }
    }
    
    /// Get satellite information
    /// Note: iOS doesn't expose raw GNSS data like Android
    /// We return simulated constellation info based on iOS capabilities
    func getSatelliteInfo() -> Dictionary<String, Any> {
        // iOS uses a combined GNSS receiver but doesn't expose individual satellite data
        // We return info about what iOS supports
        return [
            "GPS": [
                ["constellationName": "GPS", "info": "Supported via iOS Core Location"]
            ],
            "GLONASS": [
                ["constellationName": "GLONASS", "info": "Supported via iOS Core Location"]
            ],
            "Galileo": [
                ["constellationName": "Galileo", "info": "Supported on iPhone 8 and later"]
            ],
            "BeiDou": [
                ["constellationName": "BeiDou", "info": "Supported on newer iPhone models"]
            ],
            "note": "iOS combines all GNSS systems automatically for best accuracy"
        ]
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        locationManager.stopUpdatingLocation()
        
        let result: Dictionary<String, Any> = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
            "altitude": location.altitude,
            "accuracy": location.horizontalAccuracy,
            "speed": location.speed >= 0 ? location.speed : 0,
            "bearing": location.course >= 0 ? location.course : 0,
            "timestamp": Int64(location.timestamp.timeIntervalSince1970 * 1000),
            "provider": "iOS Core Location",
            "satellites": getSatelliteInfo(),
            "isOnline": isOnlineMode
        ]
        
        if isOnlineMode {
            onlineCompletion?(result)
            onlineCompletion = nil
        } else {
            offlineCompletion?(result)
            offlineCompletion = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        
        if isOnlineMode {
            onlineCompletion?(nil)
            onlineCompletion = nil
        } else {
            offlineCompletion?(nil)
            offlineCompletion = nil
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Handle authorization changes if needed
    }
}
