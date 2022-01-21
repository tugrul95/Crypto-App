//
//  Color.swift
//  Crypto
//
//  Created by Macbook on 18.01.2022.
//

import Foundation
import SwiftUI

/// A collection of custom colors from Assets folder
struct ColorTheme {
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")
}

extension Color {
    /// A custom theme that automatically adapts to dark mode
    static let theme = ColorTheme()
}
