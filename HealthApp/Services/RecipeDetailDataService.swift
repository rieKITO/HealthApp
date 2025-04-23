//
//  RecipeDetailDataService.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 23.04.2025.
//

import Foundation
import Combine

class RecipeDetailDataService {
    
    @Published var recipe: Recipe? = nil
    
    var recipeDetailSubscription: AnyCancellable?
    
    func getRecipeDetail(by id: Int) {
        guard let apiKey = Bundle.main.infoDictionary?["SpoonacularAPIKey"] as? String else { return }
        
        let urlString = "https://api.spoonacular.com/recipes/\(id)/information?includeNutrition=true&apiKey=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        
        recipeDetailSubscription = NetworkingManager.download(url: url)
            .decode(type: Recipe.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion,
                  receiveValue: { [weak self] recipe in
                self?.recipe = recipe
                self?.recipeDetailSubscription?.cancel()
            })
    }
}
