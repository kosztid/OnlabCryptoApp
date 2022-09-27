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
        for coin in model.heldcoins {
            arr.append(coin.coinid)
        }
        return arr
    }
    
    func heldfavcoins() -> [String] {
        var arr: [String] = []
        for coin in model.favcoins {
            arr.append(coin.coinid)
        }
        return arr
    }

    func ownedcoins() -> [String] {
        var arr: [String] = []
        for coin in model.ownedcoins {
            arr.append(coin.coinid)
        }
        return arr
    }

    func getmodel() -> DataModel {
        return model
    }
    
    func removeCoin(_ index: IndexSet) {
        model.removeCoin(cointoremove: model.coins[index.first!])
    }
    
    func getholdingcount(coin: CoinModel) -> Double {
        if let index = model.heldcoins.firstIndex(where: { $0.coinid == coin.id }) {
            return model.heldcoins[index].count
        } else {
            return 0.0
        }
    }

    func getownedcount(coin: CoinModel) -> Double{
        if let index = model.ownedcoins.firstIndex(where: { $0.coinid == coin.id }) {
            return model.ownedcoins[index].count
        } else {
            return 0.0
        }
    }
    
    func portfoliototal() -> Double {
        
        if model.heldcoins.count == 0 {
            return 0
        }
        var total: Double = 0
        for ind in 0...(model.heldcoins.count - 1) {
            let currentprice = model.coins.first(where: {$0.id == model.heldcoins[ind].coinid})?.currentPrice ?? 0.0
            total += (model.heldcoins[ind].count * currentprice)
        }
        return total
    }
    
    func portfoliobuytotal() -> Double{
        if model.heldcoins.count == 0 {
            return 0
        }
        var total: Double = 0
        for ind in 0...(model.heldcoins.count-1) {
            total += (model.heldcoins[ind].buytotal ?? 0)
        }
        return total
    }

    func wallettotal() -> Double{
        if model.ownedcoins.count == 0 {
            return 0
        }
        var total: Double = 0
        for ind in 0...(model.ownedcoins.count - 1) {
            let coindx = model.coins.firstIndex(where: { $0.id == model.ownedcoins[ind].coinid })
            total += model.ownedcoins[ind].count * model.coins[coindx!].currentPrice
        }
        return total
    }
    func walletyesterday() -> Double {
        return (self.wallettotal()-self.walletchange())
    }
    func walletchange()->Double{
        if model.ownedcoins.count == 0 {
            return 0
        }
        var total: Double = 0
        for ind in 0...(model.ownedcoins.count-1) {
            let dx = model.coins.firstIndex(where: { $0.id == model.ownedcoins[ind].coinid })
            let change = model.coins[dx!].priceChange24H ?? 0
            let changecounted = model.ownedcoins[ind].count * change
            total += changecounted
        }
        return total
    }
    
    func favfoliochange() -> Double {
        if model.favcoins.count == 0 {
            return 0
        }
        var total: Double = 0
        for ind in 0...(model.favcoins.count-1) {
            let dx = model.coins.firstIndex(where: { $0.id == model.favcoins[ind].coinid })
            total += model.coins[dx!].priceChangePercentage24H ?? 0
        }
        total /= Double(model.favcoins.count)
        return total
    }
    
    func changeViewTo(viewname: String) {
        model.selection = viewname
    }
}
