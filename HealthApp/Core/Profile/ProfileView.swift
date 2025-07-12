//
//  ProfileView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 26.03.2025.
//

import SwiftUI

struct ProfileView: View {
    
    // MARK: - Environment
    
    @Environment(\.dismiss)
    private var dismiss
    
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
    
    @AppStorage("signed_in")
    private var currentUserSignedIn: Bool = false
    
    @AppStorage("dark_mode")
    private var darkMode: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 20) {
            profileViewHeader
                .padding(.top)
            userInformation
            accountSection
            appearanceSection
            Spacer()
        }
        .ignoresSafeArea(edges: .bottom)
        .padding(.horizontal)
    }
}

// MARK: - Subviews

private extension ProfileView {
    
    private var profileViewHeader: some View {
        ZStack {
            Text("Your Profile")
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
        .foregroundStyle(Color.theme.accent)
    }
    
    private var userInformation: some View {
        VStack {
            HStack(alignment: .top, spacing: 30) {
                Image(systemName: "person.circle")
                    .resizable()
                    .font(.headline)
                    .frame(width: 75, height: 75)
                VStack(alignment: .leading) {
                    Text(currentUserName ?? "No Name")
                    Text("\(currentUserAge ?? 0) y.o.")
                }
                .foregroundStyle(Color.theme.accent)
                .font(.headline)
                .padding(.top, 10)
                Spacer()
            }
            .padding()
        }
    }
    
    private var accountSection: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("Account")
                .padding(.bottom)
                .foregroundStyle(Color.theme.secondaryText)
            RoundedRectangle(cornerRadius: 7)
                .fill(Color.theme.background)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .shadow(color: Color.theme.accent.opacity(0.2), radius: 2)
                .overlay {
                    HStack {
                        Image(systemName: "hand.thumbsup")
                        Text("Your progress")
                            .padding(.leading, 10)
                        Spacer()
                        Image(systemName: "arrow.right")
                    }
                    .padding(.horizontal)
                }
            RoundedRectangle(cornerRadius: 7)
                .fill(Color.theme.background)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .shadow(color: Color.theme.accent.opacity(0.2), radius: 2)
                .overlay {
                    HStack {
                        Image(systemName: "bell")
                        Text("Notifications")
                            .padding(.leading, 10)
                        Spacer()
                        Image(systemName: "arrow.right")
                    }
                    .padding(.horizontal)
                }
            
        }
        .padding(.horizontal, 20)
    }
    
    private var appearanceSection: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("Appearance")
                .padding(.bottom)
                .foregroundStyle(Color.theme.secondaryText)
            RoundedRectangle(cornerRadius: 7)
                .fill(Color.theme.background)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .shadow(color: Color.theme.accent.opacity(0.2), radius: 2)
                .overlay {
                    HStack {
                        Image(systemName: "moon")
                        Text("Dark mode")
                            .padding(.leading, 10)
                        Spacer()
                        Toggle(isOn: $darkMode) { }
                            .tint(Color.theme.accentBlue)
                    }
                    .padding(.horizontal)
                }
            
        }
        .padding(.horizontal, 20)
    }
    
}

// MARK: - Private Methods

private extension ProfileView {
    
    func signOut() {
        currentUserName = nil
        currentUserAge = nil
        currentUserGender = nil
        withAnimation(.spring()) {
            currentUserSignedIn = false
        }
    }
    
}

// MARK: - Preview

#Preview("Light Mode") {
    ProfileView()
}

#Preview("Dark Mode") {
    ProfileView()
        .preferredColorScheme(.dark)
}

