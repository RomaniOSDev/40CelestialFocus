//
//  SettingsViewModel.swift
//  40CelestialFocus
//
//  Created by Роман Главацкий on 05.01.2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var notificationsEnabled: Bool = false
    @Published var selectedDuration: TimeInterval = 25 * 60
    
    private let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
        loadSettings()
    }
    
    private func loadSettings() {
        notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        let savedDuration = UserDefaults.standard.double(forKey: "selectedDuration")
        if savedDuration > 0 {
            selectedDuration = savedDuration
        }
    }
    
    func toggleNotifications() {
        notificationsEnabled.toggle()
        UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled")
    }
    
    func resetProgress() async {
        do {
            try await dataService.deleteAllSessions()
        } catch {
            print("Failed to reset progress: \(error)")
        }
    }
}


