//
//  AchievementService.swift
//  40CelestialFocus
//
//  Created by Роман Главацкий on 05.01.2026.
//

import Foundation

@MainActor
class AchievementService {
    private let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }
    
    func checkAndUnlockAchievements(sessions: [FocusSession]) async throws -> [Achievement] {
        var achievements = try await dataService.fetchAchievements()
        var newlyUnlocked: [Achievement] = []
        
        for i in 0..<achievements.count {
            if achievements[i].isUnlocked {
                continue
            }
            
            let shouldUnlock = checkRequirement(achievements[i].requirement, sessions: sessions)
            
            if shouldUnlock {
                achievements[i].isUnlocked = true
                achievements[i].unlockedDate = Date()
                newlyUnlocked.append(achievements[i])
            }
        }
        
        if !newlyUnlocked.isEmpty {
            try await dataService.saveAchievements(achievements)
        }
        
        return newlyUnlocked
    }
    
    private func checkRequirement(_ requirement: AchievementRequirement, sessions: [FocusSession]) -> Bool {
        let successfulSessions = sessions.filter { $0.isSuccessful }
        
        switch requirement {
        case .totalSessions(let count):
            return successfulSessions.count >= count
            
        case .totalMinutes(let minutes):
            let totalMinutes = successfulSessions.reduce(0) { $0 + Int($1.duration / 60) }
            return totalMinutes >= minutes
            
        case .consecutiveDays(let days):
            return getConsecutiveDays(sessions: successfulSessions) >= days
            
        case .singleSessionDuration(let minutes):
            return successfulSessions.contains { Int($0.duration / 60) >= minutes }
            
        case .totalSystems(let count):
            let systemsCompleted = successfulSessions.count / 5
            return systemsCompleted >= count
        }
    }
    
    private func getConsecutiveDays(sessions: [FocusSession]) -> Int {
        guard !sessions.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let sortedSessions = sessions.sorted { $0.date > $1.date }
        var consecutiveDays = 1
        var currentDate = calendar.startOfDay(for: sortedSessions[0].date)
        
        for session in sortedSessions.dropFirst() {
            let sessionDate = calendar.startOfDay(for: session.date)
            let daysDifference = calendar.dateComponents([.day], from: sessionDate, to: currentDate).day ?? 0
            
            if daysDifference == 1 {
                consecutiveDays += 1
                currentDate = sessionDate
            } else if daysDifference > 1 {
                break
            }
        }
        
        return consecutiveDays
    }
}



