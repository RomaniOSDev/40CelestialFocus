//
//  StatisticsView.swift
//  40CelestialFocus
//
//  Created by Роман Главацкий on 05.01.2026.
//

import SwiftUI

struct StatisticsView: View {
    @StateObject private var viewModel: StatisticsViewModel
    
    init(dataService: DataServiceProtocol) {
        _viewModel = StateObject(wrappedValue: StatisticsViewModel(dataService: dataService))
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
                        // Period selector
                        Picker("Period", selection: $viewModel.selectedPeriod) {
                            ForEach(StatisticsPeriod.allCases, id: \.self) { period in
                                Text(period.rawValue).tag(period)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // Stats cards
                        VStack(spacing: 16) {
                            StatCard(
                                title: "Total Sessions",
                                value: "\(viewModel.totalSessions)",
                                icon: "checkmark.circle.fill",
                                color: .colorPrimaryAccent
                            )
                            
                            StatCard(
                                title: "Total Minutes",
                                value: "\(viewModel.totalMinutes)",
                                icon: "clock.fill",
                                color: .colorPrimaryAccent
                            )
                            
                            StatCard(
                                title: "Average Duration",
                                value: TimeFormatter.formatDuration(viewModel.averageDuration),
                                icon: "chart.bar.fill",
                                color: .colorSecondaryAccent
                            )
                            
                            StatCard(
                                title: "Longest Session",
                                value: TimeFormatter.formatDuration(viewModel.longestSession),
                                icon: "arrow.up.circle.fill",
                                color: .colorSecondaryAccent
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
        }
        .navigationTitle("Statistics")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            Task {
                await viewModel.loadSessions()
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
                .frame(width: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.colorPrimaryAccent.opacity(0.7))
                
                Text(value)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.colorPrimaryAccent)
            }
            
            Spacer()
        }
        .padding(20)
        .background(Color.colorPrimaryAccent.opacity(0.1))
        .cornerRadius(16)
    }
}


