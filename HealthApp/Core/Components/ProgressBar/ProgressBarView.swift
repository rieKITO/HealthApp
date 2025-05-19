//
//  ProgressBarView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 19.05.2025.
//

import Foundation
import SwiftUI

struct ProgressBarView: View {
    
    // MARK: - Public Properties
    
    let currentValue: Double
    
    let maxValue: Double
    
    let targetValue: Double
    
    let color: Color
    
    let height: CGFloat
    
    // MARK: - Private Properties
    
    private var progress: Double {
        max(0, min(currentValue / maxValue, 1))
    }
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.theme.secondaryText.opacity(0.2))
                    .frame(height: height)
                RoundedRectangle(cornerRadius: 4)
                    .fill(color)
                    .frame(width: CGFloat(progress) * geometry.size.width, height: height)
                    .animation(.spring(), value: progress)
                if targetValue < maxValue {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white)
                        .frame(width: 2, height: height + 4)
                        .offset(x: CGFloat(targetValue / maxValue) * geometry.size.width - 1)
                        .shadow(radius: 2)
                }
            }
        }
        .frame(height: height)
    }
}

// MARK: - Preview

#Preview() {
    ProgressBarView(
        currentValue: 2,
        maxValue: 4,
        targetValue: 3,
        color: Color.theme.accentGreen,
        height: 8
    )
}
