//
//  DataServiceProtocol.swift
//  40CelestialFocus
//
//  Created by Роман Главацкий on 05.01.2026.
//

import Foundation

protocol DataServiceProtocol {
    // Sessions
    func saveSession(_ session: FocusSession) async throws
    func fetchSessions() async throws -> [FocusSession]
    func deleteAllSessions() async throws
    
    // Goals
    func saveGoal(_ goal: Goal) async throws
    func fetchGoals() async throws -> [Goal]
    func deleteGoal(_ goal: Goal) async throws
    
    // Achievements
    func saveAchievements(_ achievements: [Achievement]) async throws
    func fetchAchievements() async throws -> [Achievement]
}

