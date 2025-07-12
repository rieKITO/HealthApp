//
//  OnboardingView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 24.03.2025.
//

import SwiftUI

struct OnboardingView: View {
    
    let transition: AnyTransition = .asymmetric(
        insertion: .move(edge: .trailing),
        removal: .move(edge: .leading)
    )
    
    // MARK: - State
    
    // Onboarding states:
    /*
     0 - Welcome screen
     1 - Add name
     2 - Add age
     3 - Add gender
     4 - Add weight
     5 - Add height
     6 - Add activity
     7 - Add goal
    */
    
    @State
    private var onBoardingState: Int = 0
    
    // onboarding inputs
    @State
    private var name: String = ""
    
    @State
    private var age: Double = 50
    
    @State
    private var gender: String = ""
    
    @State
    private var weight: Double = 0
    
    @State
    private var height: Double = 130
    
    @State
    private var goal: String = ""
    
    @State
    private var activityLevel: String = ""
    
    // for the alert
    @State
    private var alertTitle: String = ""
    
    @State
    private var showAlert: Bool = false
    
    // MARK: - App Storage Properties
    
    @AppStorage("name")
    private var currentUserName: String?
    
    @AppStorage("age")
    private var currentUserAge: Int?
    
    @AppStorage("gender")
    private var currentUserGender: String?
    
    @AppStorage("weight")
    private var currentUserWeight: Double?
    
    @AppStorage("height")
    private var currentUserHeight: Double?
    
    @AppStorage("goal")
    private var userGoal: String?
    
    @AppStorage("activityLevel")
    private var userActivityLevel: String?
    
    @AppStorage("signed_in")
    private var currentUserSignedIn: Bool = false

    // MARK: - Body
    
    var body: some View {
        ZStack {
            ZStack {
                switch onBoardingState {
                case 0:
                    welcomeSection
                        .transition(transition)
                case 1:
                    addNameSection
                        .transition(transition)
                case 2:
                    addAgeSection
                        .transition(transition)
                case 3:
                    addGenderSection
                        .transition(transition)
                case 4:
                    addWeightSection
                        .transition(transition)
                case 5:
                    addHeightSection
                        .transition(transition)
                case 6:
                    addActivityLevelSection
                        .transition(transition)
                case 7:
                    addGoalSection
                        .transition(transition)
                default:
                    Text("Add name")
                }
            }
            VStack {
                Spacer()
                bottomButton
            }
            .padding(30)
        }
        .alert(isPresented: $showAlert) {
            return Alert(title: Text(alertTitle))
        }
    }
}

// MARK: - Subviews

private extension OnboardingView {
    
    private var bottomButton: some View {
        Text(onBoardingState == 0 ? "SIGN UP" :
            onBoardingState == 7 ? "FINISH" :
            "NEXT"
        )
            .font(.headline)
            .foregroundStyle(Color.theme.accent)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [Color.theme.accentBlue, Color.theme.accentGreen],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke()
                )
            )
            .onTapGesture {
                handleNextButtonPressed()
            }
    }
    
    private var welcomeSection: some View {
        ZStack(alignment: .center) {
            VStack(spacing: 30) {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.theme.background)
                    .frame(height: 230)
                    .shadow(color: Color.theme.accentBlue.opacity(0.3), radius: 10)
                    .overlay(alignment: .center) {
                        VStack(spacing: 20) {
                            CircleButtonView(iconName: "moon", shadowColor: Color.theme.accentBlue)
                                .foregroundStyle(Color.theme.accentBlue)
                            Text("Sleep Tracking")
                                .foregroundStyle(Color.theme.accent)
                            Text("Monitor your sleep patterns and improve your rest")
                                .foregroundStyle(Color.theme.secondaryText)
                        }
                        .padding(.horizontal, 20)
                    }
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.theme.background)
                    .frame(height: 230)
                    .shadow(color: Color.theme.accentGreen.opacity(0.3), radius: 10)
                    .overlay {
                        VStack(spacing: 20) {
                            CircleButtonView(iconName: "fork.knife", shadowColor: Color.theme.accentGreen)
                                .foregroundStyle(Color.theme.accentGreen)
                            Text("Nutrition Tracking")
                                .foregroundStyle(Color.theme.accent)
                            Text("Monitor your diet and maintain healthy eating habbits")
                                .foregroundStyle(Color.theme.secondaryText)
                        }
                        .padding(.horizontal, 20)
                    }
                    .fontWeight(.medium)
            }
            VStack(spacing: 20) {
                Text("Health Tracker")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .overlay(alignment: .bottom) {
                        Capsule(style: .continuous)
                            .frame(height: 3)
                            .offset(y: 5)
                    }
                Text("Track your sleep and nutrition")
                    .font(.headline)
                    .foregroundStyle(Color.theme.secondaryText)
                Spacer()
            }
        }
        .foregroundStyle(Color.theme.accent)
        .multilineTextAlignment(.center)
        .padding(30)
    }
    
    private var addNameSection: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("What's your name?")
                .foregroundStyle(Color.theme.accent)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
            TextField("Your name here...", text: $name)
                .foregroundStyle(Color.theme.background)
                .font(.headline)
                .frame(height: 55)
                .padding(.horizontal)
                .background(
                    Color.theme.secondaryText
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                )
                .tint(Color.theme.background)
            Spacer()
            Spacer()
        }
        .padding(30)
    }
    
    private var addAgeSection: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("What's your age?")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(Color.theme.accent)
            Text("\(String(format: "%.0f", age))")
                .font(.largeTitle)
                .fontWeight(.semibold)
            Slider(value: $age, in: 18...100, step: 1)
                .tint(Color.theme.accent)
            Spacer()
            Spacer()
        }
        .foregroundStyle(Color.theme.accent)
        .padding(30)
    }
    
    private var addGenderSection: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("What's your gender?")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(Color.theme.accent)
            Menu {
                Picker(selection: $gender, label: Text("")) {
                    Text("Male").tag("Male")
                    Text("Female").tag("Female")
                }
            } label: {
                Text(gender.count > 1 ? gender : "Select a gender")
                    .font(.headline)
                    .foregroundColor(Color.theme.background)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.theme.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            Spacer()
            Spacer()
        }
        .padding(30)
    }
    
    private var addWeightSection: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("What's your weight?")
                .foregroundStyle(Color.theme.accent)
                .font(.largeTitle)
                .fontWeight(.semibold)
            TextField("Your weight here...", value: $weight, format: .number)
                .font(.title)
                .multilineTextAlignment(.center)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .background(
                    Color.theme.background
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                )
                .keyboardType(.numberPad)
            Spacer()
            Spacer()
        }
        .padding(30)
    }

    private var addHeightSection: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("What's your height?")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(Color.theme.accent)
            Text("\(String(format: "%.0f", height))")
                .font(.largeTitle)
                .fontWeight(.semibold)
            Slider(value: $height, in: 130...250, step: 1)
                .tint(Color.theme.accent)
            Spacer()
            Spacer()
        }
        .foregroundStyle(Color.theme.accent)
        .padding(30)
    }
    
    private var addActivityLevelSection: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("What's activity level")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(Color.theme.accent)
            Menu {
                Picker(selection: $activityLevel, label: Text("")) {
                    Text("Sedentary").tag("Sedentary")
                    Text("Light").tag("Light")
                    Text("Moderate").tag("Moderate")
                    Text("Active").tag("Active")
                    Text("Very Active").tag("VeryActive")
                }
            } label: {
                Text(activityLevel.count > 1 ? activityLevel : "Select an activity level")
                    .font(.headline)
                    .foregroundColor(Color.theme.background)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.theme.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            Spacer()
            Spacer()
        }
        .padding(30)
    }
    
    private var addGoalSection: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("What's your goal?")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(Color.theme.accent)
            Menu {
                Picker(selection: $goal, label: Text("")) {
                    Text("Lose").tag("Lose")
                    Text("Maintain").tag("Maintain")
                    Text("Gain").tag("Gain")
                }
            } label: {
                Text(goal.count > 1 ? goal : "Select a goal")
                    .font(.headline)
                    .foregroundColor(Color.theme.background)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.theme.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            Spacer()
            Spacer()
        }
        .padding(30)
    }
    
}

// MARK: - Private Methods

private extension OnboardingView {
    
    func handleNextButtonPressed() {
        // Check inputs
        switch onBoardingState {
        case 1:
            guard name.count >= 3 else {
                showAlert(title: "Your name must be at least 3 characters long")
                return
            }
        case 3:
            guard gender.count > 1 else {
                showAlert(title: "Please select a gender before moving forward!")
                return
            }
        case 4:
            guard weight > 30 && weight < 200 else {
                showAlert(title: "Please enter a valid weight between 30kg and 200kg")
                return
            }
        case 6:
            guard activityLevel.count > 1 else {
                showAlert(title: "Please select an activity level before moving forward!")
                return
            }
        case 7:
            guard goal.count > 1 else {
                showAlert(title: "Please select a goal before moving forward!")
                return
            }
        default:
            break
        }
        
        // Go to next section
        if onBoardingState == 7 {
            signIn()
        } else {
            withAnimation(.spring()) {
                onBoardingState += 1
            }
        }
    }
    
    func signIn() {
        currentUserName = name
        currentUserAge = Int(age)
        currentUserGender = gender
        currentUserWeight = weight
        currentUserHeight = height
        userGoal = goal
        userActivityLevel = activityLevel
        withAnimation(.spring()) {
            currentUserSignedIn = true
        }
    }
    
    func showAlert(title: String) {
        alertTitle = title
        showAlert.toggle()
    }
    
}

// MARK: - Preview

#Preview("Light mode") {
    OnboardingView()
        .background(Color.theme.background)
}

#Preview("Dark Mode") {
    OnboardingView()
        .background(Color.theme.background)
        .preferredColorScheme(.dark)
}
