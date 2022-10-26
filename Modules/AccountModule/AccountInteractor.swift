import Foundation

class AccountInteractor {

    private let userService: UserService

    init() {
        userService = UserService()
    }
    func signOut() {
        userService.signOut()
    }

    func load() {
        userService.userReload("account")
    }

    func getVisibility() -> Published<Bool>.Publisher {
        return userService.$accountVisible
    }
    func currentUserEmail() -> String {
        userService.getUserEmail()
    }

    func changeVisibility() {
        userService.changeVisibility()
    }
}
