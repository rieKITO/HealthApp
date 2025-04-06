//
//  DeveloperPreview.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 28.03.2025.
//

import Foundation

struct DeveloperPreview {
    
    static let instance = DeveloperPreview()
    
    let alarm: Alarm = Alarm(time: Date(), isEnabled: true, description: "Weekday wake up", repeatDays: [.monday, .friday, .sunday])
    
    let sleepRecord: SleepData = SleepData(startTime: Date(), endTime: Date())
    
}
