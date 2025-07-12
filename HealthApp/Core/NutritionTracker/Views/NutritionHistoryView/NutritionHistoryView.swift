//
//  NutritionHistoryView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 14.05.2025.
//

import SwiftUI

struct NutritionHistoryView: View {
    
    // MARK: - Environment
    
    @Environment(NutritionViewModel.self)
    private var viewModel
    
    @Environment(\.dismiss)
    private var dismiss
    
    // MARK: - Computed Properties
    
    private var groupedMealIntakes: [Date: [MealIntake]] {
        Dictionary(grouping: viewModel.allMealIntakes) { intake in
            Calendar.current.startOfDay(for: intake.date)
        }
    }
    
    private var sortedDates: [Date] {
        groupedMealIntakes.keys.sorted(by: >)
    }
    
    // MARK: - Body
    
    var body: some View {
        NutritionHistoryViewHeader
            .padding(.top)
        ScrollView {
            NutritionWeeklyOverviewView()
            LazyVStack(alignment: .leading) {
                Text("Meal History")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(Color.theme.accentGreen)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                ForEach(sortedDates, id: \.self) { date in
                    if let intakes = groupedMealIntakes[date] {
                        MealIntakeGroupView(mealIntakes: intakes)
                            .padding(.bottom)
                    }
                }
            }
        }
    }
}

// MARK: - Subviews

private extension NutritionHistoryView {
    
    private var NutritionHistoryViewHeader: some View {
        ZStack {
            Text("Nutrition History")
                .font(.headline)
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, alignment: .center)
            HStack {
                Image(systemName: "chevron.left")
                    .font(.headline)
                    .onTapGesture {
                        dismiss.callAsFunction()
                    }
                    .padding(.leading)
                Spacer()
            }
            .padding(10)
        }
        .foregroundStyle(Color.theme.accentGreen)
    }
    
}

// MARK: - Preview

#Preview("Light Mode") {
    NutritionHistoryView()
        .environment(DeveloperPreview.instance.nutritionViewModel)
}

#Preview("Dark Mode") {
    NutritionHistoryView()
        .environment(DeveloperPreview.instance.nutritionViewModel)
        .preferredColorScheme(.dark)
}
