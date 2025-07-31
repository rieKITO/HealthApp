//
//  MealIntakeService.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 27.04.2025.
//

import Foundation
import CoreData
import Combine

final class MealIntakeService {
    
    // MARK: - Published
    
    @Published
    var mealIntakes: [MealIntake] = []
    
    // MARK: - Private Properties
    
    private let container: NSPersistentContainer
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init() {
        container = NSPersistentContainer(name: "NutritionContainer")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("CoreData loading error: \(error.localizedDescription)")
            }
        }
        fetchMealIntakes()
        ensureTodayMealIntakesExist()
    }
    
    // MARK: - Public Methods
    
    func addMealIntake(type: String, date: Date, recipeIds: [Int]) {
        let intake = MealIntakeEntity(context: container.viewContext)
        intake.id = UUID()
        intake.type = type
        intake.date = date
        intake.recipeIdsData = try? JSONEncoder().encode(recipeIds)
        
        saveContext()
    }
    
    func deleteMealIntake(_ intake: MealIntake) {
        guard let entity = fetchEntity(by: intake.id) else { return }
        container.viewContext.delete(entity)
        saveContext()
    }
    
    func addRecipeToMealIntake(mealIntakeId: UUID, recipeId: Int) {
        updateRecipeIds(for: mealIntakeId) { ids in
            guard !ids.contains(recipeId) else { return ids }
            var updated = ids
            updated.append(recipeId)
            return updated
        }
    }
    
    func removeRecipeFromMealIntake(mealIntakeId: UUID, recipeId: Int) {
        updateRecipeIds(for: mealIntakeId) { ids in
            ids.filter { $0 != recipeId }
        }
    }

    func ensureTodayMealIntakesExist() {
        let today = Calendar.current.startOfDay(for: Date())
        
        let existingIntakes = mealIntakes.filter {
            Calendar.current.isDate($0.date, inSameDayAs: today)
        }
        
        let expectedTypes = ["Breakfast", "Lunch", "Snack", "Dinner"]
        let existingTypes = Set(existingIntakes.map { $0.type })
        
        for type in expectedTypes where !existingTypes.contains(type) {
            addMealIntake(type: type, date: today, recipeIds: [])
        }
    }
    
    // MARK: - Private Methods
    
    private func fetchMealIntakes() {
        let request = NSFetchRequest<MealIntakeEntity>(entityName: "MealIntakeEntity")
        
        do {
            let entities = try container.viewContext.fetch(request)
            self.mealIntakes = entities.map { entity in
                MealIntake(
                    id: entity.id ?? UUID(),
                    type: entity.type ?? "",
                    date: entity.date ?? Date(),
                    recipeIds: (try? JSONDecoder().decode([Int].self, from: entity.recipeIdsData ?? Data())) ?? []
                )
            }
        } catch {
            print("meal intake loading error: \(error.localizedDescription)")
        }
    }
    
    private func updateRecipeIds(for mealIntakeId: UUID, update: ([Int]) -> [Int]) {
        guard let entity = fetchEntity(by: mealIntakeId) else { return }

        let currentIds = (try? JSONDecoder().decode([Int].self, from: entity.recipeIdsData ?? Data())) ?? []
        let newIds = update(currentIds)

        entity.recipeIdsData = try? JSONEncoder().encode(newIds)

        saveContext()
        fetchMealIntakes()
    }
    
    private func fetchEntity(by id: UUID) -> MealIntakeEntity? {
        let request = NSFetchRequest<MealIntakeEntity>(entityName: "MealIntakeEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        
        return try? container.viewContext.fetch(request).first
    }
    
    private func saveContext() {
        do {
            try container.viewContext.save()
            fetchMealIntakes()
        } catch {
            print("save error: \(error.localizedDescription)")
        }
    }
}
