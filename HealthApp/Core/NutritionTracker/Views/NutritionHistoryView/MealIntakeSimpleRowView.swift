//
//  MealIntakeSimpleRowView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 16.05.2025.
//

import SwiftUI

struct MealIntakeSimpleRowView: View {
    
    // MARK: - View Model
    
    @Environment(NutritionViewModel.self)
    private var viewModel
    
    // MARK: - Private Properties
    
    private var totalCalories: Double {
        recipes.reduce(0) { $0 + $1.calories }
    }
    
    // MARK: - Public Properties
    
    var mealIntake: MealIntake
    
    var recipes: [Recipe] {
        viewModel.getMealIntakeRecipes(for: mealIntake)
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            Image(systemName: "fork.knife")
                .foregroundStyle(Color.theme.accentGreen)
                .frame(width: 40, height: 40)
                .background(Circle().fill(Color.theme.mutedGreen))
            Text(mealIntake.type)
                .font(.headline)
            Spacer()
            Text("\(totalCalories, specifier: "%.0f") cal")
                .font(.headline)
        }
        .padding()
        .background(
            RoundedRectangle.init(cornerRadius: 10)
                .fill(Color.theme.secondaryText.opacity(0.07))
        )
    }
}

// MARK: - Preview

#Preview("Light Mode") {
    MealIntakeSimpleRowView(mealIntake: DeveloperPreview.instance.mealIntake)
        .environment(DeveloperPreview.instance.nutritionViewModel)
}

#Preview("Dark Mode") {
    MealIntakeSimpleRowView(mealIntake: DeveloperPreview.instance.mealIntake)
        .environment(DeveloperPreview.instance.nutritionViewModel)
        .preferredColorScheme(.dark)
}
