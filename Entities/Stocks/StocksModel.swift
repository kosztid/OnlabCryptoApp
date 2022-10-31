import Foundation

// MARK: - Stocks
struct StockData: Codable {
    let data: DataClass
    let message: JSONNull?
    let status: Status
}

// MARK: - DataClass
struct DataClass: Codable {
    let filters: JSONNull?
    let table: Table
    let totalrecords: Int
    let asof: String
}

// MARK: - Table
struct Table: Codable {
    let headers: StockListItem
    let rows: [StockListItem]
}

// MARK: - Stock
struct StockListItem: Codable, Identifiable {
    let id = UUID().uuidString
    let symbol, name, lastsale, netchange: String
    let pctchange, marketCap: String
    let url: String?
}

// MARK: - Status
struct Status: Codable {
    let rCode: Int
    let bCodeMessage, developerMessage: JSONNull?
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    // swiftlint:disable:next legacy_hashing
    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
