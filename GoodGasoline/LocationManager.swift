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
    
// This can be used instead of current implementation to add a locationBias
//    func fetchNearbyGasStations() {
//        guard let currentLocation = latestLocation else {
//            locationErrorMessage = "Cannot fetch nearby gas stations. Location data unavailable."
//            return
//        }
//
//        let placesClient = GMSPlacesClient.shared()
//        let placeFields: GMSPlaceField = [.name, .coordinate]
//        
//        let locationRestriction = GMSPlaceRectangularLocationOption(
//            CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude - 0.01, longitude: currentLocation.coordinate.longitude - 0.01),
//            CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude + 0.01, longitude: currentLocation.coordinate.longitude + 0.01)
//        )
//        
//        let filter = GMSAutocompleteFilter()
//        filter.types = ["gas_station"]
//        filter.locationBias = locationRestriction
//
//        placesClient.findAutocompletePredictions(fromQuery: "gas stations", filter: filter, sessionToken: nil) { [weak self] (results, error) in
//            guard let self = self else { return }
//            
//            if let error = error {
//                print("Error fetching nearby gas stations: \(error.localizedDescription)")
//                self.locationErrorMessage = "Error fetching nearby gas stations."
//                return
//            }
//            
//            guard let results = results else {
//                print("No gas stations found nearby.")
//                self.locationErrorMessage = "No gas stations found nearby."
//                return
//            }
//            
//            let placeIDs = results.map { $0.placeID }
//            
//            // Fetch details for each place ID
//            for placeID in placeIDs {
//                placesClient.fetchPlace(fromPlaceID: placeID, placeFields: placeFields, sessionToken: nil) { (place, error) in
//                    if let error = error {
//                        print("Error fetching place details: \(error.localizedDescription)")
//                        return
//                    }
//                    
//                    if let place = place {
//                        self.nearbyGasStations.append(place)
//                    }
//                }
//            }
//        }
//    }

    func fetchNearbyGasStations() {
        guard let currentLocation = latestLocation else {
            locationErrorMessage = "Cannot fetch nearby gas stations. Location data unavailable."
            return
        }

        let placesClient = GMSPlacesClient.shared()
        let placeFields: GMSPlaceField = [.name, .coordinate, .types]

        // Location bias can be added directly as part of the search criteria
//        let locationBias = GMSPlaceRectangularLocationOption(
//            CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude - 0.01, longitude: currentLocation.coordinate.longitude - 0.01),
//            CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude + 0.01, longitude: currentLocation.coordinate.longitude + 0.01)
//        )

        placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: placeFields) { [weak self] (likelihoods, error) in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching nearby gas stations: \(error.localizedDescription)")
                self.locationErrorMessage = "Error fetching nearby gas stations."
                return
            }

            guard let likelihoods = likelihoods else {
                print("No locations found nearby.")
                self.locationErrorMessage = "No locations found nearby."
                return
            }

            // Filter to include only gas stations
            self.nearbyGasStations = likelihoods
                .filter { likelihood in
                    // Filter the results to include only gas stations
                    if let types = likelihood.place.types {
                        print("types: ", likelihood.place)
                        return types.contains("restaurant")
                    }
                    return false
                }
                .map { $0.place }

            // Print the nearby gas stations to the console
            for gasStation in self.nearbyGasStations {
                print("Gas Station: \(gasStation.name ?? "Unknown"), Coordinate: \(gasStation.coordinate.latitude), \(gasStation.coordinate.longitude)")
            }
        }
    }


}
