//
//  SleepHistoryView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 01.04.2025.
//

import SwiftUI

struct SleepHistoryView: View {
    
    // MARK: - View Model
    
    @Bindable
    var viewModel: SleepTrackerViewModel
    
    // MARK: - Environment
    
    @Environment(\.dismiss)
    private var dismiss
    
    // MARK: - State
    
    @State
    private var isShowingSleepRecordEditor: Bool = false
    
    @State
    private var selectedRecord: SleepData?
    
    // MARK: - Body
    
    var body: some View {
        sleepHistoryViewHeader
            .padding(.top)
        ScrollView {
            SleepWeeklyOverviewView(viewModel: viewModel)
            sleepRecordsView
        }
        .safeAreaInset(edge: .bottom, alignment: .center) {
            addSleepRecordButton
        }
        .sheet(isPresented: $isShowingSleepRecordEditor) {
            SleepRecordEditorView(viewModel: viewModel, record: $selectedRecord)
        }
    }
}

// MARK: - Subviews

private extension SleepHistoryView {
    
    private var sleepHistoryViewHeader: some View {
        ZStack {
            Text("Sleep History")
                .font(.headline)
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, alignment: .center)
            HStack {
                Image(systemName: "chevron.left")
                    .font(.headline)
                    .onTapGesture {
                        dismiss.callAsFunction()
                    }
                    .padding(.leading)
                Spacer()
            }
            .padding(10)
            
        }
        .foregroundStyle(Color.theme.accentBlue)
        .foregroundStyle(Color.theme.accent)
    }
    
    private var sleepRecordsView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Sleep Records")
                .font(.title2)
                .bold()
                .foregroundStyle(Color.theme.accentBlue)
            ForEach(viewModel.sleepRecords.sorted(by: { $0.startTime > $1.startTime })) { record in
                SleepRecordRowView(record: record)
                    .onTapGesture {
                        selectedRecord = record
                        isShowingSleepRecordEditor = true
                    }
            }
        }
        .padding()
    }
    
    private var addSleepRecordButton: some View {
        Button {
            selectedRecord = nil
            isShowingSleepRecordEditor = true
        } label: {
            Image(systemName: "plus")
                .font(.title2)
                .foregroundStyle(Color.white)
                .padding()
                .background(
                    Circle()
                        .fill(Color.theme.accentBlue)
                        .shadow(color: Color.theme.accentBlue.opacity(0.7), radius: 10)
                )
        }
    }
    
}

// MARK: - Preview

#Preview("Light Mode") {
    SleepHistoryView(viewModel: DeveloperPreview.instance.sleepTrackerViewModel)
}

#Preview("Dark Mode") {
    SleepHistoryView(viewModel: DeveloperPreview.instance.sleepTrackerViewModel)
        .preferredColorScheme(.dark)
}
