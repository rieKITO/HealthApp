//
//  SleepHistoryView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 01.04.2025.
//

import SwiftUI

struct SleepHistoryView: View {
    
    // MARK: - Environment
    
    @Environment(\.dismiss)
    private var dismiss
    
    // MARK: - State
    
    @State
    private var viewModel = SleepHistoryViewModel()
    
    @State
    private var isShowingSleepRecordEditor: Bool = false
    
    @State
    private var selectedRecord: SleepData? = nil
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            sleepHistoryViewHeader
                .padding(.top)
            SleepWeeklyOverviewView(viewModel: viewModel)
            sleepRecordsView
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
                        isShowingSleepRecordEditor = true
                        selectedRecord = record
                    }
            }
            
        }
        .padding()
    }
    
}

// MARK: - Preview

#Preview("Light Mode") {
    SleepHistoryView()
}

#Preview("Dark Mode") {
    SleepHistoryView()
        .preferredColorScheme(.dark)
}
