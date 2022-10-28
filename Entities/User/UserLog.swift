import Foundation

struct UserLog: Codable, Identifiable {
    let id: Int
    let actionType, time, userEmail: String
    let count, count2: Double
    let itemId, itemId2: String
}
