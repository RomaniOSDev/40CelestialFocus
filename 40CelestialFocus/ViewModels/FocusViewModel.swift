//
//  FocusViewModel.swift
//  40CelestialFocus
//
//  Created by Роман Главацкий on 05.01.2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class FocusViewModel: ObservableObject {
    @Published var timeRemaining: TimeInterval = 0
    @Published var isRunning: Bool = false
    @Published var selectedDuration: TimeInterval = 25 * 60 // 25 minutes default
    @Published var progress: Double = 0.0
    @Published var moonCount: Int = 0
    
    private var timerTask: Task<Void, Never>?
    private let dataService: DataServiceProtocol
    private let achievementService: AchievementService
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
        self.achievementService = AchievementService(dataService: dataService)
        loadSettings()
        Task {
            await updateMoonCount()
        }
    }
    
    func loadSettings() {
        let savedDuration = UserDefaults.standard.double(forKey: "selectedDuration")
        if savedDuration > 0 {
            selectedDuration = savedDuration
        }
        if !isRunning {
            timeRemaining = selectedDuration
        }
    }
    
    func startFocus() {
        guard !isRunning else { return }
        
        isRunning = true
        timeRemaining = selectedDuration
        progress = 0.0
        
        timerTask = Task {
            let startTime = Date()
            let endTime = startTime.addingTimeInterval(selectedDuration)
            
            while !Task.isCancelled && Date() < endTime {
                let elapsed = Date().timeIntervalSince(startTime)
                timeRemaining = max(0, selectedDuration - elapsed)
                progress = min(1.0, elapsed / selectedDuration)
                
                try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 second
            }
            
            if !Task.isCancelled && timeRemaining <= 0 {
                await completeSession()
            }
        }
    }
    
    func cancelFocus() {
        timerTask?.cancel()
        timerTask = nil
        isRunning = false
        timeRemaining = selectedDuration
        progress = 0.0
    }
    
    private func completeSession() async {
        isRunning = false
        progress = 1.0
        
        let session = FocusSession(
            duration: selectedDuration,
            isSuccessful: true
        )
        
        do {
            try await dataService.saveSession(session)
            await updateMoonCount()
            
            // Check for achievements
            let sessions = try await dataService.fetchSessions()
            let newlyUnlocked = try await achievementService.checkAndUnlockAchievements(sessions: sessions)
            if !newlyUnlocked.isEmpty {
                NotificationCenter.default.post(
                    name: NSNotification.Name("AchievementsUnlocked"),
                    object: newlyUnlocked
                )
            }
        } catch {
            print("Failed to save session: \(error)")
        }
        
        timerTask = nil
    }
    
    func refreshMoonCount() async {
        await updateMoonCount()
    }
    
    private func updateMoonCount() async {
        do {
            let sessions = try await dataService.fetchSessions()
            let successfulSessions = sessions.filter { $0.isSuccessful }
            moonCount = successfulSessions.count % 5 // Show moons for current system (max 5)
        } catch {
            print("Failed to fetch sessions: \(error)")
        }
    }
    
    func updateSelectedDuration(_ duration: TimeInterval) {
        selectedDuration = duration
        if !isRunning {
            timeRemaining = duration
        }
        UserDefaults.standard.set(duration, forKey: "selectedDuration")
    }
}

