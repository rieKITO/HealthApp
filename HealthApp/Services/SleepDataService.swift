//
//  SleepDataService.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 07.04.2025.
//

import Foundation
import Combine

class SleepDataService {

    private let fileManager = LocalFileManager.instance
    
    private let folderName = "SleepData"
    
    private let fileName = "SleepData.json"
    
    @Published
    var allSleepRecords: [SleepData] = []

    init() {
        loadSleepRecords()
    }

    private func loadSleepRecords() {
        allSleepRecords = fileManager.loadSleepRecords(folderName: folderName, fileName: fileName)
    }

    func saveSleepRecords(_ records: [SleepData]) {
        fileManager.saveSleepRecords(records: records, folderName: folderName, fileName: fileName)
        allSleepRecords = records
    }

    func clearSleepData() {
        fileManager.clearSleepData(folderName: folderName, fileName: fileName)
        allSleepRecords = []
    }

    func addSleepRecord(_ record: SleepData) {
        var records = allSleepRecords
        records.append(record)
        saveSleepRecords(records)
    }
}
