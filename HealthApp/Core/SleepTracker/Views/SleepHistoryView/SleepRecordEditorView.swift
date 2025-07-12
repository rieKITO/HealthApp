//
//  SleepRecordEditorView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 06.04.2025.
//

import SwiftUI

struct SleepRecordEditorView: View {
    
    // MARK: - View Model
    
    @Bindable
    var viewModel: SleepTrackerViewModel
    
    // MARK: - Environment
    
    @Environment(\.dismiss)
    private var dismiss
    
    // MARK: - Binding
    
    @Binding
    var record: SleepData?
    
    // MARK: - State
    
    @State
    private var startSleepTime: Date = Date()
    
    @State
    private var endSleepTime: Date = Date()
    
    // MARK: - Private Properties
    
    let startingDatePickerDate: Date = Calendar.autoupdatingCurrent.date(byAdding: .day, value: -7, to: Date()) ?? Date()
    
    // MARK: - Init
    
    init(viewModel: SleepTrackerViewModel, record: Binding<SleepData?>) {
        self.viewModel = viewModel
        self._record = record
        
        let values = self.viewModel.getSleepRecordValues(from: self._record.wrappedValue)
        
        _startSleepTime = State(initialValue: values.startTime)
        _endSleepTime = State(initialValue: values.endTime ?? Date())
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Start sleep time", selection: $startSleepTime, in: startingDatePickerDate...Date(), displayedComponents: [.date, .hourAndMinute])
                DatePicker("End sleep time", selection: $endSleepTime, in: startingDatePickerDate...Date(), displayedComponents: [.date, .hourAndMinute])
            }
            .navigationBarItems(trailing: Button("Save") {
                record = viewModel.createOrUpdateSleepRecord(
                    existingSleepRecord: record,
                    startTime: startSleepTime,
                    endTime: endSleepTime
                )
                dismiss()
            })
        }
    }
}

// MARK: - Preview

#Preview("Light Mode") {
    
    struct Preview: View {
        
        @State
        private var record: SleepData? = DeveloperPreview.instance.sleepRecord
        
        var body: some View {
            SleepRecordEditorView(viewModel: DeveloperPreview.instance.sleepTrackerViewModel, record: $record)
        }
        
    }
    
    return Preview()
    
}

#Preview("Dark Mode") {
    
    struct Preview: View {
        
        @State
        private var record: SleepData? = DeveloperPreview.instance.sleepRecord
        
        var body: some View {
            SleepRecordEditorView(viewModel: DeveloperPreview.instance.sleepTrackerViewModel, record: $record)
                .preferredColorScheme(.dark)
        }
        
    }
    
    return Preview()
    
}
