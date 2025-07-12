//
//  RecipeRowView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 30.04.2025.
//

import SwiftUI

struct RecipeRowView: View {
    
    // MARK: - Init Properties
    
    let recipe: Recipe
    
    let showAddButton: Bool
    
    var mealIntake: MealIntake?
    
    // MARK: - View Model
    
    @Environment(NutritionViewModel.self)
    private var viewModel
    
    // MARK: - State
    
    @State
    private var showMealPicker = false
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            recipeHeader
            recipeInfo
            if showAddButton {
                if let mealIntake {
                    addButtonLabel(label: mealIntake.type)
                        .onTapGesture {
                            viewModel.addRecipeToMealIntake(recipe, to: mealIntake)
                        }
                } else {
                    Button {
                        showMealPicker.toggle()
                    } label: {
                        addButtonLabel(label: "Today")
                    }
                    .confirmationDialog("Select Meal", isPresented: $showMealPicker) {
                        ForEach(viewModel.todayMealIntakes) { intake in
                            Button(intake.type) {
                                viewModel.addRecipeToMealIntake(recipe, to: intake)
                            }
                        }
                    }
                }
            }
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

private extension RecipeRowView {
    
    private var recipeHeader: some View {
        HStack {
            Text(recipe.title)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.6, alignment: .leading)
                .multilineTextAlignment(.leading)
            Spacer()
            VStack {
                Text(recipe.caloriesText)
                Text("per serving")
                    .foregroundStyle(Color.theme.secondaryText)
                    .font(.caption)
            }
        }
        .font(.headline)
    }
    
    private var recipeInfo: some View {
        HStack {
            nutrientColumn(title: "Protein", value: "\(recipe.protein.asNumberString())g")
            Spacer()
            nutrientColumn(title: "Carbs", value: "\(recipe.carbs.asNumberString())g")
            Spacer()
            nutrientColumn(title: "Fats", value: "\(recipe.fat.asNumberString())g")
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .frame(maxWidth: 330)
    }

    
    private func nutrientColumn(title: String, value: String) -> some View {
        VStack {
            Text(title)
                .foregroundStyle(Color.theme.secondaryText)
                .font(.subheadline)
            Text(value)
                .font(.headline)
        }
        .frame(width: 100, height: 55)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .foregroundStyle(Color.theme.secondaryText.opacity(0.1))
        )
    }
    
    private func addButtonLabel(label: String) -> some View {
        return Text("Add to \(label)")
            .foregroundStyle(Color.theme.accentGreen)
            .bold()
            .frame(maxWidth: .infinity)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color.theme.mutedGreen.opacity(1))
            )
    }
    
}

// MARK: - Preview

#Preview("Light Mode") {
    Group {
        RecipeRowView(recipe: DeveloperPreview.instance.recipe, showAddButton: true)
        RecipeRowView(recipe: DeveloperPreview.instance.recipe, showAddButton: false)
    }
    .environment(DeveloperPreview.instance.nutritionViewModel)
}

#Preview("Dark Mode") {
    Group {
        RecipeRowView(recipe: DeveloperPreview.instance.recipe, showAddButton: true)
        RecipeRowView(recipe: DeveloperPreview.instance.recipe, showAddButton: false)
    }
    .environment(DeveloperPreview.instance.nutritionViewModel)
    .preferredColorScheme(.dark)
}
