//
//  SwapInteractor.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 25..
//

import Foundation

class SwapInteractor{
    let model: DataModel
    
    init(model: DataModel){
        self.model = model
    }
    
    func selected(coin:String)->CoinModel{
        return model.coins.first(where: {$0.name == coin}) ?? CoinModel(id: "btc", symbol: "btc", name: "btc", image: "btc", currentPrice: 10, marketCap: 10, marketCapRank: 10, fullyDilutedValuation: 10, totalVolume: 10, high24H: 10, low24H: 10, priceChange24H: 10, priceChangePercentage24H: 10, marketCapChange24H: 10, marketCapChangePercentage24H: 10, circulatingSupply: 10, totalSupply: 10, maxSupply: 10, ath: 10, athChangePercentage: 10, athDate: "btc", atl: 10, atlChangePercentage: 10, atlDate: "btc", lastUpdated: "btc", sparklineIn7D: nil, priceChangePercentage24HInCurrency: 10)
    }
}
