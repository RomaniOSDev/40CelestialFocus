//
//  FocusSession.swift
//  40CelestialFocus
//
//  Created by Роман Главацкий on 05.01.2026.
//

import Foundation

struct FocusSession: Codable, Identifiable {
    let id: UUID
    let date: Date
    let duration: TimeInterval
    let isSuccessful: Bool
    
    init(id: UUID = UUID(), date: Date = Date(), duration: TimeInterval, isSuccessful: Bool) {
        self.id = id
        self.date = date
        self.duration = duration
        self.isSuccessful = isSuccessful
    }
}

