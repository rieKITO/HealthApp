//
//  MealIntakeService.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 27.04.2025.
//

import Foundation
import CoreData
import Combine

class MealIntakeService {
    
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
        fetchMealIntakes()
    }
    
    func deleteMealIntake(_ intake: MealIntake) {
        guard let entity = fetchEntity(by: intake.id) else { return }
        container.viewContext.delete(entity)
        saveContext()
        fetchMealIntakes()
    }
    
    func addRecipeToMealIntake(mealIntakeId: UUID, recipeId: Int) {
        guard let entity = fetchEntity(by: mealIntakeId) else { return }
        
        var ids = (try? JSONDecoder().decode([Int].self, from: entity.recipeIdsData ?? Data())) ?? []
        
        guard !ids.contains(recipeId) else { return }
        ids.append(recipeId)
        entity.recipeIdsData = try? JSONEncoder().encode(ids)
        
        saveContext()
        fetchMealIntakes()
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
