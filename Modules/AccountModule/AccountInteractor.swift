import Foundation

class AccountInteractor {

    private let userService: UserService

    init() {
        userService = UserService()
        userService.userReload()
    }
    func signOut() {
        userService.signOut()
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
