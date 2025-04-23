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
    let image: String
    let nutrition: Nutrition?

    struct Nutrition: Codable {
        let nutrients: [Nutrient]
    }

    struct Nutrient: Codable {
        let name: String
        let amount: Double
        let unit: String
    }

    var caloriesText: String {
        nutrition?.nutrients.first(where: { $0.name == "Calories" }).map {
            "\($0.amount.rounded()) \($0.unit)"
        } ?? "N/A"
    }
}
