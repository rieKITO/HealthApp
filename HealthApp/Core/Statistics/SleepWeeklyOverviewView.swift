//
//  SleepWeeklyOverviewView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 06.04.2025.
//

import SwiftUI
import Charts

struct AnimatedSleepEntry: Identifiable {
    let id = UUID()
    let date: Date
    let targetHours: Double
    var animatedHours: Double
}

struct SleepWeeklyOverviewView: View {
    
    // MARK: View Model
    
    @Bindable
    var viewModel: SleepTrackerViewModel
    
    // MARK: - State
    
    @State
    private var animatedEntries: [AnimatedSleepEntry] = []
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Weekly Overview")
                .font(.title2)
                .bold()
                .foregroundStyle(Color.theme.accentBlue)
            Chart {
                ForEach(animatedEntries) { entry in
                    BarMark(
                        x: .value("Date", entry.date, unit: .day),
                        y: .value("Hours", entry.animatedHours)
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
        .onAppear {
            setupAnimatedEntries()
            animateBars()
        }
        .onChange(of: viewModel.sleepRecords) {
            setupAnimatedEntries()
            animateBars()
        }
    }
}

// MARK: - Setup

private extension SleepWeeklyOverviewView {
    
    func setupAnimatedEntries() {
        let realEntries = viewModel.last7DaysSleep()
        animatedEntries = realEntries.map {
            AnimatedSleepEntry(date: $0.date, targetHours: $0.hours, animatedHours: 0)
        }
    }

    func animateBars() {
        for index in animatedEntries.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    animatedEntries[index].animatedHours = animatedEntries[index].targetHours
                }
            }
        }
    }
    
}

// MARK: - Preview

#Preview("Light Mode") {
    
    struct Preview: View {
        
        @State
        private var viewModel = SleepTrackerViewModel()
        
        var body: some View {
            SleepWeeklyOverviewView(viewModel: viewModel)
        }
    }
    
    return Preview()
    
}

#Preview("Dark Mode") {
    
    struct Preview: View {
        
        @State
        private var viewModel = SleepTrackerViewModel()
        
        var body: some View {
            SleepWeeklyOverviewView(viewModel: viewModel)
                .preferredColorScheme(.dark)
        }
    }
    
    return Preview()
    
}
