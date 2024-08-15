//
//  GoodGasolineApp.swift
//  GoodGasoline
//
//  Created by Ann-Marie Czuboka on 2023-05-24.
//

import SwiftUI
import GoogleMaps
import GooglePlaces

@main
struct GoodGasolineApp: App {
    @StateObject private var locationManager = LocationManager()
    // Some APIs are configured to be restricted by IP address
    init() {
        GMSServices.provideAPIKey("AIzaSyAyH-kBSCOA63VXSB-4z5QqQDun6wtegv8")
        GMSPlacesClient.provideAPIKey("AIzaSyAyH-kBSCOA63VXSB-4z5QqQDun6wtegv8")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationManager)
        }
    }
}
