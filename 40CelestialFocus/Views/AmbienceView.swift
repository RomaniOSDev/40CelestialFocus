//
//  AmbienceView.swift
//  40CelestialFocus
//
//  Created by Роман Главацкий on 05.01.2026.
//

import SwiftUI

struct AmbienceView: View {
    @StateObject private var viewModel = AmbienceViewModel()
    
    var body: some View {
        ZStack {
            Color.colorPrimaryBackground
                .ignoresSafeArea()
            
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(viewModel.ambiences) { ambience in
                        AmbienceCard(
                            ambience: ambience,
                            isSelected: viewModel.selectedAmbience?.id == ambience.id
                        ) {
                            viewModel.selectAmbience(ambience)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .navigationTitle("Ambience")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct AmbienceCard: View {
    let ambience: Ambience
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: ambience.iconName)
                    .font(.system(size: 40))
                    .foregroundColor(isSelected ? Color(hex: ambience.color) : .colorPrimaryAccent.opacity(0.5))
                
                Text(ambience.name)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(isSelected ? .colorPrimaryAccent : .colorPrimaryAccent.opacity(0.7))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.colorPrimaryAccent.opacity(0.2) : Color.colorPrimaryAccent.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color.colorPrimaryAccent : Color.clear, lineWidth: 2)
                    )
            )
        }
    }
}



