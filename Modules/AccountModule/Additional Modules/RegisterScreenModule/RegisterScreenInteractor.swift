import Foundation
import Resolver

class RegisterScreenInteractor {
    private let userService: UserService

    init() {
        userService = Resolver.resolve()
    }
    func register(email: String, password: String) {
        userService.register(email, password)
    }

    func getRegisterError() -> Published<Bool>.Publisher {
        userService.$registerError
    }
    func getRegistered() -> Published<Bool>.Publisher {
        userService.$registered
    }

    func load() {
        userService.userReload("register")
    }
    func setregistererrorfalse() {
        userService.registerError = false
    }
    func setregisteredfalse() {
        userService.registered = false
    }
}
