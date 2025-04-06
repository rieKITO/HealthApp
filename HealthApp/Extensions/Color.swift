//
//  Color.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 23.03.2025.
//

import Foundation
import SwiftUI

extension Color {
    
    static let theme: ColorTheme = ColorTheme()
    
}

struct ColorTheme {
    
    let accent: Color = Color("AccentColor")
    let background: Color = Color("BackgroundColor")
    let secondaryText: Color = Color("SecondaryTextColor")
    
    let blue: Color = Color("BlueColor")
    let accentBlue: Color = Color("AccentBlueColor")
    let mutedBlue: Color = Color("MutedBlueColor")
    
    let green: Color = Color("GreenColor")
    let accentGreen: Color = Color("AccentGreenColor")
    let mutedGreen: Color = Color("MutedGreenColor")
    
}
