import Foundation

class CommunitiesInteractor {
    private let userService: UserService
    private let communityService: CommunityService

    init() {
        userService = UserService()
        communityService = CommunityService()

        userService.loadUser()
        userService.loadUsers()
    }

    func getCommunities() -> Published<[CommunityModel]>.Publisher {
        return communityService.$communities
    }

    func addCommunity(_ name: String) {
        communityService.addCommunity(name)
    }

    func getSubLogs() -> Published<[UserLog]>.Publisher {
        return userService.$subsLogList
    }

    func getUsersList() -> [UserModel] {
        return userService.userList
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
    }
    func makeMessagerInteractor() -> MessagerInteractor {
        MessagerInteractor(userService, communityService)
    }
    func getSignInStatus() -> Published<Bool>.Publisher {
        return userService.$isSignedIn
    }
}
