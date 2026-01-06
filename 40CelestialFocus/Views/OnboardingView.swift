//
//  OnboardingView.swift
//  40CelestialFocus
//
//  Created by Роман Главацкий on 05.01.2026.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isPresented: Bool
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            Color.colorPrimaryBackground
                .ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                OnboardingPage(
                    title: "Welcome to Celestial Focus",
                    description: "Focus on your tasks while watching beautiful celestial animations grow with your progress.",
                    icon: "moon.stars.fill",
                    pageIndex: 0
                )
                .tag(0)
                
                OnboardingPage(
                    title: "Build Your System",
                    description: "Each successful focus session adds a moon to your planetary system. Complete 5 moons to finish a system!",
                    icon: "globe",
                    pageIndex: 1
                )
                .tag(1)
                
                OnboardingPage(
                    title: "Track Your Progress",
                    description: "View statistics, achievements, and set goals to stay motivated and focused.",
                    icon: "chart.bar.fill",
                    pageIndex: 2
                )
                .tag(2)
                
                OnboardingPage(
                    title: "Get Started",
                    description: "Choose your focus duration and start your first session. Let's begin your journey!",
                    icon: "play.circle.fill",
                    pageIndex: 3,
                    isLast: true,
                    onGetStarted: {
                        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                        isPresented = false
                    }
                )
                .tag(3)
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
    }
}

struct OnboardingPage: View {
    let title: String
    let description: String
    let icon: String
    let pageIndex: Int
    var isLast: Bool = false
    var onGetStarted: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Icon
            Image(systemName: icon)
                .font(.system(size: 80))
                .foregroundColor(.colorPrimaryAccent)
                .padding(.bottom, 20)
            
            // Title
            Text(title)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.colorPrimaryAccent)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            // Description
            Text(description)
                .font(.system(size: 18, weight: .regular, design: .rounded))
                .foregroundColor(.colorPrimaryAccent.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            
            // Button
            if isLast {
                Button(action: {
                    onGetStarted?()
                }) {
                    Text("Get Started")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.colorPrimaryAccent)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 60)
            }
        }
    }
}


