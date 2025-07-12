//
//  NotificationManager.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 28.03.2025.
//

import Foundation
import UserNotifications
import AVFoundation

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    static let instance = NotificationManager()
    
    private var audioPlayer: AVAudioPlayer?
    
    // MARK: - Init
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    // MARK: - Public Methods
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            if granted {
                self.setupNotificationCategories()
                print("✅ Notifications allowed")
            } else {
                print("⛔️ Notifications not allowed")
            }
        }
    }
    
    func scheduleNotification(for alarm: Alarm) {
        cancelNotification(for: alarm)
        
        guard alarm.isEnabled else {
            print("⚠️ Alarm clock off, no notification scheduled")
            return
        }
        
        let calendar = Calendar.current
        let alarmComponents = calendar.dateComponents([.hour, .minute], from: alarm.time)
        
        for weekday in alarm.repeatDays {
            var dateComponents = alarmComponents
            dateComponents.weekday = weekdayIndex(weekday)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(
                identifier: "ALARM_\(alarm.id.uuidString)_\(weekday.rawValue)",
                content: createNotificationContent(for: alarm),
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("❌ Error creating a notification: \(error)")
                } else {
                    print("✅ The alarm is scheduled for \(weekday.rawValue)")
                }
            }
        }
    }
    
    func cancelNotification(for alarm: Alarm) {
        let identifiers = alarm.repeatDays.map { "ALARM_\(alarm.id.uuidString)_\($0.rawValue)" }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        print("🚫 Notifications removed for alarm clock \(alarm.id)")
    }
    
    // MARK: - Private Methods
    
    private func setupNotificationCategories() {
        let snoozeAction = UNNotificationAction(
            identifier: "SNOOZE_ACTION",
            title: "Snooze (9 min)",
            options: [.foreground]
        )

        let stopAction = UNNotificationAction(
            identifier: "STOP_ACTION",
            title: "Stop",
            options: [.foreground]
        )

        let category = UNNotificationCategory(
            identifier: "ALARM_CATEGORY",
            actions: [snoozeAction, stopAction],
            intentIdentifiers: [],
            options: []
        )

        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    private func weekdayIndex(_ weekday: Weekday) -> Int {
        switch weekday {
        case .sunday: return 1
        case .monday: return 2
        case .tuesday: return 3
        case .wednesday: return 4
        case .thursday: return 5
        case .friday: return 6
        case .saturday: return 7
        }
    }

    private func createNotificationContent(for alarm: Alarm) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "⏰ Wake up!"
        content.body = alarm.description
        content.sound = UNNotificationSound(named: UNNotificationSoundName("alarm_sound.mp3"))
        content.categoryIdentifier = "ALARM_CATEGORY"
        return content
    }
    
}
