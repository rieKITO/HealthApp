//
//  IntroView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 24.03.2025.
//

import SwiftUI

struct IntroView: View {
    
    // MARK: - App Storage Properties
    
    @AppStorage("signed_in")
    private var currentUserSignedIn: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // background
            Color.theme.background
                .ignoresSafeArea()
            
            // foreground
            if currentUserSignedIn {
                NavigationStack {
                    HomeView()
                        .toolbar(.hidden)
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom),
                            removal: .move(edge: .top))
                        )
                }
            } else {
                OnboardingView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .top),
                        removal: .move(edge: .bottom))
                    )
            }
        }
        .animation(.spring(), value: currentUserSignedIn)
        
    }
}

#Preview {
    IntroView()
}

