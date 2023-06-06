//
//  ContentView.swift
//  GoodGasoline
//
//  Created by Ann-Marie Czuboka on 2023-05-24.
//

import SwiftUI

struct ContentView: View {
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
                
                NavigationLink(destination: MapView()) {
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

struct MapView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("This is the Google Maps")
                    .font(.largeTitle)
                    .padding()
            }
        }
    }
}

//struct NewView: View {
//    @State private var showNewView = false
//
//    var body: some View {
//        VStack {
//            Text("Map View")
//                .font(.largeTitle)
//                .padding()
//            Button(action: {
//                showNewView = true
//            }) {
//                Text("Go to New View")
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color.blue)
//                    .cornerRadius(10)
//            }
//            .buttonStyle(PlainButtonStyle())
//            .padding()
//            .fullScreenCover(isPresented: $showNewView) {
//                NewView()
//            }
//            Spacer()
//        }
//        .navigationBarTitle("Map")
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
