//
//  LocationDataManager.swift
//  CoreLocationSwiftUITutorial
//
//  Created by Cole Dennis on 9/21/22.
//

import Foundation
import CoreLocation
import Combine

class LocationDataManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var currentAddress: String?   // 🏠 Published property for address
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            authorizationStatus = .authorizedWhenInUse
            locationManager.requestLocation()   // Request one-time location
        case .restricted:
            authorizationStatus = .restricted
        case .denied:
            authorizationStatus = .denied
        case .notDetermined:
            authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("❌ Reverse geocode error: \(error.localizedDescription)")
                return
            }

            if let placemark = placemarks?.first {
                print("✅ Placemark: \(placemark)")
                
                var addressParts: [String] = []
                if let name = placemark.name { addressParts.append(name) }
                if let locality = placemark.locality { addressParts.append(locality) }
                if let country = placemark.country { addressParts.append(country) }

                DispatchQueue.main.async {
                    self.currentAddress = addressParts.joined(separator: ", ")
                    print("📍 Final Address: \(self.currentAddress ?? "nil")")
                }
            } else {
                print("⚠️ No placemark found")
            }
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
}
