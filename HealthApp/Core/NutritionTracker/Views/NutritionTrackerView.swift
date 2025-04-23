//
//  NutritionTrackerView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 27.03.2025.
//

import SwiftUI

struct NutritionTrackerView: View {
    
    @State
    private var viewModel = NutritionViewModel()

    var body: some View {
        ScrollView {
            LazyVStack {
                Text("Recipes:")
                ForEach(viewModel.allRecipes) { recipe in
                    VStack(alignment: .leading) {
                        Text(recipe.title)
                        Text("Калории: \(recipe.caloriesText)")
                    }
                    .onAppear {
                        viewModel.loadMoreRecipesIfNeeded(currentItem: recipe)
                    }
                }
            }
        }
    }
}

#Preview("Light Mode") {
    NutritionTrackerView()
}
