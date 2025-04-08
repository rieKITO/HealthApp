//
//  AlarmViewModel.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 28.03.2025.
//

import Foundation
import SwiftUI

@Observable
class AlarmViewModel {
    
    var alarms: [Alarm] = []
    
    init() {
        loadAlarms()
    }
    
    func loadAlarms() {
        if let savedData = UserDefaults.standard.data(forKey: "alarms") {
            let decoder = JSONDecoder()
            if let decodedAlarms = try? decoder.decode([Alarm].self, from: savedData) {
                self.alarms = decodedAlarms
            }
        }
    }
    
    func saveAlarms() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(alarms) {
            UserDefaults.standard.set(encodedData, forKey: "alarms")
        }
    }
    
    func addAlarm(alarm: Alarm) {
        alarms.append(alarm)
        saveAlarms()
    }
    
    private func updateAlarm(updatedAlarm: Alarm) {
        if let index = alarms.firstIndex(where: { $0.id == updatedAlarm.id }) {
            alarms[index] = updatedAlarm
            saveAlarms()
        }
    }
    
    func createOrUpdateAlarm(existingAlarm: Alarm?, time: Date, description: String, repeatDays: Set<Weekday>) -> Alarm {
        var alarmToReturn: Alarm

        if var alarm = existingAlarm {
            alarm.time = time
            alarm.description = description
            alarm.repeatDays = Array(repeatDays)
            alarm.isEnabled = true
            updateAlarm(updatedAlarm: alarm)
            alarmToReturn = alarm
        } else {
            let newAlarm = Alarm(time: time, isEnabled: true, description: description, repeatDays: Array(repeatDays))
            addAlarm(alarm: newAlarm)
            alarmToReturn = newAlarm
        }

        return alarmToReturn
    }

    func getAlarmValues(from alarm: Alarm?) -> (time: Date, description: String, repeatDays: Set<Weekday>) {
        guard let alarm = alarm else {
            return (Date(), "", [])
        }
        return (alarm.time, alarm.description, Set(alarm.repeatDays))
    }

    func deleteAlarm(alarm: Alarm) {
        alarms.removeAll { $0.id == alarm.id }
        saveAlarms()
    }
    
}

