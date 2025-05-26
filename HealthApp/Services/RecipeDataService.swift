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
    
    private let pageSize = 5
    
    private let totalLimit = 5
    
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
    
    func searchRecipes(query: String, completion: @escaping (Result<[Recipe], Error>) -> Void) {
            let apiKey = Secrets.spoonacularAPIKey
        
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
            let urlString = """
            https://api.spoonacular.com/recipes/complexSearch?query=\(encodedQuery)&number=10&addRecipeNutrition=true&apiKey=\(apiKey)
            """
        
            guard let url = URL(string: urlString) else {
                completion(.success([]))
                return
            }

            NetworkingManager.download(url: url)
                .decode(type: ComplexSearchResponse.self, decoder: JSONDecoder())
                .map { response -> [Recipe] in
                    response.results.map { apiModel in
                        var calories = 0.0, protein = 0.0, fat = 0.0, carbs = 0.0
                        apiModel.nutrition?.nutrients.forEach {
                            switch $0.name.lowercased() {
                            case "calories": calories = $0.amount
                            case "protein": protein = $0.amount
                            case "fat": fat = $0.amount
                            case "carbohydrates": carbs = $0.amount
                            default: break
                            }
                        }
                        return Recipe(
                            id: apiModel.id,
                            title: apiModel.title,
                            calories: calories,
                            protein: protein,
                            fat: fat,
                            carbs: carbs
                        )
                    }
                }
                .sink(receiveCompletion: { completionResult in
                    if case .failure(let error) = completionResult {
                        completion(.failure(error))
                    }
                }, receiveValue: { recipes in
                    completion(.success(recipes))
                })
                .store(in: &cancellables)
        }
    
    // MARK: - Private Methods

    private func fetchRecipes(offset: Int) {
        let apiKey = Secrets.spoonacularAPIKey
        
        let urlString = """
        https://api.spoonacular.com/recipes/complexSearch?offset=\(offset)&number=\(pageSize)&addRecipeNutrition=true&apiKey=\(apiKey)
        """
        
        guard let url = URL(string: urlString) else {
            isLoading = false
            return
        }

        recipeSubscription = NetworkingManager.download(url: url)
            .tryMap { data -> Data in
                return data
            }
            .decode(type: ComplexSearchResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("loading error: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] response in
                let simplifiedRecipes = response.results.map { recipe -> Recipe in
                    var calories: Double = 0
                    var protein: Double = 0
                    var fat: Double = 0
                    var carbs: Double = 0
                    
                    if let nutrition = recipe.nutrition {
                        for nutrient in nutrition.nutrients {
                            switch nutrient.name.lowercased() {
                            case "calories":
                                calories = nutrient.amount
                            case "protein":
                                protein = nutrient.amount
                            case "fat":
                                fat = nutrient.amount
                            case "carbohydrates":
                                carbs = nutrient.amount
                            default:
                                continue
                            }
                        }
                    }
                    
                    return Recipe(
                        id: recipe.id,
                        title: recipe.title,
                        calories: calories,
                        protein: protein,
                        fat: fat,
                        carbs: carbs
                    )
                }
                self?.allRecipes.append(contentsOf: simplifiedRecipes.filter { recipe in
                    !(self?.allRecipes.contains(where: { $0.id == recipe.id }) ?? false)
                })
                self?.currentOffset += self?.pageSize ?? 0
            })
    }
    
    private func fetchRecipesDetails(ids: [Int]) -> AnyPublisher<[Recipe], Error> {
        let apiKey = Secrets.spoonacularAPIKey
        let publishers = ids.map { id -> AnyPublisher<Recipe, Error> in
            let urlString = "https://api.spoonacular.com/recipes/\(id)/information?includeNutrition=true&apiKey=\(apiKey)"
            guard let url = URL(string: urlString) else {
                return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
            }

            return NetworkingManager.download(url: url)
                .decode(type: RecipeDetailsAPIResponse.self, decoder: JSONDecoder())
                .map { apiModel in
                    var calories = 0.0, protein = 0.0, fat = 0.0, carbs = 0.0
                    apiModel.nutrition?.nutrients.forEach {
                        switch $0.name.lowercased() {
                        case "calories": calories = $0.amount
                        case "protein": protein = $0.amount
                        case "fat": fat = $0.amount
                        case "carbohydrates": carbs = $0.amount
                        default: break
                        }
                    }
                    return Recipe(
                        id: apiModel.id,
                        title: apiModel.title,
                        calories: calories,
                        protein: protein,
                        fat: fat,
                        carbs: carbs
                    )
                }
                .eraseToAnyPublisher()
        }

        return Publishers.MergeMany(publishers)
            .collect()
            .eraseToAnyPublisher()
    }

}

// MARK: - Recomendations

extension RecipeDataService {
    
    private func mapToRecipe(from apiModel: RecipeAPIModel) -> Recipe {
        var calories = 0.0, protein = 0.0, fat = 0.0, carbs = 0.0
        apiModel.nutrition?.nutrients.forEach {
            switch $0.name.lowercased() {
                case "calories": calories = $0.amount
                case "protein": protein = $0.amount
                case "fat": fat = $0.amount
                case "carbohydrates": carbs = $0.amount
                default: break
            }
        }
        return Recipe(id: apiModel.id, title: apiModel.title, calories: calories, protein: protein, fat: fat, carbs: carbs)
    }

    func getSimilarRecipes(recipeId: Int, completion: @escaping (Result<[Recipe], Error>) -> Void) {
        let apiKey = Secrets.spoonacularAPIKey
        let urlString = "https://api.spoonacular.com/recipes/\(recipeId)/similar?number=5&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(.success([]))
            return
        }
        
        NetworkingManager.download(url: url)
            .decode(type: [SimilarRecipeAPIResponse].self, decoder: JSONDecoder())
            .map { $0.map { $0.id } }
            .flatMap { self.fetchRecipesDetails(ids: $0) }
            .sink(receiveCompletion: { if case .failure(let error) = $0 { completion(.failure(error)) }},
                  receiveValue: { completion(.success($0)) })
            .store(in: &cancellables)
    }

    func getRecommendationsBasedOnGoals(userGoal: String, completion: @escaping (Result<[Recipe], Error>) -> Void) {
            let apiKey = Secrets.spoonacularAPIKey
            var queryParams: String

            switch userGoal.lowercased() {
            case "lose":
                queryParams = "maxCalories=400&sort=calories&sortDirection=asc"
            case "gain":
                queryParams = "minCalories=600&minProtein=30&sort=calories&sortDirection=desc"
            default:
                queryParams = "minCalories=300&maxCalories=700&sort=random"
            }

            let urlString = "https://api.spoonacular.com/recipes/complexSearch?\(queryParams)&number=5&addRecipeNutrition=true&apiKey=\(apiKey)"

            guard let url = URL(string: urlString) else {
                completion(.success([]))
                return
            }

            NetworkingManager.download(url: url)
                .decode(type: ComplexSearchResponse.self, decoder: JSONDecoder())
                .map { $0.results.map(self.mapToRecipe) }
                .sink(receiveCompletion: { completionResult in
                    if case .failure(let error) = completionResult {
                        completion(.failure(error))
                    }
                }, receiveValue: { recipes in
                    completion(.success(recipes))
                })
                .store(in: &cancellables)
        }

    func getRecipesToBalanceNutrition(currentNutrition: (protein: Double, carbs: Double, fat: Double), completion: @escaping (Result<[Recipe], Error>) -> Void) {
        let apiKey = Secrets.spoonacularAPIKey
        var filters: [String] = []
        
        if currentNutrition.protein < 100 { filters.append("minProtein=20") }
        if currentNutrition.carbs < 200   { filters.append("minCarbs=30") }
        if currentNutrition.fat < 50      { filters.append("minFat=10") }

        let queryParams = filters.joined(separator: "&") + "&number=5&addRecipeNutrition=true"
        let urlString = "https://api.spoonacular.com/recipes/complexSearch?\(queryParams)&apiKey=\(apiKey)"

        guard let url = URL(string: urlString) else {
            completion(.success([]))
            return
        }

        NetworkingManager.download(url: url)
            .decode(type: ComplexSearchResponse.self, decoder: JSONDecoder())
            .map { $0.results.map(self.mapToRecipe) }
            .sink(receiveCompletion: { if case .failure(let error) = $0 { completion(.failure(error)) }},
                  receiveValue: { completion(.success($0)) })
            .store(in: &cancellables)
    }
}


// MARK: - Response Models

struct SimilarRecipeAPIResponse: Codable {
    let id: Int
    let title: String
}

struct RecipeDetailsAPIResponse: Codable {
    let id: Int
    let title: String
    let nutrition: Nutrition?
}

// MARK: - Response Wrapper

struct ComplexSearchResponse: Codable {
    let results: [RecipeAPIModel]
}

struct RecipeAPIModel: Codable {
    let id: Int
    let title: String
    let nutrition: Nutrition?
}

struct Nutrition: Codable {
    let nutrients: [Nutrient]
}

struct Nutrient: Codable {
    let name: String
    let amount: Double
    let unit: String
}
