import Foundation

class RegisterScreenInteractor {
    private let userService: UserService

    init() {
        userService = UserService()
        userService.userReload()
    }
    func register(email: String, password: String) {
        userService.register(email, password)
    }

    func getRegisterError() -> Published<Bool>.Publisher {
        return userService.$registerError
    }
    func getRegistered() -> Published<Bool>.Publisher {
        return userService.$registered
    }

    func setregistererrorfalse() {
        userService.registerError = false
    }
    func setregisteredfalse() {
        userService.registered = false
    }
}
