//
//  GMSPlaceExtensions.swift
//  GoodGasoline
//
//  Created by Ann-Marie Czuboka on 2024-07-09.
//

import GooglePlaces

extension GMSPlace {
    var coordinateString: String {
        return "\(coordinate.latitude),\(coordinate.longitude)"
    }
}
