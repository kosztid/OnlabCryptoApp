//
//  AccountView.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 13..
//

import SwiftUI

struct AccountView: View {
    var presenter: AccountPresenter
    @State var accountPrivate = true
    var body: some View {
        ZStack {
            Color.theme.backgroundcolor
            VStack {
                emailField
                privateToggle
                Spacer()

                presenter.makeLogoutButton()
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

    var privateToggle: some View {
        Toggle("Account láthatóság privát", isOn: $accountPrivate)
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(presenter: AccountPresenter(interactor: AccountInteractor(model: DataModel())))
    }
}
