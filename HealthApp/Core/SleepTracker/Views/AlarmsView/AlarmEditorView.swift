//
//  AlarmEditorView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 28.03.2025.
//

import SwiftUI

struct AlarmEditorView: View {
    
    // MARK: - Environment
    
    @Environment(\.dismiss)
    private var dismiss
    
    // MARK: - View Model
    
    @Bindable
    var viewModel: AlarmViewModel
    
    // MARK: - Binding
    
    @Binding
    var alarm: Alarm?
    
    // MARK: - State
    
    @State
    private var time: Date = Date()
    
    @State 
    private var description: String = ""
    
    @State
    private var repeatDays: Set<Weekday> = []
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            Form {
                DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                TextField("Description", text: $description)
                Section(header: Text("Repeat on")) {
                    ForEach(Weekday.allCases, id: \.self) { weekday in
                        Toggle(weekday.rawValue.capitalized, isOn: Binding(
                            get: { repeatDays.contains(weekday) },
                            set: { isOn in
                                if isOn {
                                    repeatDays.insert(weekday)
                                } else {
                                    repeatDays.remove(weekday)
                                }
                            }
                        ))
                    }
                }
            }
            .navigationBarItems(trailing: Button("Save") {
                alarm = viewModel.createOrUpdateAlarm(
                    existingAlarm: alarm,
                    time: time,
                    description: description,
                    repeatDays: repeatDays
                )
                
                NotificationManager.instance.scheduleNotification(for: alarm!)
                dismiss()
            })
            .onAppear {
                let values = viewModel.getAlarmValues(from: alarm)
                time = values.time
                description = values.description
                repeatDays = values.repeatDays
            }
        }
    }

}

// MARK: - Preview

#Preview("Light Mode") {
    
    struct Preview: View {
        
        @State
        private var alarm: Alarm? = DeveloperPreview.instance.alarm
        
        var body: some View {
            AlarmEditorView(viewModel: DeveloperPreview.instance.alarmViewModel, alarm: $alarm)
        }
        
    }
    
    return Preview()
    
}

#Preview("Dark Mode") {
    
    struct Preview: View {
        
        @State
        private var alarm: Alarm? = DeveloperPreview.instance.alarm
        
        var body: some View {
            AlarmEditorView(viewModel: DeveloperPreview.instance.alarmViewModel, alarm: $alarm)
                .preferredColorScheme(.dark)
        }
        
    }
    
    return Preview()
    
}
