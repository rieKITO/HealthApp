//
//  SleepTrackerView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 27.03.2025.
//

import SwiftUI

struct SleepTrackerView: View {
    
    // MARK: - State
    
    @State
    private var viewModel = SleepTrackerViewModel()
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            sleepTimingLabel
                .padding()
            HStack(spacing: 20) {
                NavigationLink {
                    SleepHistoryView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    sleepHistoryViewLabel
                }
                NavigationLink {
                    AlarmsView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    alarmsViewLabel
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Subviews

private extension SleepTrackerView {
    
    private var sleepTimingLabel: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color.theme.accent.opacity(0.5), lineWidth: 2)
            .fill(Color.theme.background)
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .overlay {
                VStack(spacing: 10) {
                    Text("Sleep Timing")
                        .font(.title)
                        .bold()
                        .foregroundStyle(Color.theme.accentBlue)
                    Text("Keep track of your sleep time")
                        .foregroundStyle(Color.theme.secondaryText)
                    Button(action: {
                        if viewModel.isSleeping {
                            viewModel.stopSleep()
                        } else {
                            viewModel.startSleep()
                        }
                    }) {
                        Text(viewModel.isSleeping ? "Wake up" : "Start Sleep")
                            .bold()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(viewModel.isSleeping ? Color.red : Color.theme.accentBlue)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding()
                            .foregroundColor(Color.theme.background)
                    }
                }
                .padding(10)
            }
    }
    
//    private var sleepStatisticsLabel: some View {
//        RoundedRectangle(cornerRadius: 10)
//            .stroke(Color.theme.accent.opacity(0.5), lineWidth: 2)
//            .fill(Color.theme.background)
//            .frame(maxWidth: .infinity)
//            .frame(height: 180)
//            .overlay(alignment: .leading) {
//                VStack(alignment: .leading) {
//                    HStack {
//                        Image(systemName: "chart.bar")
//                            .font(.title2)
//                            .frame(width: 30, height: 30)
//                        Text("Sleep Stats")
//                            .font(.headline)
//                        Spacer()
//                    }
//                    .foregroundStyle(Color.theme.accentBlue)
//                    Text("Check your sleep statistics")
//                        .multilineTextAlignment(.leading)
//                        .foregroundStyle(Color.theme.secondaryText)
//                    Spacer()
//                    Text("\(DateFormatterHelper.formatDuration(viewModel.getDailySleep()))")
//                        .font(.headline)
//                    Text("Today")
//                        .foregroundStyle(Color.theme.secondaryText)
//                }
//                .padding(10)
//            }
//    }
    
    private var alarmsViewLabel: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color.theme.accent.opacity(0.5), lineWidth: 2)
            .fill(Color.theme.background)
            .frame(maxWidth: .infinity)
            .frame(height: 180)
            .overlay {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "alarm")
                            .font(.title2)
                            .frame(width: 30, height: 30)
                        Text("Sleep Alarms")
                            .font(.headline)
                        Spacer()
                    }
                    .foregroundStyle(Color.theme.accentBlue)
                    Text("Set and manage alarms")
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color.theme.secondaryText)
                    Spacer()
                    Text("7:00 AM")
                        .font(.headline)
                    Text("Next alarm")
                        .foregroundStyle(Color.theme.secondaryText)
                }
                .padding(10)
            }
    }
    
    private var sleepHistoryViewLabel: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color.theme.accent.opacity(0.5), lineWidth: 2)
            .fill(Color.theme.background)
            .frame(maxWidth: .infinity)
            .frame(height: 180)
            .overlay {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "calendar")
                            .font(.title2)
                            .frame(width: 30, height: 30)
                        Text("Sleep History")
                            .font(.headline)
                        Spacer()
                    }
                    .foregroundStyle(Color.theme.accentBlue)
                    Text("View your sleep patterns")
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color.theme.secondaryText)
                    Spacer()
                    Text("\(DateFormatterHelper.formatDuration(viewModel.getWeeklySleep()))")
                        .font(.headline)
                    Text("This week")
                        .foregroundStyle(Color.theme.secondaryText)
                }
                .padding(10)
            }
    }
    
}

// MARK: - Preview

#Preview("Light Mode") {
    NavigationStack {
        SleepTrackerView()
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        SleepTrackerView()
            .preferredColorScheme(.dark)
    }
}
