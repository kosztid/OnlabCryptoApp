import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let accentcolor = Color("AccentColor")
    let accentcolorsecondary = Color("AccentColor2")
    let backgroundcolor = Color("bg")
    let backgroundsecondary = Color("bgsecondary")
    let green = Color("PriceUpGreen")
    let red = Color("PriceDownRed")
    let redgraph = Color("PriceDownRedGraph")
    let greengraph = Color("PriceUpGreenGraph")
    let messagesent = Color("MessageBubbleSent")
    let messagereceived = Color("MessageBubbleReceived")
    let textbox = Color("TextboxColor")
}
