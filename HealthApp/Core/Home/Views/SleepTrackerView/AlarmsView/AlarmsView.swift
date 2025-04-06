//
//  AlarmsView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 27.03.2025.
//

import SwiftUI

import SwiftUI

struct AlarmsView: View {
    
    // MARK: - Environment
    
    @Environment(\.dismiss)
    private var dismiss
    
    // MARK: - State
    
    @State
    private var viewModel = AlarmViewModel()
    
    @State
    private var isShowingAlarmEditor: Bool = false
    
    @State
    private var selectedAlarm: Alarm? = nil
    
    // MARK: - Body
    
    var body: some View {
        alarmsViewHeader
            .padding(.top)
        ScrollView {
            VStack {
                alarmsViewUnderheader
                ForEach($viewModel.alarms) { $alarm in
                    AlarmRowView(alarm: $alarm)
                        .onTapGesture {
                            selectedAlarm = alarm
                            isShowingAlarmEditor = true
                        }
                }
                Spacer()
            }
            .padding(.horizontal)
        }
        .safeAreaInset(edge: .bottom, alignment: .center) {
            addAlarmButton
        }
        .sheet(isPresented: $isShowingAlarmEditor) {
            AlarmEditorView(viewModel: viewModel, alarm: $selectedAlarm)
        }
    }
    
}

// MARK: - Subviews

private extension AlarmsView {
    
    private var alarmsViewHeader: some View {
        ZStack {
            Text("Alarms")
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
    
    private var alarmsViewUnderheader: some View {
        VStack {
            HStack {
                Image(systemName: "bell")
                    .font(.title2)
                    .frame(width: 30, height: 30)
                Text("Your Alarms")
                    .font(.headline)
                Spacer()
            }
            .foregroundStyle(Color.theme.accentBlue)
            Text("Set alarms to help maintain your sleep schedule. Regular sleep and wake times improve sleep quality.")
                .multilineTextAlignment(.leading)
                .font(.subheadline)
                .foregroundStyle(Color.theme.secondaryText)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.theme.mutedBlue)
        )
    }
    
    private var addAlarmButton: some View {
        Button {
            selectedAlarm = nil
            isShowingAlarmEditor = true
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
    AlarmsView()
}

#Preview("Dark Mode") {
    AlarmsView()
        .preferredColorScheme(.dark)
}
