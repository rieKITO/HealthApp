//
//  SleepWeeklyOverviewView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 06.04.2025.
//

import SwiftUI
import Charts

struct SleepWeeklyOverviewView: View {
    
    // MARK: View Model
    
    @Bindable
    var viewModel: SleepTrackerViewModel
    
    // MARK: - State
    
    @State
    private var animatedEntries: [AnimatedChartEntry] = []
    
    // MARK: - Body
    
    var body: some View {
        AnimatedBarChartView(
            entries: $animatedEntries,
            title: "Weekly Sleep",
            valueSuffix: "hours",
            averageValue: viewModel.getAverageSleep(),
            bestValue: viewModel.getBestSleep(),
            worstValue: viewModel.getWorstSleep(),
            valueFormatter: DateFormatterHelper.formatDuration,
            titleColor: Color.theme.accentBlue
        )
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
    
    private func setupAnimatedEntries() {
        let realEntries = viewModel.lastWeekSleep()
        animatedEntries = realEntries.map {
            AnimatedChartEntry(
                date: $0.date,
                targetValue: $0.hours,
                animatedValue: 0,
                color: Color.theme.accentBlue
            )
        }
    }

    private func animateBars() {
        for index in animatedEntries.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    animatedEntries[index].animatedValue = animatedEntries[index].targetValue
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
