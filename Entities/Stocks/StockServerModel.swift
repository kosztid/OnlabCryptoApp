import Foundation

struct StockServerModel: Identifiable, Codable {
    var id: Int
    var stockSymbol: String
    var count: Double
    var buytotal: Double?
}
