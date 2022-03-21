//
//  PortfolioAdderInteractor.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 02..
//

import Foundation

class PortfolioAdderInteractor{
    let coin: CoinModel
    let model: DataModel
    
    init(coin: CoinModel, model: DataModel){
        self.coin = coin
        self.model = model
    }
    
    func coindata() -> CoinModel{
        return coin
    }

    func addCoin(count: Double){
        model.addHolding(coinid: coin.id, coincount: count,currprice: coin.currentPrice)
    }
}
