//
//  SleepWeeklyOverviewView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 06.04.2025.
//

import SwiftUI
import Charts

struct SleepWeeklyOverviewView: View {
    
    @Bindable
    var viewModel: SleepHistoryViewModel
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Weekly Overview")
                .font(.title2)
                .bold()
                .foregroundStyle(Color.theme.accentBlue)
            Chart {
                ForEach(viewModel.last7DaysSleep(), id: \.date) { entry in
                    BarMark(
                        x: .value("Date", entry.date, unit: .day),
                        y: .value("Hours", entry.hours)
                    )
                    .foregroundStyle(Color.theme.accentBlue)
                }
            }
            .frame(height: 200)
            HStack {
                Text("Average: \(DateFormatterHelper.formatDuration(viewModel.getAverageSleep()))")
                Spacer()
                Text("Best: \(DateFormatterHelper.formatDuration(viewModel.getBestSleep()))")
                Spacer()
                Text("Worst: \(DateFormatterHelper.formatDuration(viewModel.getWorstSleep()))")
            }
            .font(.caption)
            .padding(.top, 5)
        }
        .padding()
    }
}

// MARK: - Preview

#Preview("Light Mode") {
    
    struct Preview: View {
        
        @State var viewModel: SleepHistoryViewModel = SleepHistoryViewModel()
        
        var body: some View {
            SleepWeeklyOverviewView(viewModel: viewModel)
        }
    }
    
    return Preview()
}

#Preview("Dark Mode") {
    
    struct Preview: View {
        
        @State var viewModel: SleepHistoryViewModel = SleepHistoryViewModel()
        
        var body: some View {
            SleepWeeklyOverviewView(viewModel: viewModel)
                .preferredColorScheme(.dark)
        }
    }
    
    return Preview()
}
