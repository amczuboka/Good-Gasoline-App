# GoodGasoline

## Overview
GoodGasoline is an iOS app that helps users locate the nearest gas stations, filter results by price and distance, and get directions using Google Maps and Google Places APIs.

## Features
- **Nearby Gas Stations:** Fetch and display nearby gas stations with key details (name, address, price level, rating, etc.).
- **Custom Map Markers:** Show enhanced marker views with business information.
- **Directions Integration:** Fetch and display route directions using Google Directions API. (in progress)
- **Filtering:** Filter gas stations based on user preferences such as price level and distance. (todo)
- **User-Friendly Interface:** Designed with a clean and intuitive UI for seamless navigation.

## Tech Stack
- **Languages:** Swift
- **Frameworks:** SwiftUI
- **APIs:** Google Maps, Google Places, Google Directions

## Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/GoodGasoline.git
   cd GoodGasoline
   ```
2. Install dependencies via CocoaPods:
   ```sh
   pod install
   ```
3. Open the `.xcworkspace` file in Xcode:
   ```sh
   open GoodGasoline.xcworkspace
   ```
4. Set up your API keys in `GoodGasolineApp.swift`:
   ```swift
   GMSServices.provideAPIKey("YOUR_GOOGLE_API_KEY")
   GMSPlacesClient.provideAPIKey("YOUR_GOOGLE_API_KEY")
   ```
   or Add the API keys as environment variables and access them in your code
   ```swift
   if let mapsAPIKey = ProcessInfo.processInfo.environment["GOOGLE_API_KEY"], 
   let placesAPIKey = ProcessInfo.processInfo.environment["GOOGLE_API_KEY"] {
    
    GMSServices.provideAPIKey(mapsAPIKey)
    GMSPlacesClient.provideAPIKey(placesAPIKey)
   } else {
       print("API keys not found")
   }
   ```
6. Build and run the app on a simulator or device.

## License
This project is licensed under the MIT License.

