//
//  AlarmRowView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 28.03.2025.
//

import SwiftUI

struct AlarmRowView: View {
    
    @Binding
    var alarm: Alarm
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(alarm.time, style: .time)
                        .font(.title)
                        .bold()
                        .foregroundStyle(Color.theme.accent)
                    Text(alarm.description)
                        .font(.subheadline)
                        .foregroundStyle(Color.theme.secondaryText)
                }
                Spacer()
                Toggle("", isOn: $alarm.isEnabled)
                    .tint(Color.theme.accentBlue)
            }
            HStack {
                ForEach(Weekday.allCases, id: \.self) { weekday in
                    Circle()
                        .fill(alarm.repeatDays.contains(weekday) ? Color.theme.accentBlue.opacity(0.7) : Color.gray.opacity(0.3))
                        .frame(width: 30, height: 30)
                        .overlay {
                            Text(String(weekday.rawValue.prefix(1)).uppercased())
                                .bold()
                                .foregroundStyle(Color.theme.accent)
                        }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.theme.accent.opacity(0.3), lineWidth: 2)
                .fill(Color.theme.background)
        )
    }

}

// MARK: - Preview

#Preview("Light Mode") {
    
    struct Preview: View {
        
        @State
        private var alarm = DeveloperPreview.instance.alarm
        
        var body: some View {
            AlarmRowView(alarm: $alarm)
        }
    }
    
    return Preview()
    
}

#Preview("Dark Mode") {
    
    struct Preview: View {
        
        @State
        private var alarm = DeveloperPreview.instance.alarm
        
        var body: some View {
            AlarmRowView(alarm: $alarm)
                .preferredColorScheme(.dark)
        }
    }
    
    return Preview()
    
}
