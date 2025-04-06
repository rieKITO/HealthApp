//
//  CustomTabBarView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 24.03.2025.
//

import SwiftUI

enum HomeTab: CaseIterable {
    case sleep
    case nutrition
    case stats

    var title: String {
        switch self {
        case .sleep: return "Sleep"
        case .nutrition: return "Nutrition"
        case .stats: return "Stats"
        }
    }

    var icon: String {
        switch self {
        case .sleep: return "moon.zzz.fill"
        case .nutrition: return "fork.knife"
        case .stats: return "chart.bar.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .sleep: return Color.theme.accentBlue
        case .nutrition: return Color.theme.accentGreen
        case .stats: return Color.theme.accent
        }
    }
}

struct CustomTabBarView: View {
    
    @Binding var selectedTab: HomeTab
    
    @Namespace private var animation

    // MARK: - Body
    
    var body: some View {
        ZStack {
            BlurView(style: .systemUltraThinMaterial)
                .frame(height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            tabItems
            .padding(.top, 10)
            .padding(.horizontal)
        }
        .frame(height: 90)
        .padding(.horizontal)
    }
    
}

// MARK: - Subviews

private extension CustomTabBarView {
    
    private var tabItems: some View {
        HStack {
            ForEach(HomeTab.allCases, id: \.self) { tab in
                VStack {
                    if selectedTab == tab {
                        Capsule()
                            .fill(selectedTab.color)
                            .frame(width: 30, height: 4)
                            .matchedGeometryEffect(id: "indicator", in: animation)
                    } else {
                        Spacer().frame(height: 4)
                    }
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            selectedTab = tab
                        }
                    }) {
                        VStack {
                            Image(systemName: tab.icon)
                                .font(.title2)
                                .foregroundColor(selectedTab == tab ? selectedTab.color : .gray)
                            
                            Text(tab.title)
                                .font(.caption)
                                .foregroundColor(selectedTab == tab ? selectedTab.color : .gray)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
    
}

struct BlurView: UIViewRepresentable {
    
    let style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
    
}

// MARK: - Preview

#Preview {
    
    struct Preview: View {
        
        @State private var selectedTab: HomeTab = .sleep

        var body: some View {
            ZStack {
                VStack {
                    Spacer()
                    CustomTabBarView(selectedTab: $selectedTab)
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
        
    }
    
    return Preview()
    
}
