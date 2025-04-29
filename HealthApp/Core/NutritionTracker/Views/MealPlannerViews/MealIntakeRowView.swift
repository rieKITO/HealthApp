//
//  MealIntakeRowView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 27.04.2025.
//

import SwiftUI

struct MealIntakeRowView: View {
    
    var mealIntake: MealIntake
    
    var recipes: [Recipe]
    
    private var totalCalories: Double {
        recipes.reduce(0) { $0 + $1.calories }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            mealIntakeRowHeader
            Group {
                recipesList
                addFoodItemButton
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
            Image(systemName: "fork.knife")
                .foregroundStyle(Color.theme.accentGreen)
                .frame(width: 40, height: 40)
                .background(Circle().fill(Color.theme.mutedGreen))
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
    
    struct Preview: View {
        
        @State
        private var mealIntake = DeveloperPreview.instance.mealIntake
        
        private var recipes: [Recipe] = [
            DeveloperPreview.instance.recipe,
            DeveloperPreview.instance.recipe
        ]
        
        var body: some View {
            MealIntakeRowView(mealIntake: mealIntake, recipes: recipes)
        }
    }
    
    return Preview()
    
}

#Preview("Dark Mode") {
    
    struct Preview: View {
        
        @State
        private var mealIntake = DeveloperPreview.instance.mealIntake
        
        private var recipes: [Recipe] = [
            DeveloperPreview.instance.recipe,
            DeveloperPreview.instance.recipe
        ]
        
        var body: some View {
            MealIntakeRowView(mealIntake: mealIntake, recipes: recipes)
                .preferredColorScheme(.dark)
        }
    }
    
    return Preview()
    
}
