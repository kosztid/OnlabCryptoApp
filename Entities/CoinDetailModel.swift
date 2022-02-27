//
//  CoinDetailModel.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 27..
//

import Foundation

struct CoinDetailModel: Identifiable, Codable {
    let id, symbol, name: String?
    let blockTimeInMinutes: Double?
    let hashingAlgorithm: String?
    let categories: [String]?
    let welcomeDescription: Description?
    let countryOrigin, genesisDate: String?
    let sentimentVotesUpPercentage, sentimentVotesDownPercentage: Double?
    let marketCapRank, coingeckoRank: Double?
    let coingeckoScore, developerScore, communityScore, liquidityScore: Double?
    let publicInterestScore: Double?
    let lastUpdated: String?

    enum CodingKeys: String, CodingKey {
        case id, symbol, name
        case blockTimeInMinutes = "block_time_in_minutes"
        case hashingAlgorithm = "hashing_algorithm"
        case categories
        case welcomeDescription = "description"
        case countryOrigin = "country_origin"
        case genesisDate = "genesis_date"
        case sentimentVotesUpPercentage = "sentiment_votes_up_percentage"
        case sentimentVotesDownPercentage = "sentiment_votes_down_percentage"
        case marketCapRank = "market_cap_rank"
        case coingeckoRank = "coingecko_rank"
        case coingeckoScore = "coingecko_score"
        case developerScore = "developer_score"
        case communityScore = "community_score"
        case liquidityScore = "liquidity_score"
        case publicInterestScore = "public_interest_score"
        case lastUpdated = "last_updated"
    }
    
    struct Description: Codable {
        let en: String?
    }
}
