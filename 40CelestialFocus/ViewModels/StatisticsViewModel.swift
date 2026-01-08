//
//  StatisticsViewModel.swift
//  40CelestialFocus
//
//  Created by Роман Главацкий on 05.01.2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class StatisticsViewModel: ObservableObject {
    @Published var sessions: [FocusSession] = []
    @Published var isLoading: Bool = false
    @Published var selectedPeriod: StatisticsPeriod = .week
    
    private let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
        Task {
            await loadSessions()
        }
    }
    
    func loadSessions() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            sessions = try await dataService.fetchSessions()
        } catch {
            print("Failed to load sessions: \(error)")
        }
    }
    
    var filteredSessions: [FocusSession] {
        let calendar = Calendar.current
        let now = Date()
        let startDate: Date
        
        switch selectedPeriod {
        case .today:
            startDate = calendar.startOfDay(for: now)
        case .week:
            startDate = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: now) ?? now
        case .all:
            return sessions
        }
        
        return sessions.filter { $0.date >= startDate }
    }
    
    var totalMinutes: Int {
        filteredSessions.filter { $0.isSuccessful }.reduce(0) { $0 + Int($1.duration / 60) }
    }
    
    var totalSessions: Int {
        filteredSessions.filter { $0.isSuccessful }.count
    }
    
    var averageDuration: TimeInterval {
        let successful = filteredSessions.filter { $0.isSuccessful }
        guard !successful.isEmpty else { return 0 }
        return successful.reduce(0) { $0 + $1.duration } / Double(successful.count)
    }
    
    var longestSession: TimeInterval {
        filteredSessions.filter { $0.isSuccessful }.map { $0.duration }.max() ?? 0
    }
}

enum StatisticsPeriod: String, CaseIterable {
    case today = "Today"
    case week = "Week"
    case month = "Month"
    case all = "All Time"
}



