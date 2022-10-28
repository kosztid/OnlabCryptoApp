import Foundation

class BaseCommunityService {
    @Published var communities: [CommunityModel] = []
}

protocol CommunityService: BaseCommunityService {
    func sendMessage(_ communityID: String, _ message: MessageModel)
    func loadCommunities()
    func addCommunity(_ communityName: String)
}
