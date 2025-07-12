//
//  AlarmViewModel.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 28.03.2025.
//

import Foundation
import Combine
import SwiftUI

@Observable
final class AlarmViewModel {
    
    // MARK: - Published Properties
    
    var alarms: [Alarm] = []
    
    // MARK: - Private Properties
    
    @ObservationIgnored
    private let alarmService = AlarmService()
    
    @ObservationIgnored
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init() {
        addSubscribers()
    }
    
    // MARK: - Subscribers
    
    private func addSubscribers() {
        alarmService.$allAlarms
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newAlarms in
                self?.alarms = newAlarms
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    
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
            alarmService.addAlarm(newAlarm)
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
        alarmService.deleteAlarm(alarm: alarm)
    }
    
    // MARK: - Private Methods

    private func updateAlarm(updatedAlarm: Alarm) {
        if let index = alarms.firstIndex(where: { $0.id == updatedAlarm.id }) {
            alarms[index] = updatedAlarm
            alarmService.saveAlarms(alarms)
        }
    }
    
}
