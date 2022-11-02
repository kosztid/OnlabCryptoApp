import Foundation
import Resolver

class LoginScreenInteractor {
    private let userService: UserService

    init() {
        userService = Resolver.resolve()
    }
    func signIn(email: String, password: String) {
        userService.signin(email, password)
    }

    func getSignInStatus() -> Published<Bool>.Publisher {
        userService.$isSignedIn
    }

    func getLoginError() -> Published<Bool>.Publisher {
        userService.$loginError
    }
    func load() {
        userService.userReload("loginint")
    }
    func setlogerrorfalse() {
        userService.loginError = false
    }
}
