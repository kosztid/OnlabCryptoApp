import Foundation

struct MessageModel: Identifiable, Codable {
    var id: Int
    var sender: String
    var senderemail: String
    var message: String
    var time: String
    var image: Bool
}
