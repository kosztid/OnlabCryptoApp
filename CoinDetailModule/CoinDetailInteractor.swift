//
//  CoinDetailInteractor.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 26..
//

import Foundation
import SwiftUI

class CoinDetailInteractor{
    private let coin: CoinModel
    private let model: DataModel
    
    init(coin: CoinModel, model: DataModel){
        self.coin = coin
        self.model = model
    }
    
    func getvalues() -> [CGFloat]{
        var newData: [CGFloat]
        let olddata = coin.sparklineIn7D?.price ?? []
        newData = olddata.map{CGFloat($0)}
        return newData
    }
    func getcoin() -> CoinModel {
        return coin
    }
    
    func getmodel() -> DataModel {
        return model
    }
    func held() -> Bool{
        return !(model.heldcoins.filter({ $0.coinid == self.coin.id }).isEmpty)
    }
    
    func getCoinCount() -> Double{
        if let index = model.heldcoins.firstIndex(where: { $0.coinid == coin.id }) {
            return model.heldcoins[index].count
        } else {
            return 0.0
        }
    }
    
    func addFavCoin(){
        model.addFavCoin(coinid: coin.id)
    }
    func isFav()->Bool{
        return !(model.favcoins.filter({ $0.coinid == self.coin.id }).isEmpty)
    }
}
