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
    // All APIs are configured to be restricted by IP address
    init() {
        let googleAPIKey = ProcessInfo.processInfo.environment["Google_API_Key"] ?? ""
        GMSServices.provideAPIKey(googleAPIKey)
        GMSPlacesClient.provideAPIKey(googleAPIKey)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationManager)
        }
    }
}
