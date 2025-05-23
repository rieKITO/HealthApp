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
    
    var isLoading: Bool = false
    
    // MARK: - Services
    
    @ObservationIgnored
    private let recipeDataService = RecipeDataService()
    
    @ObservationIgnored
    private let mealIntakeService = MealIntakeService()
    
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
                    self?.allRecipes.append(contentsOf: recipes)
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
    
}

struct DailyCalories {
    let date: Date
    let calories: Double
}
