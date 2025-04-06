//
//  SleepFileManager.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 02.04.2025.
//

import Foundation

class SleepFileManager {
    
    static let instance = SleepFileManager()
    
    private init() {}
    
    private let fileName = "SleepData.json"
    
    private var fileURL: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName)
    }
    
    func saveSleepRecords(_ records: [SleepData]) {
        guard let fileURL = fileURL else { return }
        do {
            let data = try JSONEncoder().encode(records)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Error saving sleep records: \(error)")
        }
    }
    
    func loadSleepRecords() -> [SleepData] {
        guard let fileURL = fileURL, FileManager.default.fileExists(atPath: fileURL.path) else {
            return []
        }
        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode([SleepData].self, from: data)
        } catch {
            print("Error loading sleep records: \(error)")
            return []
        }
    }
    
    func clearSleepData() {
        guard let fileURL = fileURL else { return }
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print("Error clearing sleep data: \(error)")
        }
    }
}

