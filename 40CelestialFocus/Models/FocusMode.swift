//
//  FocusMode.swift
//  40CelestialFocus
//
//  Created by Роман Главацкий on 05.01.2026.
//

import Foundation

struct FocusMode: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let duration: TimeInterval
    let iconName: String
    let color: String
    
    init(id: String, name: String, description: String, duration: TimeInterval, iconName: String, color: String) {
        self.id = id
        self.name = name
        self.description = description
        self.duration = duration
        self.iconName = iconName
        self.color = color
    }
}


