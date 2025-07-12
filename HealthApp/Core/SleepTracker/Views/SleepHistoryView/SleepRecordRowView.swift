//
//  SleepRecordRowView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 03.04.2025.
//

import SwiftUI

struct SleepRecordRowView: View {
    
    let record: SleepData
    
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
    SleepRecordRowView(record: DeveloperPreview.instance.sleepRecord)
}

#Preview("Dark Mode") {
    SleepRecordRowView(record: DeveloperPreview.instance.sleepRecord)
        .preferredColorScheme(.dark)
}
