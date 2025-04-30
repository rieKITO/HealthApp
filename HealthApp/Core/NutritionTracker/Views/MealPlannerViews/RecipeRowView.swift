//
//  RecipeRowView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 30.04.2025.
//

import SwiftUI

struct RecipeRowView: View {
    
    // MARK: - Properties
    
    var recipe: Recipe
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            recipeHeader
            recipeInfo
                .padding(.horizontal, 25)
            Button {
                
            } label: {
                addButtonLabel
            }

        }
        .padding()
        .background(
            RoundedRectangle.init(cornerRadius: 10)
                .stroke(Color.theme.accent.opacity(0.3), lineWidth: 2)
                .fill(Color.theme.background)
        )
    }
}

// MARK: - Subviews

private extension RecipeRowView {
    
    private var recipeHeader: some View {
        HStack {
            Text(recipe.title)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.6)
            Spacer()
            VStack {
                Text(recipe.caloriesText)
                Text("per serving")
                    .foregroundStyle(Color.theme.secondaryText)
                    .font(.caption)
            }
        }
        .font(.headline)
    }
    
    private var recipeInfo: some View {
        HStack {
            VStack {
                Text("Protein")
                    .foregroundStyle(Color.theme.secondaryText)
                    .font(.subheadline)
                Text(recipe.protein.asNumberString() + "g")
                    .font(.headline)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .foregroundStyle(Color.theme.secondaryText.opacity(0.1))
                    .frame(width: 110, height: 55)
            )
            Spacer()
            VStack {
                Text("Carbs")
                    .foregroundStyle(Color.theme.secondaryText)
                    .font(.subheadline)
                Text(recipe.carbs.asNumberString() + "g")
                    .font(.headline)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .foregroundStyle(Color.theme.secondaryText.opacity(0.1))
                    .frame(width: 110, height: 55)
            )
            Spacer()
            VStack {
                Text("Fats")
                    .foregroundStyle(Color.theme.secondaryText)
                    .font(.subheadline)
                Text(recipe.fat.asNumberString() + "g")
                    .font(.headline)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .foregroundStyle(Color.theme.secondaryText.opacity(0.1))
                    .frame(width: 110, height: 55)
            )
        }
    }
    
    private var addButtonLabel: some View {
        Text("Add to Today")
            .foregroundStyle(Color.theme.accentGreen)
            .bold()
            .frame(maxWidth: .infinity)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color.theme.mutedGreen.opacity(1))
            )
            .padding(.horizontal, 10)
    }
    
}

// MARK: - Preview

#Preview("Light Mode") {
    RecipeRowView(recipe: DeveloperPreview.instance.recipe)
}

#Preview("Dark Mode") {
    RecipeRowView(recipe: DeveloperPreview.instance.recipe)
        .preferredColorScheme(.dark)
}
