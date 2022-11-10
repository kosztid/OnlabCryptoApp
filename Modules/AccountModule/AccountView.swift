import SwiftUI

struct AccountView: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject var presenter: AccountPresenter
    var body: some View {
        ZStack {
            Color.theme.backgroundcolor
            VStack {
                emailField
                privateToggle
                Spacer()

                logoutButton
                    .accessibilityIdentifier("AccountSignOutButton")
            }
            .padding(10)
        }
        .onAppear {
            presenter.load()
        }
        .background(Color.theme.backgroundcolor)
    }

    var emailField: some View {
        VStack(alignment: .center) {
            Text(Strings.email)
            Text(presenter.currentUserEmail())
        }
        .font(.system(size: 18))
        .foregroundColor(Color.theme.accentcolor)
    }

    var logoutButton: some View {
        Button {
            presenter.signOut()
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Text(Strings.logout)
                .font(.system(size: 20))
                .frame(height: 30)
        }
        .buttonStyle(UnifiedBorderedButtonStyle())
    }

    var privateToggle: some View {
        HStack {
            Text(Strings.accountVisibility)
                .foregroundColor(Color.theme.accentcolor)
            Spacer()
            Button {
                presenter.changeVisibility()
            } label: {
                Text(presenter.accountVisibility ? Strings.public : Strings.private)
            }
            .frame(height: 30)
            .frame(maxWidth: UIScreen.main.bounds.width * 0.3)
            .font(.system(size: 20))
            .buttonStyle(UnifiedBorderedButtonStyle())
        }
    }
}
