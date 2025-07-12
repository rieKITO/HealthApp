//
//  StatisticsView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 27.03.2025.
//

import SwiftUI

struct StatisticsView: View {
    
    // MARK: - View Model
    
    @State
    var sleepViewModel = SleepTrackerViewModel()
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            SleepWeeklyOverviewView(viewModel: sleepViewModel)
            NutritionWeeklyOverviewView()
        }
    }
}

// MARK: - Preview

#Preview("Light Mode") {
    StatisticsView()
        .environment(DeveloperPreview.instance.nutritionViewModel)
}

#Preview("Dark Mode") {
    StatisticsView()
        .environment(DeveloperPreview.instance.nutritionViewModel)
        .preferredColorScheme(.dark)
}
