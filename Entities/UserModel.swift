import Foundation

struct UserModel: Codable {
    let id, email: String
    let favfolio: [CryptoServerModel]
    let portfolio: [CryptoServerModel]
    let wallet: [CryptoServerModel]
    let stockfavfolio: [StockServerModel]
    let stockportfolio: [StockServerModel]
    let stockwallet: [StockServerModel]
}
