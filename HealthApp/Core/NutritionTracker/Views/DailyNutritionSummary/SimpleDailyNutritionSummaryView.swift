//
//  SimpleDailyNutritionSummaryView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 24.05.2025.
//

import SwiftUI

struct SimpleDailyNutritionSummaryView: View {
    
    // MARK: - Environment
    
    @Environment(NutritionViewModel.self)
    private var viewModel
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading) {
            header
                .padding(.bottom)
            totalCalories
                .padding(.bottom)
            progressBar
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.theme.mutedGreen.opacity(0.7))
        )
    }
}

// MARK: - Subviews

private extension SimpleDailyNutritionSummaryView {
    
    private var header: some View {
        HStack {
            Image(systemName: "calendar")
                .font(.title2)
                .frame(width: 30, height: 30)
                .foregroundStyle(Color.theme.accentGreen)
            Text("Today's Plan")
                .font(.headline)
                .bold()
        }
    }
    
    private var totalCalories: some View {
        HStack {
            Text("Total calories")
            Spacer()
            Text("\(Int(viewModel.todayCalories)) kcal")
        }
        .font(.subheadline)
        .foregroundStyle(Color.theme.secondaryText)
    }
    
    private var progressBar: some View {
        Group {
            HStack {
                Text("0 kcal")
                Spacer()
                Text("\(Int(viewModel.targetCalories)) kcal")
            }
            .font(.caption)
            ProgressBarView(
                currentValue: viewModel.todayCalories,
                maxValue: viewModel.targetCalories,
                targetValue: viewModel.targetCalories,
                color: Color.theme.accentGreen,
                height: 8
            )
        }
    }
    
}

// MARK: - Preview

#Preview("Light Mode") {
    SimpleDailyNutritionSummaryView()
        .environment(DeveloperPreview.instance.nutritionViewModel)
}

#Preview("Dark Mode") {
    SimpleDailyNutritionSummaryView()
        .environment(DeveloperPreview.instance.nutritionViewModel)
        .preferredColorScheme(.dark)
}
