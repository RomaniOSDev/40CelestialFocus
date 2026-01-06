//
//  HistoryView.swift
//  40CelestialFocus
//
//  Created by Роман Главацкий on 05.01.2026.
//

import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel: HistoryViewModel
    
    init(dataService: DataServiceProtocol) {
        _viewModel = StateObject(wrappedValue: HistoryViewModel(dataService: dataService))
    }
    
    var body: some View {
        ZStack {
            Color.colorPrimaryBackground
                .ignoresSafeArea()
            
            if viewModel.isLoading {
                ProgressView()
                    .tint(.colorPrimaryAccent)
            } else if viewModel.sessions.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "moon.stars")
                        .font(.system(size: 48))
                        .foregroundColor(.colorPrimaryAccent.opacity(0.5))
                    Text("No sessions yet")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.colorPrimaryAccent.opacity(0.7))
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.sessions, id: \.id) { session in
                            SessionRowView(session: session)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            Task {
                await viewModel.loadSessions()
            }
        }
        .refreshable {
            await viewModel.loadSessions()
        }
    }
}

struct SessionRowView: View {
    let session: FocusSession
    
    var body: some View {
        HStack(spacing: 16) {
            // Success indicator
            Image(systemName: session.isSuccessful ? "circle.fill" : "circle")
                .font(.system(size: 12))
                .foregroundColor(session.isSuccessful ? .colorSecondaryAccent : .colorPrimaryAccent.opacity(0.3))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(formatDate(session.date))
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.colorPrimaryAccent)
                
                Text(TimeFormatter.formatDuration(session.duration))
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.colorPrimaryAccent.opacity(0.7))
            }
            
            Spacer()
            
            if session.isSuccessful {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.colorSecondaryAccent)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color.colorPrimaryAccent.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

