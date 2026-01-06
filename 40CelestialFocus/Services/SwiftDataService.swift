//
//  SwiftDataService.swift
//  40CelestialFocus
//
//  Created by Роман Главацкий on 05.01.2026.
//

import Foundation

@MainActor
class SwiftDataService: DataServiceProtocol {
    private let sessionsFileName = "focus_sessions.json"
    private let goalsFileName = "goals.json"
    private let achievementsFileName = "achievements.json"
    
    private var sessionsFileURL: URL {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsPath.appendingPathComponent(sessionsFileName)
    }
    
    private var goalsFileURL: URL {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsPath.appendingPathComponent(goalsFileName)
    }
    
    private var achievementsFileURL: URL {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsPath.appendingPathComponent(achievementsFileName)
    }
    
    private var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
    
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    init() {
        // Service initialization doesn't require file creation
        // File will be created on first save
    }
    
    // MARK: - Sessions
    func saveSession(_ session: FocusSession) async throws {
        var sessions = try await fetchSessions()
        sessions.append(session)
        sessions.sort { $0.date > $1.date }
        let data = try encoder.encode(sessions)
        try data.write(to: sessionsFileURL, options: .atomic)
    }
    
    func fetchSessions() async throws -> [FocusSession] {
        guard FileManager.default.fileExists(atPath: sessionsFileURL.path) else {
            return []
        }
        
        let data = try Data(contentsOf: sessionsFileURL)
        let sessions = try decoder.decode([FocusSession].self, from: data)
        return sessions.sorted { $0.date > $1.date }
    }
    
    func deleteAllSessions() async throws {
        let emptyData = try encoder.encode([FocusSession]())
        try emptyData.write(to: sessionsFileURL, options: .atomic)
    }
    
    // MARK: - Goals
    func saveGoal(_ goal: Goal) async throws {
        var goals = try await fetchGoals()
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = goal
        } else {
            goals.append(goal)
        }
        let data = try encoder.encode(goals)
        try data.write(to: goalsFileURL, options: .atomic)
    }
    
    func fetchGoals() async throws -> [Goal] {
        guard FileManager.default.fileExists(atPath: goalsFileURL.path) else {
            return []
        }
        
        let data = try Data(contentsOf: goalsFileURL)
        return try decoder.decode([Goal].self, from: data)
    }
    
    func deleteGoal(_ goal: Goal) async throws {
        var goals = try await fetchGoals()
        goals.removeAll { $0.id == goal.id }
        let data = try encoder.encode(goals)
        try data.write(to: goalsFileURL, options: .atomic)
    }
    
    // MARK: - Achievements
    func saveAchievements(_ achievements: [Achievement]) async throws {
        let data = try encoder.encode(achievements)
        try data.write(to: achievementsFileURL, options: .atomic)
    }
    
    func fetchAchievements() async throws -> [Achievement] {
        guard FileManager.default.fileExists(atPath: achievementsFileURL.path) else {
            return Achievement.defaultAchievements()
        }
        
        let data = try Data(contentsOf: achievementsFileURL)
        return try decoder.decode([Achievement].self, from: data)
    }
}

