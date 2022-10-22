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

    func currentUserEmail() -> String {
        userService.getUserEmail()
    }
}
