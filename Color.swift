//
//  Color.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 25..
//

import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let accentcolor = Color("AccentColor")
    let accentcolorsecondary = Color("AccentColor2")
    let backgroundcolor = Color("BackgroundColor")
    let backgroundsecondary = Color("BackgroundColorSecondary")
    let green = Color("PriceUpGreen")
    let red = Color("PriceDownRed")
    let redgraph = Color("PriceDownRedGraph")
    let greengraph = Color("PriceUpGreenGraph")
    
}
