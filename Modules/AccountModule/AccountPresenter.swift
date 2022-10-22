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

    func signOut() {
        interactor.signOut()
    }
}
