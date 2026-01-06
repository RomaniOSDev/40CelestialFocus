//
//  FocusView.swift
//  40CelestialFocus
//
//  Created by Роман Главацкий on 05.01.2026.
//

import SwiftUI

struct FocusView: View {
    @StateObject private var viewModel: FocusViewModel
    @Environment(\.scenePhase) private var scenePhase
    
    init(dataService: DataServiceProtocol) {
        _viewModel = StateObject(wrappedValue: FocusViewModel(dataService: dataService))
    }
    
    var body: some View {
        ZStack {
            Color.colorPrimaryBackground
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Celestial System
                ZStack {
                    // Progress ring (background)
                    Circle()
                        .stroke(Color.colorPrimaryAccent.opacity(0.2), lineWidth: 8)
                        .frame(width: 280, height: 280)
                    
                    // Progress ring (filled)
                    Circle()
                        .trim(from: 0, to: viewModel.progress)
                        .stroke(
                            LinearGradient(
                                colors: [.colorPrimaryAccent, .colorSecondaryAccent],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 280, height: 280)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 0.1))
                    
                    // Celestial system (behind timer)
                    CelestialSystemView(
                        moonCount: viewModel.moonCount,
                        isAnimating: viewModel.isRunning
                    )
                    .frame(width: 280, height: 280)
                    
                    // Timer (on top of everything)
                    VStack(spacing: 8) {
                        Text(TimeFormatter.formatTime(viewModel.timeRemaining))
                            .font(.system(size: 64, weight: .light, design: .rounded))
                            .foregroundColor(.colorPrimaryAccent)
                            .monospacedDigit()
                    }
                    .zIndex(1) // Ensure timer is on top
                }
                
                Spacer()
                
                // Action button
                Button(action: {
                    if viewModel.isRunning {
                        viewModel.cancelFocus()
                    } else {
                        viewModel.startFocus()
                    }
                }) {
                    Text(viewModel.isRunning ? "Cancel" : "Start Focus")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(viewModel.isRunning ? Color.colorSecondaryAccent : Color.colorPrimaryAccent)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                Task {
                    await viewModel.refreshMoonCount()
                }
            }
        }
        .onAppear {
            viewModel.loadSettings()
            Task {
                await viewModel.refreshMoonCount()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("SettingsChanged"))) { _ in
            Task {
                await viewModel.refreshMoonCount()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("FocusModeSelected"))) { notification in
            if let duration = notification.object as? TimeInterval {
                viewModel.updateSelectedDuration(duration)
            }
        }
    }
}

