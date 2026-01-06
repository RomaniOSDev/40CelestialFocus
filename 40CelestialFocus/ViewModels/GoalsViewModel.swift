//
//  GoalsViewModel.swift
//  40CelestialFocus
//
//  Created by Роман Главацкий on 05.01.2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class GoalsViewModel: ObservableObject {
    @Published var goals: [Goal] = []
    @Published var isLoading: Bool = false
    
    private let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
        Task {
            await loadGoals()
        }
    }
    
    func loadGoals() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            goals = try await dataService.fetchGoals()
        } catch {
            print("Failed to load goals: \(error)")
        }
    }
    
    func saveGoal(_ goal: Goal) async {
        do {
            try await dataService.saveGoal(goal)
            await loadGoals()
        } catch {
            print("Failed to save goal: \(error)")
        }
    }
    
    func deleteGoal(_ goal: Goal) async {
        do {
            try await dataService.deleteGoal(goal)
            await loadGoals()
        } catch {
            print("Failed to delete goal: \(error)")
        }
    }
    
    func getGoalProgress(_ goal: Goal, sessions: [FocusSession]) -> (current: Int, target: Int, percentage: Double) {
        let calendar = Calendar.current
        let now = Date()
        let startDate: Date
        
        switch goal.period {
        case .daily:
            startDate = calendar.startOfDay(for: now)
        case .weekly:
            startDate = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        case .monthly:
            startDate = calendar.date(byAdding: .month, value: -1, to: now) ?? now
        }
        
        let relevantSessions = sessions.filter { 
            $0.date >= startDate && $0.isSuccessful 
        }
        let currentMinutes = relevantSessions.reduce(0) { $0 + Int($1.duration / 60) }
        let percentage = min(1.0, Double(currentMinutes) / Double(goal.targetMinutes))
        
        return (currentMinutes, goal.targetMinutes, percentage)
    }
}


