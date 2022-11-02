import Foundation
import Resolver

class AccountInteractor {
    private let userService: UserService

    init() {
        userService = Resolver.resolve()
    }
    func signOut() {
        userService.signOut()
    }

    func load() {
        userService.userReload("account")
    }

    func getVisibility() -> Published<Bool>.Publisher {
        userService.$accountVisible
    }
    func currentUserEmail() -> String {
        userService.getUserEmail()
    }

    func changeVisibility() {
        userService.changeVisibility()
    }
}
