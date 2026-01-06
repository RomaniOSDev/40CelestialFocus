//
//  TimeFormatter.swift
//  40CelestialFocus
//
//  Created by Роман Главацкий on 05.01.2026.
//

import Foundation

enum TimeFormatter {
    static func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    static func formatDuration(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        if minutes == 1 {
            return "1 minute"
        }
        return "\(minutes) minutes"
    }
}


