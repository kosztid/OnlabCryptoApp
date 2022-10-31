import Foundation

struct UserModel: Codable, Identifiable {
    let id, email: String
    var visibility: Bool
    let favfolio: [CryptoServerModel]
    let portfolio: [CryptoServerModel]
    let wallet: [CryptoServerModel]
    let stockfavfolio: [StockServerModel]
    let stockportfolio: [StockServerModel]
    let stockwallet: [StockServerModel]
    let subscriptions: [String]
    let userLogs: [UserLog]
}
