//
//  RecipeSearchView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 30.04.2025.
//

import SwiftUI

struct RecipeSearchView: View {
    
    // MARK: - Init Properties
    
    var forMealIntake: MealIntake?
    
    // MARK: - Environment
    
    @Environment(\.dismiss)
    private var dismiss
    
    @Environment(NutritionViewModel.self)
    private var viewModel
    
    // MARK: - State
    
    @State
    private var textFieldText: String = ""
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            recipeSearchHeader
                .padding(.top)
            TextField("Search recipe...", text: $textFieldText)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.theme.accentGreen, lineWidth: 2)
                        .fill(Color.theme.background)
                )
                .padding()
                .onChange(of: textFieldText) { oldValue, newValue  in
                    viewModel.searchRecipes(by: newValue)
                }
            ScrollView {
                LazyVStack {
                    let recipesToShow = textFieldText.isEmpty ? viewModel.allRecipes : viewModel.searchedRecipes
                    if recipesToShow.isEmpty && !textFieldText.isEmpty {
                        Text("No results found.")
                            .foregroundStyle(.secondary)
                            .padding()
                    } else {
                        ForEach(recipesToShow) { recipe in
                            RecipeRowView(recipe: recipe, showAddButton: true, mealIntake: forMealIntake ?? nil)
                                .padding(.horizontal)
                                .padding(.bottom, 8)
                        }
                    }
                }
                .padding(.top, 1)
            }
            Spacer()
        }
    }
}

// MARK: - Subviews

private extension RecipeSearchView {

    private var recipeSearchHeader: some View {
        ZStack {
            Text("Recipe Search")
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
    RecipeSearchView()
        .environment(DeveloperPreview.instance.nutritionViewModel)
}

#Preview("Dark Mode") {
    RecipeSearchView()
        .environment(DeveloperPreview.instance.nutritionViewModel)
        .preferredColorScheme(.dark)
}
