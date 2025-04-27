//
//  CircleButtonView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 23.03.2025.
//

import SwiftUI

struct CircleButtonView: View {
    
    let iconName: String
    
    let shadowColor: Color?
    
    let circleColor: Color?
    
    init(iconName: String, shadowColor: Color? = nil, circleColor: Color? = nil) {
        self.iconName = iconName
        self.shadowColor = shadowColor
        self.circleColor = circleColor
    }
    
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .foregroundStyle(circleColor ?? Color.theme.background)
            )
            .shadow(
                color: (shadowColor ?? Color.theme.accent).opacity(0.40),
                radius: 10,
                x: 0,
                y: 0
            )
    }
}

#Preview("Light Mode") {
    CircleButtonView(iconName: "info", shadowColor: .purple)
}

#Preview("Dark Mode") {
    CircleButtonView(iconName: "info")
        .preferredColorScheme(.dark)
}

