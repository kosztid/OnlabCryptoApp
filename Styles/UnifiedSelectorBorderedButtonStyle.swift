import SwiftUI

struct UnifiedSelectorBorderedButtonStyle: ButtonStyle {
    var isSelected = true
    var buttonCount: Double = 1
    var height: Double = 50
    var fontSize: Double = 12

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: fontSize))
            .frame(width: UIScreen.main.bounds.width * 0.9 / buttonCount, height: height)
            .background(isSelected ? Color.theme.accentcolor : Color.theme.backgroundsecondary)
            .foregroundColor(isSelected ? Color.theme.backgroundsecondary : Color.theme.accentcolor)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 1.1 : 1.0)
    }
}
