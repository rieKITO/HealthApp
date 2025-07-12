//
//  DeveloperPreview.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 28.03.2025.
//

import Foundation

struct DeveloperPreview {
    
    static let instance = DeveloperPreview()
    
    let nutritionViewModel = NutritionViewModel()
    
    let alarmViewModel = AlarmViewModel()
    
    let sleepTrackerViewModel = SleepTrackerViewModel()
    
    let alarm: Alarm = Alarm(time: Date(), isEnabled: true, description: "Weekday wake up", repeatDays: [.monday, .friday, .sunday])
    
    let sleepRecord: SleepData = SleepData(startTime: Date(), endTime: Date())
    
    let mealIntake: MealIntake = MealIntake(
        id: UUID(),
        type: "Breakfast",
        date: Date(),
        recipeIds: [715415, 716406]
    )
    
    let recipe: Recipe = Recipe(
        id: 1,
        title: "Red Lentil Soup with Chiken and Turnips",
        calories: 477,
        protein: 10.8,
        fat: 5.6,
        carbs: 75.3
    )
    
}
