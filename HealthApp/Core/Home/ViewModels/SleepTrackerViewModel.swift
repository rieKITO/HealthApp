//
//  SleepTrackerViewModel.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 31.03.2025.
//

import Foundation

@Observable
class SleepTrackerViewModel {
    
    private let sleepFileManager = SleepFileManager.instance
    var isSleeping = false
    private var sleepStartTime: Date?
    
    var sleepRecords: [SleepData] {
        sleepFileManager.loadSleepRecords()
    }
    
    func startSleep() {
        guard !isSleeping else { return }
        isSleeping = true
        sleepStartTime = Date()
    }
    
    func stopSleep() {
        guard isSleeping, let startTime = sleepStartTime else { return }
        isSleeping = false
        let record = SleepData(startTime: startTime, endTime: Date())
        var records = sleepRecords
        records.append(record)
        sleepFileManager.saveSleepRecords(records)
    }
    
    func getDailySleep() -> TimeInterval {
        getTotalSleep(for: 1)
    }
    
    func getWeeklySleep() -> TimeInterval {
        getTotalSleep(for: 7)
    }
    
    func getMonthlySleep() -> TimeInterval {
        getTotalSleep(for: 30)
    }
    
    private func getTotalSleep(for days: Int) -> TimeInterval {
        let startDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        return sleepRecords
            .filter { $0.startTime >= startDate }
            .compactMap { $0.duration }
            .reduce(0, +)
    }
}
