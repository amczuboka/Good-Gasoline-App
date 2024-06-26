//
//  LocationManager.swift
//  GoodGasoline
//
//  Created by Ann-Marie Czuboka on 2023-06-23.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var latestLocation: CLLocation?
    @Published var locationErrorMessage: String?
    
    var simulatedAuthorizationStatus: CLAuthorizationStatus?

    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    var isLocationAvailable: Bool {
        return latestLocation != nil
    }
    
    var isLocationServicesEnabled: Bool {
        return CLLocationManager.locationServicesEnabled() &&
            (locationManager.authorizationStatus == .authorizedWhenInUse ||
            locationManager.authorizationStatus == .authorizedAlways)
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            latestLocation = location
            print("Updated location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let statusToCheck = simulatedAuthorizationStatus ?? status
        
        switch statusToCheck {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            locationErrorMessage = "Location permissions are denied or restricted. Please enable them in Settings."
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        @unknown default:
            locationErrorMessage = "An unknown error occurred. Please try again."
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle location fetching errors here
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}
