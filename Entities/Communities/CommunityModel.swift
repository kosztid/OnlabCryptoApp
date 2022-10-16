import Foundation

struct CommunityModel: Identifiable, Codable {
    var id: String
    var name: String
    var messages: [MessageModel]
    var members: [String]
    var lastid: Int?
}
