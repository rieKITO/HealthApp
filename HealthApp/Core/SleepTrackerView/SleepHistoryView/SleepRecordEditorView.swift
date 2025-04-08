//
//  SleepRecordEditorView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 06.04.2025.
//

import SwiftUI

struct SleepRecordEditorView: View {
    
    // MARK: - Environment
    
    @Environment(\.dismiss)
    private var dismiss
    
    // MARK: - View Model
    
    @Bindable
    var viewModel: SleepTrackerViewModel
    
    // MARK: - Binding
    
    @Binding
    var record: SleepData?
    
    // MARK: - State
    
    @State
    private var startSleepTime: Date = Date()
    
    @State
    private var endSleepTime: Date = Date()
    
    // MARK: - Body
    
    var body: some View {
        Text("")
    }
}

// MARK: - Preview

#Preview("Light Mode") {
    
    struct Preview: View {
        
        @State
        private var viewModel = SleepTrackerViewModel()
        
        @State
        private var record: SleepData? = DeveloperPreview.instance.sleepRecord
        
        var body: some View {
            SleepRecordEditorView(viewModel: viewModel, record: $record)
        }
        
    }
    
    return Preview()
    
}

#Preview("Dark Mode") {
    
    struct Preview: View {
        
        @State
        private var viewModel = SleepTrackerViewModel()
        
        @State
        private var record: SleepData? = DeveloperPreview.instance.sleepRecord
        
        var body: some View {
            SleepRecordEditorView(viewModel: viewModel, record: $record)
                .preferredColorScheme(.dark)
        }
        
    }
    
    return Preview()
    
}
