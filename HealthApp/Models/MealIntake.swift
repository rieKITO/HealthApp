//
//  MealIntake.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 27.04.2025.
//

import Foundation

struct MealIntake: Identifiable, Equatable {
    let id: UUID
    let type: String
    let date: Date
    let recipeIds: [Int]
}


