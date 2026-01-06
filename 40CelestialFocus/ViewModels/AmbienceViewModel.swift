//
//  AmbienceViewModel.swift
//  40CelestialFocus
//
//  Created by Роман Главацкий on 05.01.2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class AmbienceViewModel: ObservableObject {
    @Published var ambiences: [Ambience] = []
    @Published var selectedAmbience: Ambience?
    
    init() {
        loadDefaultAmbiences()
        loadSelectedAmbience()
    }
    
    private func loadDefaultAmbiences() {
        ambiences = [
            Ambience(
                id: "none",
                name: "None",
                iconName: "speaker.slash.fill",
                color: "#DAB683"
            ),
            Ambience(
                id: "space",
                name: "Space",
                iconName: "moon.stars.fill",
                color: "#DAB683"
            ),
            Ambience(
                id: "rain",
                name: "Rain",
                iconName: "cloud.rain.fill",
                color: "#DAB683"
            ),
            Ambience(
                id: "ocean",
                name: "Ocean",
                iconName: "water.waves",
                color: "#DAB683"
            ),
            Ambience(
                id: "forest",
                name: "Forest",
                iconName: "tree.fill",
                color: "#DAB683"
            ),
            Ambience(
                id: "fire",
                name: "Fireplace",
                iconName: "flame.fill",
                color: "#B70354"
            )
        ]
    }
    
    func selectAmbience(_ ambience: Ambience) {
        selectedAmbience = ambience
        UserDefaults.standard.set(ambience.id, forKey: "selectedAmbienceId")
    }
    
    private func loadSelectedAmbience() {
        if let ambienceId = UserDefaults.standard.string(forKey: "selectedAmbienceId"),
           let ambience = ambiences.first(where: { $0.id == ambienceId }) {
            selectedAmbience = ambience
        } else {
            selectedAmbience = ambiences.first
        }
    }
}


