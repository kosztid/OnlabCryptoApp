import Combine
import FirebaseAuth
import FirebaseStorage
import Foundation
import SwiftUI

// swiftlint:disable all
class TestCommunityService: BaseCommunityService, CommunityService {
    var communitySub: AnyCancellable?

    override init() {
        super.init()
        loadCommunities()
    }

    func sendMessage(_ communityID: String, _ message: MessageModel) {
        let dx = communities.firstIndex { $0.id == communityID} ?? 0
        communities[dx].messages.append(message)
        if !communities[dx].members.contains(where: { $0 == message.senderemail}) {
            communities[dx].members.append(message.senderemail)
        }
    }

    func sendPhoto(image: UIImage, message: MessageModel, communityid: String) {
        let dx = communities.firstIndex { $0.id == communityid} ?? 0
        communities[dx].messages.append(message)
        if !communities[dx].members.contains(where: { $0 == message.senderemail}) {
            communities[dx].members.append(message.senderemail)
        }
    }

    func loadCommunities() {
        communities = [CommunityModel(id: "2", name: "Bitcoin", messages: [MessageModel(id: 1, sender: "test1", senderemail: "test1@gmail.com", message: "testmessage", time: "2022-10-28 13:13:13", image: false), MessageModel(id: 2, sender: "test2", senderemail: "test2@gmail.com", message: "testmessage2", time: "2022-10-28 14:14:14", image: false)], members: ["test1@gmail.com", "test2@gmail.com"]), CommunityModel(id: "3", name: "Test", messages: [], members: [])]
    }
    func addCommunity(_ communityName: String) {
        communities.append(CommunityModel(id: UUID().uuidString, name: communityName, messages: [], members: []))
    }
}
// swiftlint:enable all
