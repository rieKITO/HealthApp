//
//  SleepHistoryViewModel.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 02.04.2025.
//

import Foundation

@Observable
class SleepHistoryViewModel {
    
    private let sleepFileManager = SleepFileManager.instance
    
    var sleepRecords: [SleepData] = []
    
    init() {
        loadRecords()
    }
    
    func loadRecords() {
        sleepRecords = sleepFileManager.loadSleepRecords()
    }
    
    func getAverageSleep() -> Double {
        let totalDuration = sleepRecords.compactMap { $0.duration }.reduce(0, +)
        return sleepRecords.isEmpty ? 0 : totalDuration / Double(sleepRecords.count)
    }
    
    func getBestSleep() -> Double {
        return sleepRecords.compactMap { $0.duration }.map { $0 / 3600 }.max() ?? 0
    }
    
    func getWorstSleep() -> Double {
        return sleepRecords.compactMap { $0.duration }.map { $0 / 3600 }.min() ?? 0
    }
    
    func last7DaysSleep() -> [(date: Date, hours: Double)] {
        let calendar = Calendar.current
        let last7Days = (0..<7).compactMap { calendar.date(byAdding: .day, value: -$0, to: Date()) }
        return last7Days.map { date in
            let totalHours = sleepRecords
                .filter { calendar.isDate($0.startTime, inSameDayAs: date) }
                .compactMap { $0.duration }
                .reduce(0, +) / 3600
            return (date, totalHours)
        }
    }
}
