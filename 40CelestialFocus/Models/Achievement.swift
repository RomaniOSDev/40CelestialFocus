//
//  Achievement.swift
//  40CelestialFocus
//
//  Created by Роман Главацкий on 05.01.2026.
//

import Foundation

struct Achievement: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let iconName: String
    let requirement: AchievementRequirement
    var isUnlocked: Bool
    var unlockedDate: Date?
    
    init(id: String, title: String, description: String, iconName: String, requirement: AchievementRequirement, isUnlocked: Bool = false, unlockedDate: Date? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.iconName = iconName
        self.requirement = requirement
        self.isUnlocked = isUnlocked
        self.unlockedDate = unlockedDate
    }
}

enum AchievementRequirement: Codable {
    case totalSessions(count: Int)
    case totalMinutes(minutes: Int)
    case consecutiveDays(days: Int)
    case singleSessionDuration(minutes: Int)
    case totalSystems(count: Int)
}



