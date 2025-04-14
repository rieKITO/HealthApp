//
//  TodaySleepSummaryView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 14.04.2025.
//

import SwiftUI

struct TodaySleepSummaryView: View {
    
    // MARK: - View Model
    
    @Bindable
    var viewModel: SleepTrackerViewModel
    
    // MARK: - Properties

    private var lastSleepRecord: SleepData? {
        let today = Calendar.current.startOfDay(for: Date())
        return viewModel.sleepRecords
            .filter { Calendar.current.isDate($0.startTime, inSameDayAs: today) }
            .sorted { $0.startTime > $1.startTime }
            .first
    }
    
    private var dailySleepDuration: TimeInterval {
        viewModel.getDailySleepTimeInterval()
    }
    
    private var dailySleepDurationInHours: TimeInterval {
        dailySleepDuration / 3600
    }
    
    private var progressColor: Color {
        if dailySleepDurationInHours < targetSleepInHours - 2 {
            return .red
        } else if dailySleepDurationInHours > targetSleepInHours + 1 {
            return .orange
        } else {
            return Color.theme.accentGreen
        }
    }

    private let targetSleepInHours: Double = 8.0
    
    private let maxScale: Double = 12.0
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Sleep Summary")
                .font(.headline)
                .foregroundStyle(Color.theme.accentBlue)

            HStack(alignment: .center) {
                Text(DateFormatterHelper.formatDuration(dailySleepDuration))
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(Color.theme.accent)
                Spacer()
                if let sleep = lastSleepRecord,
                   let end = sleep.endTime {
                    VStack {
                        Text("Last sleep:")
                            .font(.caption)
                        Text("\(sleep.startTime.formatted(date: .omitted, time: .shortened)) - \(end.formatted(date: .omitted, time: .shortened))")
                            .font(.subheadline)
                    }
                    .foregroundStyle(Color.theme.secondaryText)
                }
            }
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.theme.secondaryText.opacity(0.2))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(progressColor)
                        .frame(width: max(0, min(CGFloat(dailySleepDurationInHours / maxScale), 1)) * geometry.size.width, height: 8)
                        .animation(.spring(), value: dailySleepDurationInHours)
                }
            }
            .frame(height: 8)
            .padding(.top, 4)
            HStack {
                Text("0h")
                Spacer()
                Text("Target: \(Int(targetSleepInHours))h")
                Spacer()
                Text("\(Int(maxScale))h")
            }
            .font(.caption)
            .foregroundStyle(Color.theme.secondaryText)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.theme.accent.opacity(0.5), lineWidth: 2)
                .fill(Color.theme.background)
        )
        .padding(.horizontal)
    }
}

// MARK: - Preview

#Preview("Light Mode") {
    
    struct Preview: View {
        
        @State
        private var viewModel = SleepTrackerViewModel()
        
        var body: some View {
            TodaySleepSummaryView(viewModel: viewModel)
        }
    }
    
    return Preview()
    
}

#Preview("Dark Mode") {
    
    struct Preview: View {
        
        @State
        private var viewModel = SleepTrackerViewModel()
        
        var body: some View {
            TodaySleepSummaryView(viewModel: viewModel)
                .preferredColorScheme(.dark)
        }
    }
    
    return Preview()
    
}
