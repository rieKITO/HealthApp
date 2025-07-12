//
//  SleepTrackerViewModel.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 31.03.2025.
//

import Foundation
import Combine

@Observable
final class SleepTrackerViewModel {
    
    // MARK: - Published Properties
    
    var isSleeping = false

    var sleepRecords: [SleepData] = []
    
    // MARK: - Services
    
    @ObservationIgnored
    private let sleepDataService = SleepDataService()
    
    @ObservationIgnored
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Private Properties
    
    @ObservationIgnored
    private var sleepStartTime: Date?

    // MARK: - Init
    
    init() {
        addSubscribers()
    }
    
    // MARK: - Subscribers
    
    private func addSubscribers() {
        sleepDataService.$allSleepRecords
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newRecords in
                self?.sleepRecords = newRecords
            }
            .store(in: &cancellables)
    }

}

// MARK: - Sleep Tracker Counter Methods

extension SleepTrackerViewModel {
    
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
    
}

// MARK: - Sleep Record Methods

extension SleepTrackerViewModel {
    
    // Public Methods
    
    func getSleepRecordValues(from sleepRecord: SleepData?) -> (startTime: Date, endTime: Date?) {
        guard let sleepRecord = sleepRecord else {
            return (Date(), Date())
        }
        return (sleepRecord.startTime, sleepRecord.endTime)
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
    
    // Private Methods
    
    private func updateSleepRecord(updatedRecord: SleepData) {
        if let index = sleepRecords.firstIndex(where: { $0.id == updatedRecord.id }) {
            sleepRecords[index] = updatedRecord
            sleepDataService.saveSleepRecords(sleepRecords)
        }
    }
    
}

// MARK: - Get Sleep Values Methods

extension SleepTrackerViewModel {
    
    // Public Methods
    
    func getDailySleepTimeInterval() -> TimeInterval {
        getTotalSleep(for: 1)
    }
    
    func getWeeklySleepTimeInterval() -> TimeInterval {
        getTotalSleep(for: 7)
    }
    
    func getMonthlySleepTimeInterval() -> TimeInterval {
        getTotalSleep(for: 30)
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
    
    func lastWeekSleep() -> [(date: Date, hours: Double)] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let last7Days = (0..<7).compactMap { calendar.date(byAdding: .day, value: -$0, to: today) }

        return last7Days.map { date in
            let totalHours = sleepRecords
                .filter {
                    if let end = $0.endTime {
                        return calendar.isDate(end, inSameDayAs: date)
                    }
                    return false
                }
                .compactMap { $0.duration }
                .reduce(0, +) / 3600
            return (date, totalHours)
        }
    }
    
    // Private Methods
    
    private func getTotalSleep(for days: Int) -> TimeInterval {
        let calendar = Calendar.current
        let now = Date()
        let startDate = calendar.date(byAdding: .day, value: -days + 1, to: calendar.startOfDay(for: now)) ?? now

        return sleepRecords
            .filter { record in
                if let end = record.endTime {
                    return end >= startDate && end <= now
                }
                return false
            }
            .compactMap { $0.duration }
            .reduce(0, +)
    }
    
}
