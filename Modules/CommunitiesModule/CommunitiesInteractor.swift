import Foundation
import Resolver

class CommunitiesInteractor {
    private let userService: UserService
    private let communityService: CommunityService

    init() {
        userService = Resolver.resolve()
        communityService = Resolver.resolve()

        userService.loadUser()
        userService.loadUsers()
    }

    func getCommunities() -> Published<[CommunityModel]>.Publisher {
        communityService.$communities
    }

    func addCommunity(_ name: String) {
        communityService.addCommunity(name)
    }

    func getSubLogs() -> Published<[UserLog]>.Publisher {
        userService.$subsLogList
    }

    func getUsersList() -> [UserModel] {
        userService.userList
    }
    func getSubsList() -> [String] {
        print(userService.subscriptions.count)
        return userService.subscriptions
    }
    func subscribe(subId: String) {
        userService.subscribe(subId)
    }
    func reload() {
        userService.userReload("communitiesreload")
        communityService.loadCommunities()
        userService.loadUsers()
    }
    func makeMessagerInteractor() -> MessagerInteractor {
        MessagerInteractor(userService, communityService)
    }
    func getSignInStatus() -> Published<Bool>.Publisher {
        userService.$isSignedIn
    }
}
