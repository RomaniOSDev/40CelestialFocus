//
//  CelestialSystemView.swift
//  40CelestialFocus
//
//  Created by Роман Главацкий on 05.01.2026.
//

import SwiftUI

struct CelestialSystemView: View {
    let moonCount: Int
    let isAnimating: Bool
    
    private let planetRadius: CGFloat = 25
    private let orbitRadius: CGFloat = 100
    private let moonRadius: CGFloat = 8
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                
                // Draw central planet
                let planetPath = Path { path in
                    path.addEllipse(in: CGRect(
                        x: center.x - planetRadius,
                        y: center.y - planetRadius,
                        width: planetRadius * 2,
                        height: planetRadius * 2
                    ))
                }
                context.fill(planetPath, with: .color(.colorPrimaryAccent.opacity(0.3)))
                
                // Draw orbit circle (subtle)
                let orbitPath = Path { path in
                    path.addEllipse(in: CGRect(
                        x: center.x - orbitRadius,
                        y: center.y - orbitRadius,
                        width: orbitRadius * 2,
                        height: orbitRadius * 2
                    ))
                }
                context.stroke(orbitPath, with: .color(.colorPrimaryAccent.opacity(0.2)), lineWidth: 1)
                
                // Draw moons
                if moonCount > 0 {
                    let time = timeline.date.timeIntervalSince1970
                    let rotationSpeed: Double = isAnimating ? 0.5 : 0.1
                    let baseAngle = time * rotationSpeed
                    let actualMoonCount = min(moonCount, 5)
                    
                    for i in 0..<actualMoonCount {
                        let angle = baseAngle + (Double(i) * 2 * .pi / Double(actualMoonCount))
                        let moonX = center.x + cos(angle) * orbitRadius
                        let moonY = center.y + sin(angle) * orbitRadius
                        
                        let moonPath = Path { path in
                            path.addEllipse(in: CGRect(
                                x: moonX - moonRadius,
                                y: moonY - moonRadius,
                                width: moonRadius * 2,
                                height: moonRadius * 2
                            ))
                        }
                        context.fill(moonPath, with: .color(.colorSecondaryAccent))
                    }
                }
            }
        }
    }
}

