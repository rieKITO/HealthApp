//
//  NutritionTrackerView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 27.03.2025.
//

import SwiftUI

struct NutritionTrackerView: View {
    
    // MARK: - View Model
    
    @State
    private var viewModel = NutritionViewModel()
    
    // MARK: - Body

    var body: some View {
        VStack {
            NavigationStack {
                HStack {
                    NavigationLink {
                        MealPlannerView()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        mealPlannerLabel
                    }
                    NavigationLink {
                        
                    } label: {
                        waterPlannerLabel
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.top)
        .environment(viewModel)
    }
}

// MARK: - Subviews

private extension NutritionTrackerView {
    
    private var mealPlannerLabel: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color.theme.accent.opacity(0.5), lineWidth: 2)
            .fill(Color.theme.background)
            .frame(maxWidth: .infinity)
            .frame(height: 180)
            .overlay {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "fork.knife")
                            .font(.title2)
                            .frame(width: 30, height: 30)
                        Text("Meal Planner")
                            .font(.headline)
                        Spacer()
                    }
                    .foregroundStyle(Color.theme.accentGreen)
                    Text("Plan your daily meals")
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color.theme.secondaryText)
                    Spacer()
                }
                .padding(10)
            }
    }
    
    private var waterPlannerLabel: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color.theme.accent.opacity(0.5), lineWidth: 2)
            .fill(Color.theme.background)
            .frame(maxWidth: .infinity)
            .frame(height: 180)
            .overlay {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "mug.fill")
                            .font(.title2)
                            .frame(width: 30, height: 30)
                        Text("Water Planner")
                            .font(.headline)
                        Spacer()
                    }
                    .foregroundStyle(Color.theme.accentGreen)
                    Text("Track your hidration")
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color.theme.secondaryText)
                    Spacer()
                }
                .padding(10)
            }
    }
    
}

// MARK: - Preview

#Preview("Light Mode") {
    NutritionTrackerView()
}
