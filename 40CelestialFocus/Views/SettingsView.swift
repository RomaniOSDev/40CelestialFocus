//
//  SettingsView.swift
//  40CelestialFocus
//
//  Created by Роман Главацкий on 05.01.2026.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel
    @State private var showResetAlert = false
    @Environment(\.dismiss) private var dismiss
    
    let dataService: DataServiceProtocol
    let onDurationChanged: (TimeInterval) -> Void
    
    init(dataService: DataServiceProtocol, onDurationChanged: @escaping (TimeInterval) -> Void) {
        _viewModel = StateObject(wrappedValue: SettingsViewModel(dataService: dataService))
        self.dataService = dataService
        self.onDurationChanged = onDurationChanged
    }
    
    private let durations: [(TimeInterval, String)] = [
        (5 * 60, "5 minutes"),
        (10 * 60, "10 minutes"),
        (15 * 60, "15 minutes"),
        (25 * 60, "25 minutes"),
        (45 * 60, "45 minutes")
    ]
    
    var body: some View {
        ZStack {
            Color.colorPrimaryBackground
                .ignoresSafeArea()
            
            Form {
                Section {
                    Picker("Focus Duration", selection: Binding(
                        get: { viewModel.selectedDuration },
                        set: { newValue in
                            viewModel.selectedDuration = newValue
                            UserDefaults.standard.set(newValue, forKey: "selectedDuration")
                            onDurationChanged(newValue)
                        }
                    )) {
                        ForEach(durations, id: \.0) { duration, label in
                            Text(label).tag(duration)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(.colorPrimaryAccent)
                } header: {
                    Text("Focus Settings")
                        .foregroundColor(.colorPrimaryAccent.opacity(0.7))
                }
                
                Section {
                    Toggle("Notifications", isOn: Binding(
                        get: { viewModel.notificationsEnabled },
                        set: { _ in viewModel.toggleNotifications() }
                    ))
                    .tint(.colorPrimaryAccent)
                } header: {
                    Text("Notifications")
                        .foregroundColor(.colorPrimaryAccent.opacity(0.7))
                }
                
                Section {
                    NavigationLink(destination: FocusModesView(onModeSelected: { duration in
                        onDurationChanged(duration)
                        dismiss()
                    })) {
                        HStack {
                            Text("Focus Modes")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.colorPrimaryAccent.opacity(0.5))
                        }
                    }
                    
                    NavigationLink(destination: AmbienceView()) {
                        HStack {
                            Text("Ambience")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.colorPrimaryAccent.opacity(0.5))
                        }
                    }
                    
                    NavigationLink(destination: GoalsView(dataService: dataService)) {
                        HStack {
                            Text("Goals")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.colorPrimaryAccent.opacity(0.5))
                        }
                    }
                } header: {
                    Text("Features")
                        .foregroundColor(.colorPrimaryAccent.opacity(0.7))
                }
                
                Section {
                    Button(action: {
                        openRateUs()
                    }) {
                        HStack {
                            Text("Rate Us")
                                .foregroundColor(.colorPrimaryAccent)
                            Spacer()
                            Image(systemName: "star.fill")
                                .foregroundColor(.colorPrimaryAccent.opacity(0.5))
                        }
                    }
                    
                    Button(action: {
                        openPrivacyPolicy()
                    }) {
                        HStack {
                            Text("Privacy Policy")
                                .foregroundColor(.colorPrimaryAccent)
                            Spacer()
                            Image(systemName: "lock.shield.fill")
                                .foregroundColor(.colorPrimaryAccent.opacity(0.5))
                        }
                    }
                    
                    Button(action: {
                        openTerms()
                    }) {
                        HStack {
                            Text("Terms")
                                .foregroundColor(.colorPrimaryAccent)
                            Spacer()
                            Image(systemName: "doc.text.fill")
                                .foregroundColor(.colorPrimaryAccent.opacity(0.5))
                        }
                    }
                } header: {
                    Text("About")
                        .foregroundColor(.colorPrimaryAccent.opacity(0.7))
                }
                
                Section {
                    Button(action: {
                        showResetAlert = true
                    }) {
                        HStack {
                            Text("Reset Progress")
                                .foregroundColor(.colorSecondaryAccent)
                            Spacer()
                        }
                    }
                } header: {
                    Text("Data")
                        .foregroundColor(.colorPrimaryAccent.opacity(0.7))
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.colorPrimaryBackground)
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .alert("Reset Progress", isPresented: $showResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                Task {
                    await viewModel.resetProgress()
                }
            }
        } message: {
            Text("This will delete all your focus sessions. This action cannot be undone.")
        }
        .onDisappear {
            // Notify that settings might have changed
            NotificationCenter.default.post(name: NSNotification.Name("SettingsChanged"), object: nil)
        }
    }
    
    private func openRateUs() {
        SKStoreReviewController.requestReview()
    }
    
    private func openPrivacyPolicy() {
        if let url = URL(string: "https://www.termsfeed.com/live/af3b16cc-06e0-4f4e-98f7-ac2d9f6b2c82") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openTerms() {
        if let url = URL(string: "https://www.termsfeed.com/live/eabe86e5-c7e6-44f2-bdb3-e3e84526e766") {
            UIApplication.shared.open(url)
        }
    }
}

