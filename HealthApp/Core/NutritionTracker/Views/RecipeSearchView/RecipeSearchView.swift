//
//  RecipeSearchView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 30.04.2025.
//

import SwiftUI

struct RecipeSearchView: View {
    
    // MARK: - Environment
    
    @Environment(\.dismiss)
    private var dismiss
    
    @Environment(NutritionViewModel.self)
    private var viewModel
    
    // MARK: - Body
    
    var body: some View {
        recipeSearchHeader
            .padding(.top)
        ScrollView {
            ForEach(viewModel.allRecipes) { recipe in
                RecipeRowView(recipe: recipe)
                    .padding(.horizontal)
            }
        }
    }
}

// MARK: - Subviews

private extension RecipeSearchView {

    private var recipeSearchHeader: some View {
        ZStack {
            Text("Food Database")
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
