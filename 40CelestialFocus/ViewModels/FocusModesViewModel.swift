//
//  FocusModesViewModel.swift
//  40CelestialFocus
//
//  Created by Роман Главацкий on 05.01.2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class FocusModesViewModel: ObservableObject {
    @Published var modes: [FocusMode] = []
    @Published var selectedMode: FocusMode?
    
    init() {
        loadDefaultModes()
    }
    
    private func loadDefaultModes() {
        modes = [
            FocusMode(
                id: "quick",
                name: "Quick Focus",
                description: "5 minutes for quick tasks",
                duration: 5 * 60,
                iconName: "bolt.fill",
                color: "#DAB683"
            ),
            FocusMode(
                id: "short",
                name: "Short Session",
                description: "15 minutes for focused work",
                duration: 15 * 60,
                iconName: "timer",
                color: "#DAB683"
            ),
            FocusMode(
                id: "pomodoro",
                name: "Pomodoro",
                description: "Classic 25-minute session",
                duration: 25 * 60,
                iconName: "circle.fill",
                color: "#DAB683"
            ),
            FocusMode(
                id: "deep",
                name: "Deep Work",
                description: "45 minutes for intensive focus",
                duration: 45 * 60,
                iconName: "brain.head.profile",
                color: "#B70354"
            ),
            FocusMode(
                id: "custom",
                name: "Custom",
                description: "Set your own duration",
                duration: 25 * 60,
                iconName: "slider.horizontal.3",
                color: "#DAB683"
            )
        ]
    }
    
    func selectMode(_ mode: FocusMode) {
        selectedMode = mode
    }
}


