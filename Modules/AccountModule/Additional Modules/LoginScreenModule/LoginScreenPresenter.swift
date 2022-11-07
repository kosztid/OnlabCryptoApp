import Combine
import Foundation
import SwiftUI

class LoginScreenPresenter: ObservableObject {
    private let interactor: LoginScreenInteractor
    private let router = LoginScreenRouter()
    @Published var signedin = false
    @Published var loginerror = false
    private var cancellables = Set<AnyCancellable>()

    init(interactor: LoginScreenInteractor) {
        self.interactor = interactor

        interactor.getSignInStatus()
            .assign(to: \.signedin, on: self)
            .store(in: &cancellables)

        interactor.getLoginError()
            .assign(to: \.loginerror, on: self)
            .store(in: &cancellables)
    }

    func signIn(email: String, password: String) {
        interactor.signIn(email: email, password: password)
    }
    func setlogerrorfalse() {
        interactor.setlogerrorfalse()
    }

    func toRegisterView() -> some View {
        NavigationLink(destination: router.makeRegisterView()) {
            Text(Strings.registration)
                .frame(width: UIScreen.main.bounds.width * 0.3)
        }
            .buttonStyle(UnifiedBorderedButtonStyle())
    }

    func load() {
        interactor.load()
    }
    func isValidEmail(email: String) -> Bool {
        let emailto = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return emailto.evaluate(with: email)
    }
}
