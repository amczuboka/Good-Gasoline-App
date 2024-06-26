//
//  AppState.swift
//  GoodGasoline
//
//  Created by Ann-Marie Czuboka on 2024-06-11.
//
import SwiftUI

class AppState: ObservableObject {
    static let shared = AppState()
    @Published var isLoading = false
}
