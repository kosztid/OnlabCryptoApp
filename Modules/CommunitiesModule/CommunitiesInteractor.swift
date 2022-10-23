import Foundation

class CommunitiesInteractor {
    private let userService: UserService
    private let communityService: CommunityService

    init() {
        userService = UserService()
        communityService = CommunityService()

        userService.loadUser()
    }

    func getCommunities() -> Published<[CommunityModel]>.Publisher {
        return communityService.$communities
    }

    func addCommunity(_ name: String) {
        communityService.addCommunity(name)
    }

    func reload() {
        communityService.loadCommunities()
    }
    func makeMessagerInteractor() -> MessagerInteractor {
        MessagerInteractor(userService, communityService)
    }
    func getSignInStatus() -> Published<Bool>.Publisher {
        return userService.$isSignedIn
    }
}
