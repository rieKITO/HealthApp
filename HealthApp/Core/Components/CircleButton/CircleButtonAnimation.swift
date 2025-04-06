//
//  CircleButtonAnimation.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 23.03.2025.
//

import SwiftUI

struct CircleButtonAnimation: View {
    
    @Binding
    var animate: Bool
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 5)
            .scale(animate ? 1 : 0)
            .opacity(animate ? 0 : 1)
            .foregroundStyle(Color.theme.accent)
            .animation(
                animate ? .easeOut(duration: 0.5) : .none,
                value: animate
            )
//            .onAppear {
//                animate = true
//            }
    }
}

#Preview {
    CircleButtonAnimation(animate: .constant(false))
        .frame(width: 100, height: 100)
}

