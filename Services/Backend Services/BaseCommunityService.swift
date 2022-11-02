import Foundation
import SwiftUI

class BaseCommunityService {
    @Published var communities: [CommunityModel] = []
}

protocol CommunityService: BaseCommunityService {
    func sendMessage(_ communityID: String, _ message: MessageModel)
    func loadCommunities()
    func sendPhoto(image: UIImage, message: MessageModel, communityid: String)
    func addCommunity(_ communityName: String)
}
