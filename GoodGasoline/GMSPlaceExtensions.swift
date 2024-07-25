//
//  GMSPlaceExtensions.swift
//  GoodGasoline
//
//  Created by Ann-Marie Czuboka on 2024-07-09.
//

import GooglePlaces

extension GMSPlace {
    var placeInfo: String {
        return "\(name), \(type),\(coordinate.latitude),\(coordinate.longitude), \(placeID)"
    }
}
