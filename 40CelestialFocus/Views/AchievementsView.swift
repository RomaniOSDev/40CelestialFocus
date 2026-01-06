//
//  AchievementsView.swift
//  40CelestialFocus
//
//  Created by Роман Главацкий on 05.01.2026.
//

import SwiftUI

struct AchievementsView: View {
    @StateObject private var viewModel: AchievementsViewModel
    
    init(dataService: DataServiceProtocol) {
        _viewModel = StateObject(wrappedValue: AchievementsViewModel(dataService: dataService))
    }
    
    var body: some View {
        ZStack {
            Color.colorPrimaryBackground
                .ignoresSafeArea()
            
            if viewModel.isLoading {
                ProgressView()
                    .tint(.colorPrimaryAccent)
            } else {
                ScrollView {
                    VStack(spacing: 24) {
                        // Progress header
                        VStack(spacing: 8) {
                            Text("\(Int(viewModel.unlockProgress * 100))% Complete")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(.colorPrimaryAccent)
                            
                            ProgressView(value: viewModel.unlockProgress)
                                .tint(.colorPrimaryAccent)
                                .scaleEffect(x: 1, y: 2, anchor: .center)
                            
                            Text("\(viewModel.unlockedAchievements.count) of \(viewModel.achievements.count) unlocked")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(.colorPrimaryAccent.opacity(0.7))
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // Unlocked achievements
                        if !viewModel.unlockedAchievements.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Unlocked")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .foregroundColor(.colorPrimaryAccent)
                                    .padding(.horizontal, 20)
                                
                                ForEach(viewModel.unlockedAchievements) { achievement in
                                    AchievementRow(achievement: achievement, isUnlocked: true)
                                }
                            }
                        }
                        
                        // Locked achievements
                        if !viewModel.lockedAchievements.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Locked")
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .foregroundColor(.colorPrimaryAccent.opacity(0.7))
                                    .padding(.horizontal, 20)
                                
                                ForEach(viewModel.lockedAchievements) { achievement in
                                    AchievementRow(achievement: achievement, isUnlocked: false)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationTitle("Achievements")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            Task {
                await viewModel.loadAchievements()
            }
        }
    }
}

struct AchievementRow: View {
    let achievement: Achievement
    let isUnlocked: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: achievement.iconName)
                .font(.system(size: 32))
                .foregroundColor(isUnlocked ? .colorPrimaryAccent : .colorPrimaryAccent.opacity(0.3))
                .frame(width: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(isUnlocked ? .colorPrimaryAccent : .colorPrimaryAccent.opacity(0.5))
                
                Text(achievement.description)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.colorPrimaryAccent.opacity(0.7))
            }
            
            Spacer()
            
            if isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.colorSecondaryAccent)
            } else {
                Image(systemName: "lock.fill")
                    .foregroundColor(.colorPrimaryAccent.opacity(0.3))
            }
        }
        .padding(16)
        .background(Color.colorPrimaryAccent.opacity(isUnlocked ? 0.1 : 0.05))
        .cornerRadius(12)
        .padding(.horizontal, 20)
    }
}


