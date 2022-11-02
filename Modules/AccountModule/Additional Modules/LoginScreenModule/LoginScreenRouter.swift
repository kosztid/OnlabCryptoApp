import Foundation
import SwiftUI

class LoginScreenRouter {
    func makeRegisterView() -> some View {
        let presenter = RegisterScreenPresenter(interactor: RegisterScreenInteractor())
        return RegisterScreenView(presenter: presenter)
    }
}
