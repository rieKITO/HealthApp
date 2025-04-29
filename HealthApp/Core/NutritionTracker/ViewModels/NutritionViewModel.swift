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
    
    var todayMealIntakes: [MealIntake] = []
    
    var isLoading: Bool = false
    
    // MARK: - Private
    
    @ObservationIgnored
    private let recipeDataService = RecipeDataService()
    
    @ObservationIgnored
    private let mealIntakeService = MealIntakeService()
    
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
        mealIntakeService.$mealIntakes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] intakes in
                let today = Calendar.current.startOfDay(for: Date())
                self?.todayMealIntakes = intakes.filter {
                    Calendar.current.isDate($0.date, inSameDayAs: today)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    
    func getMealIntakeRecipes(for mealIntake: MealIntake) -> [Recipe] {
        allRecipes.filter { mealIntake.recipeIds.contains($0.id) }
    }
    
    func addRecipeToMealIntake(_ recipe: Recipe, to intake: MealIntake) {
        mealIntakeService.addRecipeToMealIntake(mealIntakeId: intake.id, recipeId: recipe.id)
    }
    
    func loadMoreRecipesIfNeeded(currentItem: Recipe?) {
        recipeDataService.loadMoreRecipesIfNeeded(currentItem: currentItem)
    }
}
