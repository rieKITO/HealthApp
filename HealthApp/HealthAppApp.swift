//
//  HealthAppApp.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 23.03.2025.
//

import SwiftUI

@main
struct HealthAppApp: App {
    
    // MARK: - App Storage
    
    @AppStorage("dark_mode")
    private var darkMode: Bool = false
    
    // MARK: - Init
    
    init() {
        NotificationManager.instance.requestAuthorization()
    }
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            IntroView()
                .preferredColorScheme(darkMode ? .dark : .light)
        }
    }
}
