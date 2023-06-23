//
//  ContentView.swift
//  GoodGasoline
//
//  Created by Ann-Marie Czuboka on 2023-05-24.
//

import SwiftUI
import GoogleMaps

struct ContentView: View {
    @EnvironmentObject private var locationManager: LocationManager
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to Good Gasoline")
                    .bold()
                    .padding([.bottom], 10)
                Image("Road")
                    .resizable()
                    .scaledToFit()
                    .padding([.bottom], 300)
                
                NavigationLink(destination: MapView(coordinate: locationManager.latestLocation?.coordinate)) {
                    Text("View Map")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
            }
            .padding()
        }
    }
}
struct MapView: UIViewRepresentable {
    @EnvironmentObject private var locationManager: LocationManager
    private var coordinate: CLLocationCoordinate2D?
    
    init(coordinate: CLLocationCoordinate2D?) {
        self.coordinate = coordinate
    }
    
    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: coordinate?.latitude ?? 0, longitude: coordinate?.longitude ?? 0, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        print("License: \n\n\(GMSServices.openSourceLicenseInfo())")
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        let marker = GMSMarker()
        
        if let userCoordinate = coordinate {
            marker.position = userCoordinate
            marker.title = "Current Location"
            
        }
        marker.map = mapView
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
