//
//  FavfolioListItemInteractor.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 19..
//

import Foundation

class FavfolioListItemInteractor{
    private let coin: CoinModel
    private let model: DataModel
    
    init(coin: CoinModel,model: DataModel){
        self.coin = coin
        self.model = model
    }
    
    func addFavCoin(){
        model.addFavCoin(coinid: coin.id)
    }
    func getcoin() -> CoinModel {
        return coin
    }
    
    func isFav()->Bool{
        return !(model.favcoins.filter({ $0.coinid == self.coin.id }).isEmpty)
    }
}
