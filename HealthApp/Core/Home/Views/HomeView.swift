//
//  HomeView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 23.03.2025.
//

import SwiftUI

struct HomeView: View {
    
    // MARK: - State
    
    @State
    private var nutritionViewModel = NutritionViewModel()
    
    @State
    private var selectedTabItem: HomeTab = .sleep
    
    // MARK: - Properties
    
    private var homeTitleOption: HomeTitleOptions {
        switch selectedTabItem {
        case .sleep: .sleep
        case .nutrition: .nutrition
        case .stats: .stats
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // background
            Color.theme.background
                .ignoresSafeArea()
            
            // foreground
            VStack {
                homeViewHeader
                switch selectedTabItem {
                case .sleep:
                    SleepTrackerView()
                case .nutrition:
                    NutritionTrackerView()
                        .environment(nutritionViewModel)
                case .stats:
                    StatisticsView()
                        .environment(nutritionViewModel)
                }
                Spacer()
                CustomTabBarView(selectedTab: $selectedTabItem)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

// MARK: - Subviews

private extension HomeView {
    
    enum HomeTitleOptions: String {
        case sleep = "Sleep Tracker"
        case nutrition = "Nutrition Tracker"
        case stats = "Statistics"
        case settings = "Settings"
    }
    
    private var homeViewHeader: some View {
        ZStack {
            Text(homeTitleOption.rawValue)
                .font(.headline)
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, alignment: .center)
            HStack {
                Spacer()
                NavigationLink {
                    ProfileView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    CircleButtonView(
                        iconName: "person.fill",
                        shadowColor: selectedTabItem == .sleep ? .theme.accentBlue :
                        selectedTabItem == .nutrition ? .theme.accentGreen : .theme.accent
                    )
                }
            }
            .padding(10)
        }
        .padding(.horizontal)
        .foregroundStyle(
            homeTitleOption ==
                .sleep ? Color.theme.accentBlue :
                homeTitleOption ==
                .nutrition ? Color.theme.accentGreen :
                Color.theme.accent
        )
    }

    
}

// MARK: - Preview

#Preview("Light Mode") {
    NavigationStack {
        HomeView()
            .environment(DeveloperPreview.instance.nutritionViewModel)
            .toolbar(.hidden)
    }
}

#Preview("Dark Mode") {
    NavigationStack {
        HomeView()
            .environment(DeveloperPreview.instance.nutritionViewModel)
            .toolbar(.hidden)
            .preferredColorScheme(.dark)
    }
}
