//
//  Ambience.swift
//  40CelestialFocus
//
//  Created by Роман Главацкий on 05.01.2026.
//

import Foundation

struct Ambience: Codable, Identifiable {
    let id: String
    let name: String
    let iconName: String
    let soundFileName: String?
    let color: String
    
    init(id: String, name: String, iconName: String, soundFileName: String? = nil, color: String) {
        self.id = id
        self.name = name
        self.iconName = iconName
        self.soundFileName = soundFileName
        self.color = color
    }
}


