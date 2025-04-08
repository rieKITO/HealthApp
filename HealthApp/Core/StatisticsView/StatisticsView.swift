//
//  StatisticsView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 27.03.2025.
//

import SwiftUI

struct StatisticsView: View {
    
    @State
    var sleepViewModel = SleepTrackerViewModel()
    
    // MARK: - Body
    
    var body: some View {
        SleepWeeklyOverviewView(viewModel: sleepViewModel)
    }
}

// MARK: - Preview

#Preview("Light Mode") {
    StatisticsView()
}

#Preview("Dark Mode") {
    StatisticsView()
        .preferredColorScheme(.dark)
}
