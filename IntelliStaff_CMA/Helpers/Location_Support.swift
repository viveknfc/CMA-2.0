//
//  Location_Support.swift
//  IntelliStaff_CMA
//
//  Created by NFC Solutions on 19/08/25.
//

import CoreLocation

class SimpleLocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var completion: ((CLLocationCoordinate2D?, Error?) -> Void)?
    private var addressCompletion: ((String?, Error?) -> Void)?
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    // MARK: - Closure based
    func requestLocation(completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        self.completion = completion

        let status = manager.authorizationStatus
        if status == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.requestLocation()
        } else {
            completion(nil, NSError(domain: "LocationError",
                                    code: 1,
                                    userInfo: [NSLocalizedDescriptionKey: "Permission denied"]))
        }
    }

    // MARK: - Async/await support
    func getLocation() async throws -> CLLocationCoordinate2D {
        try await withCheckedThrowingContinuation { continuation in
            requestLocation { coordinate, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let coordinate = coordinate {
                    continuation.resume(returning: coordinate)
                } else {
                    continuation.resume(throwing: NSError(
                        domain: "LocationError",
                        code: 2,
                        userInfo: [NSLocalizedDescriptionKey: "Unknown location error"]
                    ))
                }
            }
        }
    }

    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        completion?(locations.last?.coordinate, nil)
        completion = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completion?(nil, error)
        completion = nil
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse ||
           manager.authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        }
    }
    
    // MARK: - Async Address
    func getAddress() async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            requestAddress { address, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let address = address {
                    continuation.resume(returning: address)
                } else {
                    continuation.resume(throwing: NSError(
                        domain: "LocationError",
                        code: 3,
                        userInfo: [NSLocalizedDescriptionKey: "Unknown address error"]
                    ))
                }
            }
        }
    }
    
    // MARK: - Request Full Address
    func requestAddress(completion: @escaping (String?, Error?) -> Void) {
        self.addressCompletion = completion
        requestLocation { [weak self] coordinate, error in
            if let error = error {
                completion(nil, error)
            } else if let coordinate = coordinate {
                self?.reverseOrderGeocode(coordinate: coordinate, completion: completion)
            }
        }
    }
    
    private func reverseOrderGeocode(coordinate: CLLocationCoordinate2D,
                                completion: @escaping (String?, Error?) -> Void) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                completion(nil, error)
            } else if let placemark = placemarks?.first {
                var addressParts: [String] = []
                
                if let subThoroughfare = placemark.subThoroughfare { addressParts.append(subThoroughfare) }
                if let thoroughfare = placemark.thoroughfare { addressParts.append(thoroughfare) }
                if let subLocality = placemark.subLocality { addressParts.append(subLocality) }
                if let locality = placemark.locality { addressParts.append(locality) }
                if let subAdministrativeArea = placemark.subAdministrativeArea { addressParts.append(subAdministrativeArea) }
                if let administrativeArea = placemark.administrativeArea { addressParts.append(administrativeArea) }
                if let postalCode = placemark.postalCode { addressParts.append(postalCode) }
                if let country = placemark.country { addressParts.append(country) }
                
                let fullAddress = addressParts.joined(separator: ", ")
                completion(fullAddress, nil)
            } else {
                completion(nil, NSError(domain: "LocationError",
                                        code: 2,
                                        userInfo: [NSLocalizedDescriptionKey: "Address not found"]))
            }
        }
    }
    
    // MARK: - Helper function for user-friendly error messages
    public func getUserFriendlyLocationError(error: Error) -> String {
        // Check if it's a CLError (Core Location error)
        if let clError = error as? CLError {
            switch clError.code {
            case .locationUnknown:
                return "Unable to determine your location. Please make sure you're in an area with good GPS signal and try again."
                
            case .denied:
                return "Location access is denied. Please enable location permissions in Settings > Privacy & Security > Location Services."
                
            case .network:
                return "Network error while getting location. Please check your internet connection and try again."
                
            case .regionMonitoringDenied:
                return "Location monitoring is not available. Please enable location services for this app."
                
            case .regionMonitoringFailure:
                return "Failed to monitor location. Please try again in a few moments."
                
            case .regionMonitoringSetupDelayed:
                return "Location setup is taking longer than expected. Please wait and try again."
                
            case .headingFailure:
                return "Unable to determine device orientation for location."
                
            case .rangingUnavailable:
                return "Location ranging is not available on this device."
                
            case .rangingFailure:
                return "Failed to determine precise location. Please try again."
                
            case .promptDeclined:
                return "Location permission was declined. Please enable location access in Settings to continue."
                
            default:
                return "Location error occurred. Please ensure location services are enabled and try again."
            }
        }
        
        // Check for common network/geocoding errors
        let errorDescription = error.localizedDescription.lowercased()
        
        if errorDescription.contains("network") || errorDescription.contains("internet") {
            return "Network connection issue. Please check your internet connection and try again."
        }
        
        if errorDescription.contains("timeout") {
            return "Request timed out. Please check your internet connection and try again."
        }
        
        if errorDescription.contains("geocod") {
            return "Unable to determine your address. Please ensure you have a stable internet connection and try again."
        }
        
        if errorDescription.contains("permission") || errorDescription.contains("authorization") {
            return "Location permission required. Please enable location access in Settings > Privacy & Security > Location Services."
        }
        
        // Generic fallback with actionable advice
        return "Unable to get your current location. Please ensure location services are enabled, you have a good GPS signal, and try again."
    }
}

// MARK: - Alternative: Enum-based approach for more structured error handling
enum LocationError: LocalizedError {
    case permissionDenied
    case locationUnavailable
    case networkIssue
    case geocodingFailed
    case timeout
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Location access is required for check-in/out. Please enable location permissions in Settings > Privacy & Security > Location Services."
        case .locationUnavailable:
            return "Unable to determine your location. Please make sure you're in an area with good GPS signal and try again."
        case .networkIssue:
            return "Network connection issue. Please check your internet connection and try again."
        case .geocodingFailed:
            return "Unable to determine your address. Please ensure you have a stable internet connection and try again."
        case .timeout:
            return "Location request timed out. Please try again in a few moments."
        case .unknown(let message):
            return "Location error: \(message). Please ensure location services are enabled and try again."
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .permissionDenied:
            return "Go to Settings > Privacy & Security > Location Services and enable location access for this app."
        case .locationUnavailable:
            return "Move to an area with better GPS signal, such as near a window or outdoors."
        case .networkIssue, .geocodingFailed:
            return "Check your Wi-Fi or cellular connection and try again."
        case .timeout:
            return "Wait a moment and try the check-in/out process again."
        case .unknown:
            return "Restart the app or contact support if the problem persists."
        }
    }
}



extension SimpleLocationManager {
    static func reverseGeocodeLocation(coordinate: CLLocationCoordinate2D) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                if let placemark = placemarks?.first {
                    let address = [
                        placemark.name,
                        placemark.subLocality,
                        placemark.locality,
                        placemark.administrativeArea,
                        placemark.postalCode,
                        placemark.country
                    ]
                    .compactMap { $0 }
                    .joined(separator: ", ")
                    
                    continuation.resume(returning: address)
                } else {
                    continuation.resume(returning: "Not Found")
                }
            }
        }
    }
}



