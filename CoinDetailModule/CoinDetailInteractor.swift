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
    
}
