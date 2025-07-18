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
    
    // MARK: - Computed Properties

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
    
    // MARK: - Private Properties
    
    private let targetSleepInHours: Double = 8.0
    
    private let maxScale: Double = 12.0
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            todaySleepSummaryViewHeader
            dailySleepInfo
            ProgressBarView(
                currentValue: dailySleepDurationInHours,
                maxValue: maxScale,
                targetValue: targetSleepInHours,
                color: progressColor,
                height: 8
            )
            .padding(.top, 4)
            scaleLabelsView
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

// MARK: - Subviews

private extension TodaySleepSummaryView {
    
    private var todaySleepSummaryViewHeader: some View {
        Text("Today's Sleep Summary")
            .font(.headline)
            .foregroundStyle(Color.theme.accentBlue)
    }
    
    private var dailySleepInfo: some View {
        HStack(alignment: .center) {
            Text(DateFormatterHelper.formatDuration(dailySleepDuration))
                .font(.title)
                .bold()
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
    }
    
    private var scaleLabelsView: some View {
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
    
}

// MARK: - Preview

#Preview("Light Mode") {
    TodaySleepSummaryView(viewModel: DeveloperPreview.instance.sleepTrackerViewModel)
}

#Preview("Dark Mode") {
    TodaySleepSummaryView(viewModel: DeveloperPreview.instance.sleepTrackerViewModel)
        .preferredColorScheme(.dark)
}
