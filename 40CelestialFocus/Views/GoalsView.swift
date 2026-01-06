//
//  GoalsView.swift
//  40CelestialFocus
//
//  Created by Роман Главацкий on 05.01.2026.
//

import SwiftUI

struct GoalsView: View {
    @StateObject private var viewModel: GoalsViewModel
    @State private var showingAddGoal = false
    @StateObject private var sessionsViewModel: HistoryViewModel
    
    init(dataService: DataServiceProtocol) {
        _viewModel = StateObject(wrappedValue: GoalsViewModel(dataService: dataService))
        _sessionsViewModel = StateObject(wrappedValue: HistoryViewModel(dataService: dataService))
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
                    VStack(spacing: 20) {
                        if viewModel.goals.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "target")
                                    .font(.system(size: 48))
                                    .foregroundColor(.colorPrimaryAccent.opacity(0.5))
                                Text("No goals yet")
                                    .font(.system(size: 18, weight: .medium, design: .rounded))
                                    .foregroundColor(.colorPrimaryAccent.opacity(0.7))
                            }
                            .padding(.top, 60)
                        } else {
                            ForEach(viewModel.goals.filter { $0.isActive }) { goal in
                                GoalCard(
                                    goal: goal,
                                    progress: viewModel.getGoalProgress(goal, sessions: sessionsViewModel.sessions)
                                ) {
                                    Task {
                                        await viewModel.deleteGoal(goal)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .navigationTitle("Goals")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingAddGoal = true
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.colorPrimaryAccent)
                }
            }
        }
        .sheet(isPresented: $showingAddGoal) {
            AddGoalView { goal in
                Task {
                    await viewModel.saveGoal(goal)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.loadGoals()
                await sessionsViewModel.loadSessions()
            }
        }
    }
}

struct GoalCard: View {
    let goal: Goal
    let progress: (current: Int, target: Int, percentage: Double)
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.title)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.colorPrimaryAccent)
                    
                    Text(goal.period.rawValue)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.colorPrimaryAccent.opacity(0.7))
                }
                
                Spacer()
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.colorSecondaryAccent)
                }
            }
            
            ProgressView(value: progress.percentage)
                .tint(.colorPrimaryAccent)
                .scaleEffect(x: 1, y: 2, anchor: .center)
            
            HStack {
                Text("\(progress.current) / \(progress.target) minutes")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.colorPrimaryAccent.opacity(0.7))
                
                Spacer()
                
                Text("\(Int(progress.percentage * 100))%")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.colorPrimaryAccent)
            }
        }
        .padding(20)
        .background(Color.colorPrimaryAccent.opacity(0.1))
        .cornerRadius(16)
    }
}

struct AddGoalView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var targetMinutes = 60
    @State private var period: GoalPeriod = .daily
    let onSave: (Goal) -> Void
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.colorPrimaryBackground
                    .ignoresSafeArea()
                
                Form {
                    TextField("Goal Title", text: $title)
                        .tint(.colorPrimaryAccent)
                    
                    Stepper("Target: \(targetMinutes) minutes", value: $targetMinutes, in: 15...600, step: 15)
                        .tint(.colorPrimaryAccent)
                    
                    Picker("Period", selection: $period) {
                        ForEach(GoalPeriod.allCases, id: \.self) { period in
                            Text(period.rawValue).tag(period)
                        }
                    }
                    .tint(.colorPrimaryAccent)
                }
                .scrollContentBackground(.hidden)
                .background(Color.colorPrimaryBackground)
            }
            .navigationTitle("New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.colorPrimaryAccent)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let goal = Goal(title: title, targetMinutes: targetMinutes, period: period)
                        onSave(goal)
                        dismiss()
                    }
                    .foregroundColor(.colorPrimaryAccent)
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

