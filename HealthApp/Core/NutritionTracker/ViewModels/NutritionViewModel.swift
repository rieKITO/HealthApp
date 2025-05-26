//
//  NutritionViewModel.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 23.04.2025.
//

import Foundation
import Combine
import SwiftUI

@Observable
class NutritionViewModel {
    
    // MARK: - Published Properties
    
    var allRecipes: [Recipe] = []
    
    var searchedRecipes: [Recipe] = []
    
    var allMealIntakes: [MealIntake] = []
    
    var todayMealIntakes: [MealIntake] = []
    
    var similarRecipes: [Recipe] = []
    
    var goalBasedRecommendations: [Recipe] = []
    
    var nutritionBalanceRecommendations: [Recipe] = []
    
    var isLoading: Bool = false
    
    // MARK: - Services
    
    @ObservationIgnored
    private let recipeDataService = RecipeDataService()
    
    @ObservationIgnored
    private let mealIntakeService = MealIntakeService()
    
    @ObservationIgnored
    private var lastRecommendationUpdate: Date?
    
    @ObservationIgnored
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - User Data
    
    @ObservationIgnored
    @AppStorage("weight")
    private var currentUserWeight: Double?
    
    @ObservationIgnored
    @AppStorage("height")
    private var currentUserHeight: Double?
    
    @ObservationIgnored
    @AppStorage("age")
    private var currentUserAge: Int?
    
    @ObservationIgnored
    @AppStorage("gender")
    private var userGender: String?
    
    @ObservationIgnored
    @AppStorage("goal")
    private var userGoal: String?
    
    @ObservationIgnored
    @AppStorage("activityLevel")
    private var userActivityLevel: String?
    
    // MARK: - Computed Properties
    
    var todayCalories: Double {
        todayMealIntakes.reduce(0) { total, intake in
            total + getMealIntakeRecipes(for: intake).reduce(0) { $0 + $1.calories }
        }
    }
    
    var targetCalories: Double {
        calculateDailyCalories()
    }
    
    var caloriesRatio: Double {
        todayCalories / targetCalories
    }
    
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
                guard let self = self else { return }
                self.allMealIntakes = intakes

                let today = Calendar.current.startOfDay(for: Date())
                let todayIntakes = intakes.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }
                self.todayMealIntakes = todayIntakes

                if shouldUpdateRecommendations() {
                    refreshAllRecommendations()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Private Methods
    
    private func calculateDailyCalories() -> Double {
        guard
            let weight = currentUserWeight,
            let height = currentUserHeight,
            let age = currentUserAge,
            let gender = userGender,
            let activityLevel = userActivityLevel,
            let goal = userGoal
        else { return 2000 }
        
        // 1. Calculate BMR
        let bmr = gender.lowercased() == "male" ?
            10 * weight + 6.25 * height - 5 * Double(age) + 5 :
            10 * weight + 6.25 * height - 5 * Double(age) - 161
        
        // 2. Apply activity multiplier
        let multiplier: Double = {
            switch activityLevel.lowercased() {
            case "sedentary": return 1.2
            case "light": return 1.375
            case "moderate": return 1.55
            case "active": return 1.725
            case "veryactive": return 1.9
            default: return 1.55
            }
        }()
        
        let tdee = bmr * multiplier
        
        // 3. Adjust for goal
        switch goal.lowercased() {
        case "lose": return tdee - 500
        case "gain": return tdee + 500
        default: return tdee
        }
        
    }
    
    private func shouldUpdateRecommendations() -> Bool {
        guard let lastUpdate = lastRecommendationUpdate else {
            lastRecommendationUpdate = Date()
            return true
        }
        let interval = Date().timeIntervalSince(lastUpdate)
        if interval > 60 {
            lastRecommendationUpdate = Date()
            return true
        }
        return false
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

                    let existingIDs = Set(self?.allRecipes.map { $0.id } ?? [])
                    let newRecipes = recipes.filter { !existingIDs.contains($0.id) }

                    self?.allRecipes.append(contentsOf: newRecipes)
                    
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
    
    func removeRecipeFromMealIntake(_ recipe: Recipe, from intake: MealIntake) {
        mealIntakeService.removeRecipeFromMealIntake(mealIntakeId: intake.id, recipeId: recipe.id)
    }
    
    func loadMoreRecipesIfNeeded(currentItem: Recipe?) {
        recipeDataService.loadMoreRecipesIfNeeded(currentItem: currentItem)
    }
    
    func getLastWeekCalories() -> [DailyCalories] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var result: [DailyCalories] = []
        
        for dayOffset in 0..<7 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { continue }
            let intakes = allMealIntakes.filter { calendar.isDate($0.date, inSameDayAs: date) }
            let totalCalories = intakes.reduce(0) { total, intake in
                let recipes = getMealIntakeRecipes(for: intake)
                return total + recipes.reduce(0) { $0 + $1.calories }
            }
            result.append(DailyCalories(date: date, calories: totalCalories))
        }
        
        return result.sorted { $0.date < $1.date }
    }
    
    func getAverageCalories() -> Double {
        let calories = getLastWeekCalories().map { $0.calories }
        return calories.reduce(0, +) / Double(calories.count)
    }
    
    func getMaxCalories() -> Double {
        return getLastWeekCalories().max(by: { $0.calories < $1.calories })?.calories ?? 0
    }
    
    func getMinCalories() -> Double {
        return getLastWeekCalories().min(by: { $0.calories < $1.calories })?.calories ?? 0
    }
    
    func getDailyProtein() -> Double {
        todayMealIntakes
            .flatMap { getMealIntakeRecipes(for: $0) }
            .reduce(0) { $0 + $1.protein }
    }
    
    func getDailyCarbs() -> Double {
        todayMealIntakes
            .flatMap { getMealIntakeRecipes(for: $0) }
            .reduce(0) { $0 + $1.carbs }
    }

    func getDailyFat() -> Double {
        todayMealIntakes
            .flatMap { getMealIntakeRecipes(for: $0) }
            .reduce(0) { $0 + $1.fat }
    }
    
    func getSimilarRecipes(for recipe: Recipe) {
        isLoading = true
        recipeDataService.getSimilarRecipes(recipeId: recipe.id) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let recipes):
                    self?.similarRecipes = recipes
                case .failure(let error):
                    print("Error getting similar recipes: \(error.localizedDescription)")
                    self?.similarRecipes = []
                }
            }
        }
    }
    
    func getGoalBasedRecommendations() {
        guard let userGoal = userGoal else { return }
        isLoading = true
        recipeDataService.getRecommendationsBasedOnGoals(userGoal: userGoal) { [weak self] (result: Result<[Recipe], Error>) in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let recipes):
                    self?.goalBasedRecommendations = recipes
                case .failure(let error):
                    print("Error getting goal-based recommendations: \(error.localizedDescription)")
                    self?.goalBasedRecommendations = []
                }
            }
        }
    }
    
    func getNutritionBalanceRecommendations() {
        let currentNutrition = (
            protein: getDailyProtein(),
            carbs: getDailyCarbs(),
            fat: getDailyFat()
        )
        
        isLoading = true
        recipeDataService.getRecipesToBalanceNutrition(currentNutrition: currentNutrition) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let recipes):
                    self?.nutritionBalanceRecommendations = recipes
                case .failure(let error):
                    print("Error getting nutrition balance recommendations: \(error.localizedDescription)")
                    self?.nutritionBalanceRecommendations = []
                }
            }
        }
    }
    
    func refreshAllRecommendations() {
        // Собираем ID всех рецептов за сегодня
        let recipeIds = Set(todayMealIntakes.flatMap { $0.recipeIds })

        // Получаем рецепты
        let todayRecipes = allRecipes.filter { recipeIds.contains($0.id) }

        // 1. Получаем рекомендации по цели
        getGoalBasedRecommendations()

        // 2. Получаем рекомендации по балансировке нутриентов
        getNutritionBalanceRecommendations()

        // 3. Получаем похожие рецепты (суммарно)
        let uniqueIds = Array(recipeIds.prefix(5)) // не перегружать API
        for id in uniqueIds {
            recipeDataService.getSimilarRecipes(recipeId: id) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let recipes):
                        self?.similarRecipes.append(contentsOf: recipes)
                        self?.similarRecipes = Array(Set(self?.similarRecipes ?? [])) // Удаляем дубликаты
                    case .failure(let error):
                        print("Error getting similar recipes: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
}

struct DailyCalories {
    let date: Date
    let calories: Double
}
