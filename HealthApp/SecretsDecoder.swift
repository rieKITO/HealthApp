//
//  SecretsDecoder.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 29.04.2025.
//

import Foundation

enum Secrets {
    
    static var spoonacularAPIKey: String {
        guard let key = Bundle.main.infoDictionary?["SPOONACULAR_API_KEY"] as? String else {
            fatalError("Spoonacular API Key not found in Secrets.xcconfig")
        }
        return key
    }
    
}
