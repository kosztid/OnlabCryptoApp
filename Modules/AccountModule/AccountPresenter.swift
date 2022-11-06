import Combine
import Foundation
import SwiftUI

class AccountPresenter: ObservableObject {
    private let interactor: AccountInteractor
    private var cancellables = Set<AnyCancellable>()

    @Published var accountVisibility = true

    init(interactor: AccountInteractor) {
        self.interactor = interactor

        self.accountVisibility = interactor.getVisibility()
    }

    func currentUserEmail() -> String {
        interactor.currentUserEmail()
    }

    func changeVisibility() {
        self.accountVisibility.toggle()
        interactor.changeVisibility()
    }

    func load() {
        interactor.load()
    }

    func signOut() {
        interactor.signOut()
    }
}
