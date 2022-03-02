//
//  PortfolioInteractor.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 25..
//

import Foundation

class PortfolioInteractor{
    let model: DataModel
    
    init(model: DataModel){
        self.model = model
    }
    
    func heldcoins() -> [String] {
        return model.heldcoins
    }
    func removeCoin(_ index: IndexSet){
        model.removeCoin(cointoremove: model.coins[index.first!])
    }
    
    func getholdingcount(coin: CoinModel) -> Double {
        if let index = model.heldcoins.firstIndex(where: { $0 == coin.id }) {
            return model.heldcoinscount[index]
        }
        else {
            return 0.0
        }
    }
    func portfoliototal() -> Double{
        return model.portfoliototal()
    }
}
