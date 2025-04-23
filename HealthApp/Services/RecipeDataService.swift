//
//  NutritionService.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 23.04.2025.
//

import Foundation
import Combine

class RecipeDataService {
    
    // MARK: - Published
    
    @Published var allRecipes: [Recipe] = []
    
    // MARK: - Private Properties
    
    private var recipeSubscription: AnyCancellable?
    
    private var cancellables = Set<AnyCancellable>()
    
    private var isLoading = false
    
    private var currentOffset = 0
    
    private let pageSize = 100
    
    private let totalLimit = 500
    
    // MARK: - Init

    init() {
        loadMoreRecipesIfNeeded()
    }
    
    // MARK: - Public Methods

    func loadMoreRecipesIfNeeded(currentItem: Recipe? = nil) {
        guard !isLoading else { return }

        if let currentItem = currentItem {
            guard let index = allRecipes.firstIndex(where: { $0.id == currentItem.id }),
                  index >= allRecipes.count - 5 else {
                return
            }
        }

        guard currentOffset < totalLimit else { return }

        isLoading = true
        fetchRecipes(offset: currentOffset)
    }
    
    // MARK: - Private Methods

    private func fetchRecipes(offset: Int) {
        let apiKey = Bundle.main.infoDictionary?["SpoonacularAPIKey"] as? String ?? ""

        let urlString =
        "https://api.spoonacular.com/recipes/complexSearch?offset=\(offset)&number=\(pageSize)&addRecipeNutrition=true&apiKey=\(apiKey)"

        guard let url = URL(string: urlString) else {
            isLoading = false
            return
        }

        recipeSubscription = NetworkingManager.download(url: url)
            .tryMap { data -> Data in
                print("[RAW JSON]", String(data: data, encoding: .utf8) ?? "Invalid data")
                return data
            }
            .decode(type: ComplexSearchResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("Ошибка декодирования: \(error.localizedDescription)")
                case .finished:
                    break
                }
                self?.isLoading = false
            }, receiveValue: { [weak self] response in
                self?.allRecipes.append(contentsOf: response.results)
                self?.currentOffset += self?.pageSize ?? 100
                self?.isLoading = false
            })

    }
}

// MARK: - Response Wrapper

struct ComplexSearchResponse: Codable {
    let results: [Recipe]
    let totalResults: Int?
}


