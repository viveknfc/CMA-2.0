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



