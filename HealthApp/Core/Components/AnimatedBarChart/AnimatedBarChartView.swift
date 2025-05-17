//
//  AnimatedBarChartView.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 17.05.2025.
//

import SwiftUI
import Charts

struct AnimatedBarChartView: View {
    
    // MARK: - Binding
    
    @Binding var entries: [AnimatedChartEntry]
    
    // MARK: - Public Properties
    
    let title: String
    
    let valueSuffix: String
    
    let averageValue: Double
    
    let bestValue: Double
    
    let worstValue: Double
    
    let valueFormatter: (Double) -> String
    
    let titleColor: Color
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title2)
                .bold()
                .foregroundStyle(titleColor)
            
            Chart {
                ForEach(entries) { entry in
                    BarMark(
                        x: .value("Date", entry.date, unit: .day),
                        y: .value("Value", entry.animatedValue)
                    )
                    .foregroundStyle(entry.color)
                }
            }
            .frame(height: 200)
            
            HStack {
                Text("Avg: \(valueFormatter(averageValue))")
                Spacer()
                Text("Max: \(valueFormatter(bestValue))")
                Spacer()
                Text("Min: \(valueFormatter(worstValue))")
            }
            .font(.caption)
            .padding(.top, 5)
        }
        .padding()
    }
}

//#Preview {
//    AnimatedBarChartView(entries: <#T##[AnimatedChartEntry]#>, title: <#T##String#>, valueSuffix: <#T##String#>, averageValue: <#T##Double#>, bestValue: <#T##Double#>, worstValue: <#T##Double#>, valueFormatter: <#T##(Double) -> String#>)
//}
