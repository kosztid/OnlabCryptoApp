import Foundation
import SwiftUI

class AccountPresenter {
    private let interactor: AccountInteractor

    @Published var accountPrivate = true

    init(interactor: AccountInteractor) {
        self.interactor = interactor
    }

    func currentUserEmail() -> String {
        return interactor.currentUserEmail()
    }

    func makeLogoutButton () -> some View {
        Button {
            self.interactor.signOut()
        } label: {
            Text("Kijelentkezés")
                .font(.system(size: 20))
                .frame(height: 30)
                .cornerRadius(5)
                .padding(5)
        }
    }
}
