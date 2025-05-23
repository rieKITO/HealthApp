//
//  Double.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 30.04.2025.
//

import Foundation

extension Double {
    
    /// Converts a Double into string representation
    /// ```
    /// Convert 1.2345 to "1.2"
    /// ```
    func asNumberString() -> String {
        return String(format: "%.1f", self)
    }
    
    /// Converts a Double into int string representation
    /// ```
    /// Convert 1.2345 to "1"
    /// ```
    func asNumberToIntString() -> String {
        return String(format: "%.0f", self)
    }
    
}
