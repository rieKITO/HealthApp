//
//  MealIntakeRowView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 27.04.2025.
//

import SwiftUI

struct MealIntakeRowView: View {
    
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
        VStack(alignment: .leading) {
            mealIntakeRowHeader
            Group {
                recipesList
                HStack {
                    NavigationLink {
                        RecipeSearchView(forMealIntake: mealIntake)
                            .environment(viewModel)
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        addFoodItemButton
                    }
                    Spacer()
                    NavigationLink {
                        MealIntakeInfoView(mealIntake: mealIntake)
                            .environment(viewModel)
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Image(systemName: "arrow.right")
                            .font(.headline)
                            .foregroundStyle(Color.theme.accent)
                    }
                }
            }
            .padding(.leading, 50)
            .padding(.vertical, recipes.count > 0 ? 5 : 1)
        }
        .padding()
        .background(
            RoundedRectangle.init(cornerRadius: 10)
                .stroke(Color.theme.accent.opacity(0.3), lineWidth: 2)
                .fill(Color.theme.background)
        )
    }
}

// MARK: - Subviews

private extension MealIntakeRowView {
    
    private var mealIntakeRowHeader: some View {
            HStack {
                CircleButtonView(
                    iconName: "fork.knife",
                    shadowColor: Color.theme.background,
                    circleColor: Color.theme.mutedGreen
                )
                .foregroundStyle(Color.theme.accentGreen)
                VStack(alignment: .leading) {
                    Text(mealIntake.type)
                        .font(.headline)
                    HStack {
                        Image(systemName: "clock")
                            .font(.caption)
                        Text(mealIntake.date, style: .time)
                            .font(.subheadline)
                    }
                    .foregroundStyle(Color.theme.secondaryText)
                }
                Spacer()
                Text("\(totalCalories, specifier: "%.0f") cal")
                    .font(.headline)
            }
        }
    
    private var recipesList: some View {
        VStack {
            ForEach(recipes, id: \.id) { recipe in
                HStack {
                    Circle()
                        .fill(Color.theme.accentGreen)
                        .frame(width: 8, height: 8)
                    Text(recipe.title)
                    Spacer()
                    Text(recipe.caloriesText)
                        .foregroundColor(Color.theme.secondaryText)
                }
                .font(.subheadline)
            }
        }
    }
    
    private var addFoodItemButton: some View {
        Text("+ Add food item")
            .foregroundStyle(Color.theme.accentGreen)
            .font(.subheadline)
    }
    
}

// MARK: - Preview

#Preview("Light Mode") {
    MealIntakeRowView(mealIntake: DeveloperPreview.instance.mealIntake)
        .environment(DeveloperPreview.instance.nutritionViewModel)
}

#Preview("Dark Mode") {
    MealIntakeRowView(mealIntake: DeveloperPreview.instance.mealIntake)
        .environment(DeveloperPreview.instance.nutritionViewModel)
        .preferredColorScheme(.dark)
}

