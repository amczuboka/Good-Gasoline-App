//
//  DirectionsManager.swift
//  GoodGasoline
//
//  Created by Ann-Marie Czuboka on 2024-08-14.
//

import Foundation
import GoogleMaps

class DirectionsManager {
    private let locationManager: LocationManager
    private let currentLocation: CLLocation?
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        self.currentLocation = locationManager.latestLocation
    }
    
    // reference for now: https://cocoacasts.com/networking-fundamentals-how-to-make-an-http-request-in-swift
    func fetchDirections(from origin: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, completion: @escaping (GMSPath?) -> Void) {
        let originString = "\(origin.latitude),\(origin.longitude)"
        let destinationString = "\(destination.latitude),\(destination.longitude)"
        let directionURLString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(originString)&destination=\(destinationString)&key=AIzaSyAyH-kBSCOA63VXSB-4z5QqQDun6wtegv8"
        
        guard let directionURL = URL(string: directionURLString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: directionURL) { data, response, error in
            if let error = error {
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received from fetchDirections()")
                completion(nil)
                return
            }
            
            //once we retrieve the data we need to create a GMSPath out of the response and do `completion(path)
            
            print(data)
        }
        
        task.resume()
    }
}
