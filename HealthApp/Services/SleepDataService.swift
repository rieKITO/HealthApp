//
//  SleepDataService.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 07.04.2025.
//

import Foundation
import Combine

class SleepDataService {
    
    // MARK: - Published
    
    @Published
    var allSleepRecords: [SleepData] = []
    
    // MARK: - Private Properties

    private let fileManager = LocalFileManager.instance
    
    private let folderName = "SleepData"
    
    private let fileName = "SleepData.json"
    
    // MARK: - Init

    init() {
        loadSleepRecords()
    }
    
    // MARK: - Public Methods
    
    func saveSleepRecords(_ records: [SleepData]) {
        fileManager.saveData(records: records, folderName: folderName, fileName: fileName)
        allSleepRecords = records
    }

    func clearSleepData() {
        fileManager.clearData(folderName: folderName, fileName: fileName)
        allSleepRecords = []
    }

    func addSleepRecord(_ record: SleepData) {
        var records = allSleepRecords
        records.append(record)
        saveSleepRecords(records)
    }
    
    // MARK: - Private Methods

    private func loadSleepRecords() {
        allSleepRecords = fileManager.loadData(folderName: folderName, fileName: fileName)
    }
    
}
