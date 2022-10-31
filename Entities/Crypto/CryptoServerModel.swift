import Foundation

struct CryptoServerModel: Codable, Equatable {
    var id: Int
    var coinid: String
    var count: Double
    var buytotal: Double?

    static func == (lhs: CryptoServerModel, rhs: CryptoServerModel) -> Bool {
        return lhs.count == rhs.count
    }
}
