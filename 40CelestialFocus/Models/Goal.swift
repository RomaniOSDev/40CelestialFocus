//
//  Goal.swift
//  40CelestialFocus
//
//  Created by Роман Главацкий on 05.01.2026.
//

import Foundation

struct Goal: Codable, Identifiable {
    let id: UUID
    var title: String
    var targetMinutes: Int
    var period: GoalPeriod
    var startDate: Date
    var isActive: Bool
    
    init(id: UUID = UUID(), title: String, targetMinutes: Int, period: GoalPeriod, startDate: Date = Date(), isActive: Bool = true) {
        self.id = id
        self.title = title
        self.targetMinutes = targetMinutes
        self.period = period
        self.startDate = startDate
        self.isActive = isActive
    }
}

enum GoalPeriod: String, Codable, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
}


