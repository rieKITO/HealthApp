//
//  NutritionTrackerView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 27.03.2025.
//

import SwiftUI

struct NutritionTrackerView: View {
    
    // MARK: - Environment
    
    @Environment(NutritionViewModel.self)
    private var viewModel

    // MARK: - Body

    var body: some View {
        VStack {
            NavigationStack {
                TodayNutritionSummaryView()
                HStack {
                    NavigationLink {
                        MealPlannerView()
                            .environment(viewModel)
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        mealPlannerLabel
                    }
                    NavigationLink {
                        RecipeSearchView()
                            .environment(viewModel)
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        recipeSearchLabel
                    }
                }
                .padding(.horizontal)
                HStack {
                    NavigationLink {
                        RecommendationsView()
                            .environment(viewModel)
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        recomendationsLabel
                    }
                    NavigationLink {
                        NutritionHistoryView()
                            .environment(viewModel)
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        nutritionHistoryLabel
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.top)
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
    
    private var recipeSearchLabel: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color.theme.accent.opacity(0.5), lineWidth: 2)
            .fill(Color.theme.background)
            .frame(maxWidth: .infinity)
            .frame(height: 180)
            .overlay {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "carrot.fill")
                            .font(.title2)
                            .frame(width: 30, height: 30)
                        Text("Recipe Search")
                            .font(.headline)
                        Spacer()
                    }
                    .foregroundStyle(Color.theme.accentGreen)
                    Text("Browse food and recipes")
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color.theme.secondaryText)
                    Spacer()
                }
                .padding(10)
            }
    }
    
    private var recomendationsLabel: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color.theme.accent.opacity(0.5), lineWidth: 2)
            .fill(Color.theme.background)
            .frame(maxWidth: .infinity)
            .frame(height: 180)
            .overlay {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "list.triangle")
                            .font(.title2)
                            .frame(width: 30, height: 30)
                        Text("Personal Recs")
                            .font(.headline)
                        Spacer()
                    }
                    .foregroundStyle(Color.theme.accentGreen)
                    Text("Watch your daily recomendations")
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color.theme.secondaryText)
                    Spacer()
                }
                .padding(10)
            }
    }
    
    private var nutritionHistoryLabel: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color.theme.accent.opacity(0.5), lineWidth: 2)
            .fill(Color.theme.background)
            .frame(maxWidth: .infinity)
            .frame(height: 180)
            .overlay {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "calendar")
                            .font(.title2)
                            .frame(width: 30, height: 30)
                        Text("History")
                            .font(.headline)
                        Spacer()
                    }
                    .foregroundStyle(Color.theme.accentGreen)
                    Text("Review past meals")
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
        .environment(DeveloperPreview.instance.nutritionViewModel)
}

#Preview("Dark Mode") {
    NutritionTrackerView()
        .environment(DeveloperPreview.instance.nutritionViewModel)
        .preferredColorScheme(.dark)
}
