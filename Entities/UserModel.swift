//
//  UserModel.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 09. 17..
//

import Foundation

struct UserModel: Codable {
    let id, email: String
    let favfolio: [CoinDataFirebaseModel]
    let portfolio: [CoinDataFirebaseModel]
    let wallet: [CoinDataFirebaseModel]
}
