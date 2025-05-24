//
//  TodayNutritionSummaryView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 20.05.2025.
//

import SwiftUI

struct TodayNutritionSummaryView: View {
    
    // MARK: View Model
    
    @Environment(NutritionViewModel.self)
    private var viewModel
    
    // MARK: - Computed Properties
    
    private var progressColor: Color {
        switch viewModel.caloriesRatio {
        case ..<0.85: return .red
        case 0.85..<0.95: return .orange
        case 0.95...1.05: return .green
        case 1.05...1.15: return .orange
        default: return .red
        }
    }
    
    private var maxCalories: Double {
        max(viewModel.targetCalories * 1.5, 3000)
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            todayNutritionSummaryViewHeader
            caloriesInfoView
            ProgressBarView(
                currentValue: viewModel.todayCalories,
                maxValue: maxCalories,
                targetValue: viewModel.targetCalories,
                color: progressColor,
                height: 8
            )
            .padding(.top, 4)
            scaleLabelsView
            dailyNutriesntsView
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

private extension TodayNutritionSummaryView {
    
    private var todayNutritionSummaryViewHeader: some View {
        Text("Today's Nutrition Summary")
            .font(.headline)
            .foregroundStyle(Color.theme.accentGreen)
    }
    
    private var caloriesInfoView: some View {
        HStack(alignment: .center) {
            Text("\(Int(viewModel.todayCalories)) kcal")
                .font(.title)
                .bold()
            Spacer()
            VStack(alignment: .trailing) {
                Text("Daily Target:")
                    .font(.caption)
                Text("\(Int(viewModel.targetCalories)) kcal")
                    .font(.subheadline)
            }
            .foregroundStyle(Color.theme.secondaryText)
        }
    }
    
    private var scaleLabelsView: some View {
        ZStack {
            Text("\(Int(viewModel.targetCalories)) kcal")
                .bold()
            HStack {
                Text("0 kcal")
                Spacer()
                Text("\(Int(maxCalories)) kcal")
            }
            
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
    }
    
    private var dailyNutriesntsView: some View {
        ZStack {
            nutrientColumn(title: "Carbs", value: "\(viewModel.getDailyCarbs().asNumberString())g")
            HStack {
                nutrientColumn(title: "Protein", value: "\(viewModel.getDailyProtein().asNumberString())g")
                Spacer()
                nutrientColumn(title: "Fats", value: "\(viewModel.getDailyFat().asNumberString())g")
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func nutrientColumn(title: String, value: String) -> some View {
        VStack {
            Text(title)
                .foregroundStyle(Color.theme.secondaryText)
                .font(.subheadline)
            Text(value)
                .font(.headline)
        }
    }
    
}

// MARK: - Preview

#Preview("Light Mode") {
    TodayNutritionSummaryView()
        .environment(DeveloperPreview.instance.nutritionViewModel)
}

#Preview("Dark Mode") {
    TodayNutritionSummaryView()
        .environment(DeveloperPreview.instance.nutritionViewModel)
        .preferredColorScheme(.dark)
}
