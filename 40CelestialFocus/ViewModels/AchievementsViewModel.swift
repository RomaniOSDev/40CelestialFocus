//
//  AchievementsViewModel.swift
//  40CelestialFocus
//
//  Created by Роман Главацкий on 05.01.2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class AchievementsViewModel: ObservableObject {
    @Published var achievements: [Achievement] = []
    @Published var isLoading: Bool = false
    
    private let dataService: DataServiceProtocol
    private let achievementService: AchievementService
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
        self.achievementService = AchievementService(dataService: dataService)
        Task {
            await loadAchievements()
        }
    }
    
    func loadAchievements() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            achievements = try await dataService.fetchAchievements()
        } catch {
            print("Failed to load achievements: \(error)")
        }
    }
    
    var unlockedAchievements: [Achievement] {
        achievements.filter { $0.isUnlocked }
    }
    
    var lockedAchievements: [Achievement] {
        achievements.filter { !$0.isUnlocked }
    }
    
    var unlockProgress: Double {
        guard !achievements.isEmpty else { return 0 }
        return Double(unlockedAchievements.count) / Double(achievements.count)
    }
}



