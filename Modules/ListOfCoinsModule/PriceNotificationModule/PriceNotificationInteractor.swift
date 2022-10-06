//
//  PriceNotificationInteractor.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 05. 02..
//

import Foundation

class PriceNotificationInteractor {
    let model: DataModel

    init(model: DataModel) {
        self.model = model
    }

    func currentPrice(coinid: String) -> Double {
        return model.coins.first(where: {$0.id == coinid})?.currentPrice ?? 0
    }
    func coinname(coinid: String) -> String {
        return model.coins.first(where: {$0.id == coinid})?.name ?? "noname"
    }
}


