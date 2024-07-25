//
//  LocationManager.swift
//  GoodGasoline
//
//  Created by Ann-Marie Czuboka on 2023-06-23.
//

import CoreLocation
import GooglePlaces

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var latestLocation: CLLocation?
    @Published var locationErrorMessage: String?
    @Published var nearbyGasStations: [GMSPlace] = [];
    
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
            fetchNearbyGasStations()
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
    
    func fetchNearbyGasStations(radius: CLLocationDegrees = 0.001) {
        guard let currentLocation = latestLocation else {
            locationErrorMessage = "Cannot fetch nearby gas stations. Location data unavailable."
            return
        }

        let placesClient = GMSPlacesClient.shared()
        let placeFields: GMSPlaceField = [.name, .coordinate, .placeID, .types]
        
        let latitudeOffset: CLLocationDegrees = radius
        let longitudeOffset: CLLocationDegrees = radius


        let northWestBounds = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude + latitudeOffset, currentLocation.coordinate.longitude + longitudeOffset)
        let southEastBounds = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude - latitudeOffset, currentLocation.coordinate.longitude - longitudeOffset)
        
        let locationRestriction = GMSPlaceRectangularLocationOption(northWestBounds, southEastBounds)
        
        let filter = GMSAutocompleteFilter()
        filter.types = ["gas_station"]
        filter.locationRestriction = locationRestriction

        placesClient.findAutocompletePredictions(fromQuery: "gas", filter: filter, sessionToken: nil) { [weak self] (results, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching nearby gas stations: \(error.localizedDescription)")
                self.locationErrorMessage = "Error fetching nearby gas stations."
                return
            }
            
            guard let results = results, !results.isEmpty else {
                // Search until around a 25km radius
                 if radius < 0.225 {
                     print("No gas stations found nearby. Increasing search radius.")
                     self.fetchNearbyGasStations(radius: radius * 2)
                 } else {
                     print("No gas stations found nearby after increasing search radius.")
                     self.locationErrorMessage = "No gas stations found nearby."
                 }
                 return
             }
            
            let placeIDs = results.map { $0.placeID }
            
            for placeID in placeIDs {
                placesClient.fetchPlace(fromPlaceID: placeID, placeFields: placeFields, sessionToken: nil) { (place, error) in
                    if let error = error {
                        print("Error fetching place details: \(error.localizedDescription)")
                        return
                    }
                    
                    if let place = place {
                        print("place: \(place)")
                        self.nearbyGasStations.append(place)
                    }
                }
            }
        }
    }

//    func fetchNearbyGasStations() {
//        guard let currentLocation = latestLocation else {
//            locationErrorMessage = "Cannot fetch nearby gas stations. Location data unavailable."
//            return
//        }
//
//        let placesClient = GMSPlacesClient.shared()
//        let placeFields: GMSPlaceField = [.name, .coordinate, .types]
//
//        placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: placeFields) { [weak self] (likelihoods, error) in
//            guard let self = self else { return }
//
//            if let error = error {
//                print("Error fetching nearby gas stations: \(error.localizedDescription)")
//                self.locationErrorMessage = "Error fetching nearby gas stations."
//                return
//            }
//
//            guard let likelihoods = likelihoods else {
//                print("No locations found nearby.")
//                self.locationErrorMessage = "No locations found nearby."
//                return
//            }
//
//            // Filter to include only gas stations
//            self.nearbyGasStations = likelihoods
//                .filter { likelihood in
//                    // Filter the results to include only gas stations
//                    if let types = likelihood.place.types {
//                        print("types: ", likelihood.place)
//                        return types.contains("restaurant")
//                    }
//                    return false
//                }
//                .map { $0.place }
//
//            // Print the nearby gas stations to the console
//            for gasStation in self.nearbyGasStations {
//                print("Gas Station: \(gasStation.name ?? "Unknown"), Coordinate: \(gasStation.coordinate.latitude), \(gasStation.coordinate.longitude)")
//            }
//        }
//    }


}
