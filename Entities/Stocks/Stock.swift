//
//  Stock.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 09. 28..
//

import Foundation

struct Stock: Codable, Identifiable {
    let id = UUID().uuidString
    let ticker: String
    let queryCount, resultsCount: Int
    let adjusted: Bool
    let results: [Result]
    let status, requestID: String
    let count: Int

    enum CodingKeys: String, CodingKey {
        case ticker, queryCount, resultsCount, adjusted, results, status
        case requestID = "request_id"
        case count
    }
}

// swiftlint:disable all
// MARK: - Result
struct Result: Codable {
    let v: Int
    let vw, o, c, h: Double
    let l: Double
    let t, n: Int
}
// swiftlint:enable all
