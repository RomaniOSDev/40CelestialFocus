//
//  Achievement+Extensions.swift
//  40CelestialFocus
//
//  Created by Роман Главацкий on 05.01.2026.
//

import Foundation

extension Achievement {
    static func defaultAchievements() -> [Achievement] {
        return [
            Achievement(
                id: "first_session",
                title: "First Steps",
                description: "Complete your first focus session",
                iconName: "star.fill",
                requirement: .totalSessions(count: 1)
            ),
            Achievement(
                id: "five_sessions",
                title: "Getting Started",
                description: "Complete 5 focus sessions",
                iconName: "star.circle.fill",
                requirement: .totalSessions(count: 5)
            ),
            Achievement(
                id: "ten_sessions",
                title: "Dedicated",
                description: "Complete 10 focus sessions",
                iconName: "star.fill",
                requirement: .totalSessions(count: 10)
            ),
            Achievement(
                id: "first_system",
                title: "New World",
                description: "Complete your first planetary system",
                iconName: "globe",
                requirement: .totalSystems(count: 1)
            ),
            Achievement(
                id: "five_systems",
                title: "Explorer",
                description: "Complete 5 planetary systems",
                iconName: "globe.americas.fill",
                requirement: .totalSystems(count: 5)
            ),
            Achievement(
                id: "hundred_minutes",
                title: "Century",
                description: "Focus for 100 minutes total",
                iconName: "clock.fill",
                requirement: .totalMinutes(minutes: 100)
            ),
            Achievement(
                id: "five_hundred_minutes",
                title: "Master",
                description: "Focus for 500 minutes total",
                iconName: "crown.fill",
                requirement: .totalMinutes(minutes: 500)
            ),
            Achievement(
                id: "seven_days",
                title: "Week Warrior",
                description: "Focus for 7 consecutive days",
                iconName: "calendar",
                requirement: .consecutiveDays(days: 7)
            ),
            Achievement(
                id: "long_session",
                title: "Marathon",
                description: "Complete a 45-minute focus session",
                iconName: "timer",
                requirement: .singleSessionDuration(minutes: 45)
            )
        ]
    }
}



