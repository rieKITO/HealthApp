//
//  RecommendationsView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 25.05.2025.
//

import SwiftUI

struct RecommendationsView: View {
    
    // MARK: - Environment
    
    @Environment(\.dismiss)
    private var dismiss
    
    @Environment(NutritionViewModel.self)
    private var viewModel
    
    // MARK: - State
    
    @State
    private var selection: String = "Similar"
    
    // MARK: - Private properties
    
    private let filterOptions = ["Similar", "Goal", "Balance"]
    
    // MARK: - Init
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.mutedGreen
        let attributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor.accentGreen
        ]
        UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .selected)
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            RecommendationsViewHeader
                .padding(.top)
            Picker(selection: $selection) {
                ForEach(filterOptions.indices, id: \.self) { index in
                    Text(filterOptions[index])
                        .tag(filterOptions[index])
                }
            } label: { }
                .pickerStyle(.segmented)
                .padding(.top)
            switch selection {
            case "Similar":
                recommendationRecipes(recommendationRecipes: viewModel.similarRecipes)
            case "Goal":
                recommendationRecipes(recommendationRecipes: viewModel.goalBasedRecommendations)
            case "Balance":
                recommendationRecipes(recommendationRecipes: viewModel.nutritionBalanceRecommendations)
            default:
                Text("No recommendations found.")
                    .foregroundStyle(.secondary)
                    .padding()
            }
        }
        .padding(.horizontal)
        .onAppear {
            viewModel.refreshAllRecommendations()
        }
    }
}

// MARK: - Subviews

private extension RecommendationsView {
    
    private var RecommendationsViewHeader: some View {
        ZStack {
            Text("Recommendations")
                .font(.headline)
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, alignment: .center)
            HStack {
                Image(systemName: "chevron.left")
                    .font(.headline)
                    .onTapGesture {
                        dismiss.callAsFunction()
                    }
                    .padding(.leading)
                Spacer()
            }
            .padding(10)
        }
        .foregroundStyle(Color.theme.accentGreen)
    }
    
    private func recommendationRecipes(recommendationRecipes: [Recipe]) -> some View {
        ScrollView {
            LazyVStack {
                if !recommendationRecipes.isEmpty {
                    ForEach(recommendationRecipes) { recipe in
                        RecipeRowView(recipe: recipe, showAddButton: false)
                            .padding(.horizontal)
                            .padding(.bottom, 8)
                    }
                } else {
                    Text("No recommendations found.")
                        .foregroundStyle(.secondary)
                        .padding()
                }
            }
            .padding(.top, 1)
        }
    }
    
}

// MARK: - Preview

#Preview("Light Mode") {
    RecommendationsView()
        .environment(DeveloperPreview.instance.nutritionViewModel)
}

#Preview("Dark Mode") {
    RecommendationsView()
        .environment(DeveloperPreview.instance.nutritionViewModel)
        .preferredColorScheme(.dark)
}
