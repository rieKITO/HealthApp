//
//  MealPlannerView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 27.04.2025.
//

import SwiftUI

struct MealPlannerView: View {
    
    // MARK: - Environment
    
    @Environment(\.dismiss)
    private var dismiss
    
    @Environment(NutritionViewModel.self)
    private var viewModel
    
    // MARK: - Body
    
    var body: some View {
        MealPlannerViewHeader
            .padding(.top)
        ScrollView {
            LazyVStack {
                mealIntakes
                Spacer()
            }
            .padding()
        }
    }
}

// MARK: - Subviews

private extension MealPlannerView {
    
    private var MealPlannerViewHeader: some View {
        ZStack {
            Text("Meal Planner")
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
    
    private var mealIntakes: some View {
        ForEach(viewModel.todayMealIntakes) { intake in
            let recipes = viewModel.getMealIntakeRecipes(for: intake)
            MealIntakeRowView(mealIntake: intake, recipes: recipes)
        }
    }
    
}

// MARK: - Preview

#Preview("Light Mode") {
    MealPlannerView()
        .environment(DeveloperPreview.instance.nutritionViewModel.self)
}

#Preview("Dark Mode") {
    MealPlannerView()
        .environment(DeveloperPreview.instance.nutritionViewModel.self)
        .preferredColorScheme(.dark)
}
