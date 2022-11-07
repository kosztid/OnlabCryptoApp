import SwiftUI

struct UnifiedBorderedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 5)
            .foregroundColor(Color.theme.accentcolor)
            .background(Color.theme.backgroundsecondary)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 1.1 : 1.0)
    }
}
