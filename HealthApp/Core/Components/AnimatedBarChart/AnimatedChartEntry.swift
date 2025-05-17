//
//  AnimatedChartEntry.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 17.05.2025.
//

import Foundation
import SwiftUI

struct AnimatedChartEntry: Identifiable {
    let id = UUID()
    let date: Date
    let targetValue: Double
    var animatedValue: Double
    let color: Color
}
