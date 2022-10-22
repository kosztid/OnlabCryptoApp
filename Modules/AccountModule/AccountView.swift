import SwiftUI

struct AccountView: View {
    @Environment(\.presentationMode) private var presentationMode
    var presenter: AccountPresenter
    @State var accountPrivate = true
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
        .onChange(of: accountPrivate) { _ in
            presenter.accountPrivate = self.accountPrivate
            print(presenter.accountPrivate)
        }
        .background(Color.theme.backgroundcolor)
    }

    var emailField: some View {
        VStack(alignment: .center) {
            Text("Email address:")
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
            Text("Kijelentkezés")
                .font(.system(size: 20))
                .frame(height: 30)
                .cornerRadius(5)
                .padding(5)
        }
    }

    var privateToggle: some View {
        Toggle("Account láthatóság privát TODO", isOn: $accountPrivate)
    }
}
