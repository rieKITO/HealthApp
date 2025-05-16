//
//  MealIntakeGroupView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 16.05.2025.
//

import SwiftUI

struct MealIntakeGroupView: View {
    
    // MARK: - Public Properties
    
    var mealIntakes: [MealIntake]
    
    // MARK: - Private Properties
    
    private var date: Date {
        mealIntakes[0].date
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(DateFormatterHelper.formatMediumDate(date))
                .font(.headline)
            ForEach(mealIntakes) { intake in
                MealIntakeSimpleRowView(mealIntake: intake)
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Preview

#Preview("Light Mode") {
    
    struct Preview: View {
        
        private var mealIntakes: [MealIntake] = [
            DeveloperPreview.instance.mealIntake,
            DeveloperPreview.instance.mealIntake
        ]
        
        var body: some View {
            MealIntakeGroupView(mealIntakes: mealIntakes)
                .environment(DeveloperPreview.instance.nutritionViewModel)
        }
    }
    
    return Preview()
    
}

#Preview("Dark Mode") {
    
    struct Preview: View {
        
        private var mealIntakes: [MealIntake] = [
            DeveloperPreview.instance.mealIntake,
            DeveloperPreview.instance.mealIntake
        ]
        
        var body: some View {
            MealIntakeGroupView(mealIntakes: mealIntakes)
                .environment(DeveloperPreview.instance.nutritionViewModel)
                .preferredColorScheme(.dark)
        }
    }
    
    return Preview()
    
}
