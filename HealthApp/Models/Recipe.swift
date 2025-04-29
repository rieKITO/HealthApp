//
//  Recipe.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 23.04.2025.
//

import Foundation

struct Recipe: Identifiable, Codable {
    let id: Int
    let title: String
    let calories: Double
    let protein: Double
    let fat: Double
    let carbs: Double
    
    var caloriesText: String {
        String(format: "%.0f cal", calories)
    }
    
    var macrosText: String {
        "P: \(String(format: "%.0f", protein)) g F: \(String(format: "%.0f", fat)) g С: \(String(format: "%.0f", carbs)) g"
    }
}
