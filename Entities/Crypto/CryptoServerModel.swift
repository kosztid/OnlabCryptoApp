import Foundation

struct CryptoServerModel: Codable {
    var id: Int
    var coinid: String
    var count: Double
    var buytotal: Double?
}

struct StockServerModel: Identifiable, Codable {
    var id: Int
    var stockSymbol: String
    var count: Double
    var buytotal: Double?
}
