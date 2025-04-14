//
//  SleepTrackerViewModel.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 31.03.2025.
//

import Foundation
import Combine

@Observable
class SleepTrackerViewModel {
    
    private let sleepDataService = SleepDataService()
    
    private var cancellables = Set<AnyCancellable>()
    
    private var sleepStartTime: Date?
    
    var isSleeping = false

    var sleepRecords: [SleepData] = []

    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        sleepDataService.$allSleepRecords
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newRecords in
                self?.sleepRecords = newRecords
            }
            .store(in: &cancellables)
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
        sleepDataService.addSleepRecord(record)
    }
    
    func getSleepRecordValues(from sleepRecord: SleepData?) -> (startTime: Date, endTime: Date?) {
        guard let sleepRecord = sleepRecord else {
            return (Date(), Date())
        }
        return (sleepRecord.startTime, sleepRecord.endTime)
    }
    
    private func updateSleepRecord(updatedRecord: SleepData) {
        if let index = sleepRecords.firstIndex(where: { $0.id == updatedRecord.id }) {
            sleepRecords[index] = updatedRecord
            sleepDataService.saveSleepRecords(sleepRecords)
        }
    }
    
    func createOrUpdateSleepRecord(existingSleepRecord: SleepData?, startTime: Date, endTime: Date) -> SleepData {
        var sleepRecordToReturn: SleepData

        if var sleepRecord = existingSleepRecord {
            sleepRecord.startTime = startTime
            sleepRecord.endTime = endTime
            updateSleepRecord(updatedRecord: sleepRecord)
            sleepRecordToReturn = sleepRecord
        } else {
            let newSleepRecord = SleepData(startTime: startTime, endTime: endTime)
            sleepDataService.addSleepRecord(newSleepRecord)
            sleepRecordToReturn = newSleepRecord
        }

        return sleepRecordToReturn
    }
    
    func getDailySleepTimeInterval() -> TimeInterval {
        getTotalSleep(for: 1)
    }
    
    func getWeeklySleepTimeInterval() -> TimeInterval {
        getTotalSleep(for: 7)
    }
    
    func getMonthlySleepTimeInterval() -> TimeInterval {
        getTotalSleep(for: 30)
    }
    
    private func getTotalSleep(for days: Int) -> TimeInterval {
        let startDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        return sleepRecords
            .filter { $0.startTime >= startDate }
            .compactMap { $0.duration }
            .reduce(0, +)
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
