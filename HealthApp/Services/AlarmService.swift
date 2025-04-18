//
//  AlarmService.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 18.04.2025.
//

import Foundation
import Combine

class AlarmService {

    private let fileManager = LocalFileManager.instance

    private let folderName = "AlarmData"
    
    private let fileName = "AlarmData.json"

    @Published
    var allAlarms: [Alarm] = []

    init() {
        loadAlarms()
    }

    func loadAlarms() {
        allAlarms = fileManager.loadData(folderName: folderName, fileName: fileName)
    }

    func saveAlarms(_ alarms: [Alarm]) {
        fileManager.saveData(records: alarms, folderName: folderName, fileName: fileName)
        allAlarms = alarms
    }

    func clearAlarms() {
        fileManager.clearData(folderName: folderName, fileName: fileName)
        allAlarms = []
    }

    func addAlarm(_ alarm: Alarm) {
        var updated = allAlarms
        updated.append(alarm)
        saveAlarms(updated)
    }
    
    func deleteAlarm(alarm: Alarm) {
        allAlarms.removeAll { $0.id == alarm.id }
        saveAlarms(allAlarms)
    }
    
}
