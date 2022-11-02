import Combine
import Foundation
import SwiftUI

class AccountPresenter {
    private let interactor: AccountInteractor
    private var cancellables = Set<AnyCancellable>()

    @Published var accountVisibility = true

    init(interactor: AccountInteractor) {
        self.interactor = interactor

        interactor.getVisibility()
            .assign(to: \.accountVisibility, on: self)
            .store(in: &cancellables)
    }

    func currentUserEmail() -> String {
        interactor.currentUserEmail()
    }

    func changeVisibility() {
        interactor.changeVisibility()
    }

    func load() {
        interactor.load()
    }

    func signOut() {
        interactor.signOut()
    }
}
