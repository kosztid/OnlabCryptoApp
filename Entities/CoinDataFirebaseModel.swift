//
//  CoinDataFirebase.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 14..
//

import Foundation

struct CoinDataFirebaseModel: Codable {
    var id: Int
    var coinid: String
    var count: Double
    var buytotal: Double?
}
