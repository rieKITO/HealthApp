//
//  SleepData.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 31.03.2025.
//

import Foundation

struct SleepData: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var startTime: Date
    var endTime: Date?
    
    var duration: TimeInterval? {
        guard let endTime, endTime >= startTime else { return nil }
        return endTime.timeIntervalSince(startTime)
    }

}
