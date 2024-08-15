//
//  ContentView.swift
//  GoodGasoline
//
//  Created by Ann-Marie Czuboka on 2023-05-24.
//

import SwiftUI
import GoogleMaps
import GoogleMapsUtils
import GooglePlaces

struct ContentView: View {
    @EnvironmentObject private var locationManager: LocationManager
    
    var body: some View {
        NavigationView {
            ZStack() {
                Image("Road")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.9)
                
                VStack {
                    Text("Welcome to Good Gasoline")
                        .bold()
                        .font(.title)
                        .foregroundColor(.white)
                        .padding([.top], 50)
                    
                    Spacer()
                    
                    if !locationManager.isLocationAvailable {
                        Text("Location is not available. May be due to poor GPS signal.")
                            .frame(width: UIScreen.main.bounds.width * 0.8)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.red)
                            .padding(.bottom, 20)
                    } else {
                        List(locationManager.nearbyGasStations, id: \.placeInfo) { place in
                                Text(place.name ?? "Unnamed Place")
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.8)
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding()
                    }
                    
                    NavigationLink(destination: MapView()) {
                        Text("View Map")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .hoverEffect(.lift)
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    .disabled(!locationManager.isLocationAvailable)
                }
                .padding()
                
                if let errorMessage = locationManager.locationErrorMessage {
                    ErrorView(errorMessage: errorMessage)
                }
            }
        }
    }
}


struct MapView: UIViewRepresentable {
    @EnvironmentObject private var locationManager: LocationManager
    @State private var zoomLevel: Float = 16.0
    @State private var mapInitialized = false
    @State private var selectedMarker: GMSMarker?

    // Handle map events
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: MapView
        private var customView: CustomMarkerView?

        init(parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
            print("zoom changed on didChange")
            parent.zoomLevel = position.zoom
        }
        
        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            print("zoom changed on idleAt")
            parent.zoomLevel = position.zoom
            
            if !parent.mapInitialized {
                parent.mapInitialized = true
                
                guard let userCoordinate = parent.locationManager.latestLocation?.coordinate,
                      let closestGasStation = parent.locationManager.closestGasStation else {
                    return
                }

                let bounds = GMSCoordinateBounds(coordinate: userCoordinate, coordinate: closestGasStation.coordinate)
                let update = GMSCameraUpdate.fit(bounds, withPadding: 50)
                mapView.animate(with: update)
            }
        }
        
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
             parent.selectedMarker = marker
             if marker.title == "Current Location" {
                 removeCustomView()
                 return false
             }
             showCustomView(for: marker, in: mapView)
             return false // Return false to keep default info window
         }

         func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
             parent.selectedMarker = nil
             removeCustomView()
         }
        
        private func showCustomView(for marker: GMSMarker, in mapView: GMSMapView) {
            removeCustomView()

            guard let place = marker.userData as? GMSPlace else {
                   print("marker.userData is not of type GMSPlace")
                   return
            }
               
            let customView = CustomMarkerView(place: place)
            customView.translatesAutoresizingMaskIntoConstraints = false
            
            if let superview = mapView.superview {
                    superview.addSubview(customView)
                    
                    NSLayoutConstraint.activate([
                        customView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                        customView.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
                        customView.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
                    ])
                }

            
            self.customView = customView
        }

        private func removeCustomView() {
            customView?.removeFromSuperview()
            customView = nil
        }
  }
    
    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: locationManager.latestLocation?.coordinate.latitude ?? 0, longitude: locationManager.latestLocation?.coordinate.longitude ?? 0, zoom: zoomLevel)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        mapView.delegate = context.coordinator
        
        // Enable gestures
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.settings.tiltGestures = true
        mapView.settings.rotateGestures = true
        
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        let marker = GMSMarker()
        
        if let userCoordinate = locationManager.latestLocation?.coordinate {
            marker.position = userCoordinate
            marker.title = "Current Location"
            let icon = GMSMarker.markerImage(with: UIColor.blue)
            marker.icon = icon
        }
        
        marker.map = mapView
        mapView.selectedMarker = marker
        
        if locationManager.nearbyGasStations.isEmpty {
            print("No gas stations found")
            marker.title = "No gas stations found nearby"
        }
        
        for place in locationManager.nearbyGasStations {
            let marker = GMSMarker()
            marker.position = place.coordinate
            marker.title = place.name
            marker.userData = place
            marker.map = mapView
            
        }
    }
}

struct ErrorView: View {
    var errorMessage: String?

    var body: some View {
        VStack {
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .frame(width: UIScreen.main.bounds.width * 0.8)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            } else {
                Text("Unknown error occurred.")
                    .foregroundColor(.red)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}
