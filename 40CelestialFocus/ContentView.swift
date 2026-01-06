//
//  ContentView.swift
//  40CelestialFocus
//
//  Created by Роман Главацкий on 05.01.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var dataService: DataServiceProtocol?
    @State private var navigationPath = NavigationPath()
    @State private var showOnboarding = false
    
    var body: some View {
        Group {
            if let dataService = dataService {
                NavigationStack(path: $navigationPath) {
                    FocusView(dataService: dataService)
                        .navigationDestination(for: AppRoute.self) { route in
                            switch route {
                            case .history:
                                HistoryView(dataService: dataService)
                            case .settings:
                                SettingsView(dataService: dataService) { duration in
                                    // Update duration in FocusView if needed
                                }
                            case .statistics:
                                StatisticsView(dataService: dataService)
                            case .achievements:
                                AchievementsView(dataService: dataService)
                            case .focusModes:
                                FocusModesView(onModeSelected: { duration in
                                    // Handle mode selection - update FocusView duration
                                    NotificationCenter.default.post(
                                        name: NSNotification.Name("FocusModeSelected"),
                                        object: duration
                                    )
                                })
                            case .ambience:
                                AmbienceView()
                            case .goals:
                                GoalsView(dataService: dataService)
                            }
                        }
                        .toolbar {
                            ToolbarItemGroup(placement: .navigationBarTrailing) {
                                Button(action: {
                                    navigationPath.append(AppRoute.statistics)
                                }) {
                                    Image(systemName: "chart.bar.fill")
                                        .foregroundColor(.colorPrimaryAccent)
                                }
                                
                                Button(action: {
                                    navigationPath.append(AppRoute.history)
                                }) {
                                    Image(systemName: "clock")
                                        .foregroundColor(.colorPrimaryAccent)
                                }
                            }
                            
                            ToolbarItemGroup(placement: .navigationBarLeading) {
                                Button(action: {
                                    navigationPath.append(AppRoute.achievements)
                                }) {
                                    Image(systemName: "trophy.fill")
                                        .foregroundColor(.colorPrimaryAccent)
                                }
                                
                                Button(action: {
                                    navigationPath.append(AppRoute.settings)
                                }) {
                                    Image(systemName: "gearshape")
                                        .foregroundColor(.colorPrimaryAccent)
                                }
                            }
                        }
                }
                .sheet(isPresented: $showOnboarding) {
                    OnboardingView(isPresented: $showOnboarding)
                }
                .onAppear {
                    checkOnboarding()
                }
            } else {
                ProgressView()
                    .tint(.colorPrimaryAccent)
                    .onAppear {
                        initializeDataService()
                    }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func checkOnboarding() {
        let hasCompleted = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        if !hasCompleted {
            showOnboarding = true
        }
    }
    
    private func initializeDataService() {
        Task { @MainActor in
            // SwiftDataService initialization is now safe and doesn't throw
            self.dataService = SwiftDataService()
        }
    }
}

enum AppRoute: Hashable {
    case history
    case settings
    case statistics
    case achievements
    case focusModes
    case ambience
    case goals
}
