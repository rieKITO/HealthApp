//
//  NutritionViewModel.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 23.04.2025.
//

import Foundation
import Combine

@Observable
class NutritionViewModel {
    
    // MARK: - Published
    
    var allRecipes: [Recipe] = []
    
    var isLoading: Bool = false
    
    // MARK: - Private
    
    @ObservationIgnored
    private let recipeDataService = RecipeDataService()
    
    @ObservationIgnored
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init() {
        addSubscribers()
    }

    // MARK: - Subscribers
    
    private func addSubscribers() {
        recipeDataService.$allRecipes
            .sink { [weak self] returnedRecipes in
                self?.allRecipes = returnedRecipes
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    
    func loadMoreRecipesIfNeeded(currentItem: Recipe?) {
        recipeDataService.loadMoreRecipesIfNeeded(currentItem: currentItem)
    }
}
