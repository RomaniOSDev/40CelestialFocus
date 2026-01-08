//
//  FocusModesView.swift
//  40CelestialFocus
//
//  Created by Роман Главацкий on 05.01.2026.
//

import SwiftUI

struct FocusModesView: View {
    @StateObject private var viewModel = FocusModesViewModel()
    @Environment(\.dismiss) private var dismiss
    let onModeSelected: (TimeInterval) -> Void
    
    var body: some View {
        ZStack {
            Color.colorPrimaryBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.modes) { mode in
                        FocusModeCard(mode: mode) {
                            viewModel.selectMode(mode)
                            onModeSelected(mode.duration)
                            dismiss()
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .navigationTitle("Focus Modes")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct FocusModeCard: View {
    let mode: FocusMode
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: mode.iconName)
                    .font(.system(size: 32))
                    .foregroundColor(Color(hex: mode.color))
                    .frame(width: 50)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(mode.name)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.colorPrimaryAccent)
                    
                    Text(mode.description)
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(.colorPrimaryAccent.opacity(0.7))
                }
                
                Spacer()
                
                Text(TimeFormatter.formatDuration(mode.duration))
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.colorPrimaryAccent.opacity(0.7))
            }
            .padding(20)
            .background(Color.colorPrimaryAccent.opacity(0.1))
            .cornerRadius(16)
        }
    }
}



