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
    
    var searchedRecipes: [Recipe] = []
    
    var allMealIntakes: [MealIntake] = []
    
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
                self?.allMealIntakes = intakes
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
    
    func searchRecipes(by title: String) {
        guard !title.isEmpty else {
            searchedRecipes = []
            return
        }
        isLoading = true
        recipeDataService.searchRecipes(query: title) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let recipes):
                    self?.searchedRecipes = recipes
                case .failure(let error):
                    print("Search error: \(error.localizedDescription)")
                    self?.searchedRecipes = []
                }
            }
        }
    }
    
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
