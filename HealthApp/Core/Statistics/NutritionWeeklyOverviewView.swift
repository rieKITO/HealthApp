//
//  NutritionWeeklyOverviewView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 17.05.2025.
//

import Foundation
import SwiftUI

struct NutritionWeeklyOverviewView: View {
    
    // MARK: - View Model
    
    @Environment(NutritionViewModel.self)
    private var viewModel
    
    // MARK: - State
    
    @State
    private var animatedEntries: [AnimatedChartEntry] = []
    
    // MARK: - Body
    
    var body: some View {
        AnimatedBarChartView(
            entries: $animatedEntries,
            title: "Weekly Calories",
            valueSuffix: "cal",
            averageValue: viewModel.getAverageCalories(),
            bestValue: viewModel.getMaxCalories(),
            worstValue: viewModel.getMinCalories(),
            valueFormatter: { "\(Int($0))" },
            titleColor: Color.theme.accentGreen
        )
        .onAppear {
            setupAnimatedEntries()
            animateBars()
        }
        .onChange(of: viewModel.allMealIntakes) {
            setupAnimatedEntries()
            animateBars()
        }
    }
    
}

// MARK: - Setup

private extension NutritionWeeklyOverviewView {
    
    private func setupAnimatedEntries() {
        let dailyCalories = viewModel.getLastWeekCalories()
        animatedEntries = dailyCalories.map {
            AnimatedChartEntry(
                date: $0.date,
                targetValue: $0.calories,
                animatedValue: 0,
                color: Color.theme.accentGreen
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
    NutritionWeeklyOverviewView()
        .environment(DeveloperPreview.instance.nutritionViewModel)
}

#Preview("Dark Mode") {
    NutritionWeeklyOverviewView()
        .environment(DeveloperPreview.instance.nutritionViewModel)
        .preferredColorScheme(.dark)
}
