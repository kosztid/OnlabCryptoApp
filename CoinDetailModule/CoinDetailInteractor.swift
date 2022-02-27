//
//  CoinDetailInteractor.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 26..
//

import Foundation
import SwiftUI

class CoinDetailInteractor{
    let coin: CoinModel
    let model: DataModel
    
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
    
    func getcoindetail() -> CoinDetailModel{
        return model.loaddetailedcoin(coinid: coin.id)
    }
}
