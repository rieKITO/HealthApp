//
//  SleepRecordRowView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 03.04.2025.
//

import SwiftUI

struct SleepRecordRowView: View {
    
    var record: SleepData
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            Image(systemName: "moon.stars")
                .foregroundStyle(Color.theme.accentBlue)
                .frame(width: 40, height: 40)
                .background(Circle().fill(Color.theme.mutedBlue))
            VStack(alignment: .leading) {
                Text(DateFormatterHelper.formatDate(record.endTime ?? Date()))
                    .font(.headline)
                Text("\(DateFormatterHelper.formatTime(record.startTime)) - \(DateFormatterHelper.formatTime(record.endTime ?? record.startTime.addingTimeInterval(8 * 3600)))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "clock")
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
            Text("\(DateFormatterHelper.formatDuration(record.duration ?? 0))")
            Spacer()
            Image(systemName: "waveform.path.ecg")
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
            Text("\(Int.random(in: 70...95))%") // Симуляция качества сна
                .foregroundColor(Color.theme.accentBlue)
        }
        .padding()
        .background(
            Color.theme.secondaryText.opacity(0.1)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        )
    }
}

// MARK: - Preview

#Preview("Light Mode") {
    
    struct Preview: View {
        
        @State
        private var sleepRecord = DeveloperPreview.instance.sleepRecord
        
        var body: some View {
            SleepRecordRowView(record: sleepRecord)
        }
    }
    
    return Preview()
    
}

#Preview("Dark Mode") {
    
    struct Preview: View {
        
        @State
        private var sleepRecord = DeveloperPreview.instance.sleepRecord
        
        var body: some View {
            SleepRecordRowView(record: sleepRecord)
                .preferredColorScheme(.dark)
        }
    }
    
    return Preview()
    
}
