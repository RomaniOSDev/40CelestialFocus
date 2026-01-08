//
//  HistoryViewModel.swift
//  40CelestialFocus
//
//  Created by Роман Главацкий on 05.01.2026.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class HistoryViewModel: ObservableObject {
    @Published var sessions: [FocusSession] = []
    @Published var isLoading: Bool = false
    
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
}



