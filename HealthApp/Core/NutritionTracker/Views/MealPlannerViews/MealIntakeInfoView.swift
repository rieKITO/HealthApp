//
//  MealIntakeInfoView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 21.05.2025.
//

import SwiftUI

struct MealIntakeInfoView: View {
    
    // MARK: - Init Properties
    
    var mealIntake: MealIntake
    
    // MARK: - Environment
    
    @Environment(\.dismiss)
    private var dismiss
    
    @Environment(NutritionViewModel.self)
    private var viewModel
    
    // MARK: - Computed Properties
    
    private var totalCalories: Double {
        recipes.reduce(0) { $0 + $1.calories }
    }
    
    private var recipes: [Recipe] {
        viewModel.getMealIntakeRecipes(for: mealIntake)
    }
    
    // MARK: - Body
    
    var body: some View {
        mealIntakeInfoViewHeader
            .padding(.top)
        mealIntakeRecipes
        .safeAreaInset(edge: .bottom, alignment: .center) {
            addRecipeButton
        }
    }
}

// MARK: - Subviews

private extension MealIntakeInfoView {
    
    private var mealIntakeInfoViewHeader: some View {
        ZStack {
            HStack {
                VStack(alignment: .center) {
                    Text(mealIntake.type)
                        .font(.headline)
                        .bold()
                    Text("\(DateFormatterHelper.formatMediumDate(mealIntake.date))")
                        .font(.caption)
                }
            }
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
            HStack {
                Spacer()
                Text(String(format: "%.0f", totalCalories))
                Text("kcal")
            }
            .padding(.trailing)
            .padding(10)
            .bold()
        }
        .foregroundStyle(Color.theme.accentGreen)
    }
    
    private var mealIntakeRecipes: some View {
        ScrollView {
            LazyVStack {
                ForEach(recipes, id: \.id) { recipe in
                    SwipeToDeleteRowView {
                        RecipeRowView(recipe: recipe, showAddButton: false)
                    } deleteAction: {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            viewModel.removeRecipeFromMealIntake(recipe, from: mealIntake)
                        }
                    } onTap: { }
                }
                .padding(.top, 10)
                .padding(.horizontal)
            }
        }
    }
    
    private var addRecipeButton: some View {
        NavigationLink {
            RecipeSearchView(forMealIntake: mealIntake)
                .environment(viewModel)
                .navigationBarBackButtonHidden(true)
        } label: {
            Image(systemName: "plus")
                .font(.title2)
                .foregroundStyle(Color.white)
                .padding()
                .background(
                    Circle()
                        .fill(Color.theme.accentGreen)
                        .shadow(color: Color.theme.accentGreen.opacity(0.7), radius: 10)
                )
        }
    }
    
}

// MARK: - Preview

#Preview("Light Mode") {
    MealIntakeInfoView(mealIntake: DeveloperPreview.instance.mealIntake)
        .environment(DeveloperPreview.instance.nutritionViewModel)
}

#Preview("Dark Mode") {
    MealIntakeInfoView(mealIntake: DeveloperPreview.instance.mealIntake)
        .environment(DeveloperPreview.instance.nutritionViewModel)
        .preferredColorScheme(.dark)
}
