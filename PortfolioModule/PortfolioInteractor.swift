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
        var arr: [String] = []
        for a in model.heldcoins {
            arr.append(a.coinid)
        }
        return arr
    }
    
    func heldfavcoins() -> [String] {
        var arr: [String] = []
        for a in model.favcoins {
            arr.append(a.coinid)
        }
        return arr
    }
    func getmodel() -> DataModel {
        return model
    }
    
    func removeCoin(_ index: IndexSet){
        model.removeCoin(cointoremove: model.coins[index.first!])
    }
    
    func getholdingcount(coin: CoinModel) -> Double {
        if let index = model.heldcoins.firstIndex(where: { $0.coinid == coin.id }) {
            return model.heldcoins[index].count
        }
        else {
            return 0.0
        }
    }
    func portfoliototal() -> Double{
        return model.portfoliototal()
    }
    func portfoliobuytotal() -> Double{
        return model.portfoliobuytotal()
    }
    
    func changeViewTo(viewname: String){
        model.changePortfolioViewTo(viewname: viewname)
    }
}
