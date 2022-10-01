//
//  SwapInteractor.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 25..
//

import Foundation
import SwiftUI

class SwapInteractor{
    let model: DataModel

    init(model: DataModel){
        self.model = model
    }
    func selected(coin: String) -> CoinModel {
        // swiftlint:disable:next line_length
        return model.coins.first(where: {$0.id == coin}) ?? CoinModel(id: "btc", symbol: "btc", name: "btc", image: "btc", currentPrice: 10, marketCap: 10, marketCapRank: 10, fullyDilutedValuation: 10, totalVolume: 10, high24H: 10, low24H: 10, priceChange24H: 10, priceChangePercentage24H: 10, marketCapChange24H: 10, marketCapChangePercentage24H: 10, circulatingSupply: 10, totalSupply: 10, maxSupply: 10, ath: 10, athChangePercentage: 10, athDate: "btc", atl: 10, atlChangePercentage: 10, atlDate: "btc", lastUpdated: "btc", sparklineIn7D: nil, priceChangePercentage24HInCurrency: 10)
    }

    func swap(cointosell: String, sellamount: Double, cointobuy: String, buyamount: Double) {
//        var ownedamountfrombuy: Double
        let ownedamountfromsell: Double = model.ownedcoins[model.ownedcoins.firstIndex(where: { $0.coinid == cointosell })!].count
        if ownedamountfromsell < sellamount {
        } else {
//            let index = model.ownedcoins.firstIndex(where: { $0.coinid == cointobuy })
//            if model.ownedcoins.filter({ $0.coinid == cointobuy }).isEmpty == false {
//                ownedamountfrombuy = model.ownedcoins[index!].count
//            } else {
//                ownedamountfrombuy = 0
//            }
            model.modifywallet(cointosell, cointobuy, sellamount, buyamount)
            sendTradeHistory(id: "1", cointosell: cointosell, sellamount: sellamount, cointobuy: cointobuy, buyamount: buyamount)
        }
    }

    func ownedamount(coin: CoinModel) -> Double {
        let dx = model.ownedcoins.firstIndex(where: { $0.coinid == coin.id })
        if model.ownedcoins.filter({ $0.coinid == coin.id }).isEmpty == false {
            return model.ownedcoins[dx!].count
        } else {
            return 0.0
        }
    }
    
    func isOwned(coin: CoinModel) -> Bool {
        if model.ownedcoins.filter({ $0.coinid == coin.id }).isEmpty == false {
            return true
        } else {
            return false
        }
    }

    func setCoin1(coin1: String) {
        model.coin1 = coin1
    }
    func setCoin2(coin2: String) {
        model.coin2 = coin2
    }
    func setBuyorSell(boolean: String) {
        model.buyorsell = boolean
    }
    func setCoinstoBuy(amount: Double) {
        model.coinstobuy = amount
    }
    func setCoinstoSell(amount: Double) {
        model.coinstosell = amount
    }

    func getAccountInfo() -> String {
        return model.auth.currentUser?.uid ?? "nouser"
    }

    func getAccountEmail() -> String {
        return model.auth.currentUser?.email ?? "nomail"
    }

    func sendTradeHistory(id: String, cointosell: String, sellamount: Double, cointobuy: String, buyamount: Double) {
        let dateFormatter = DateFormatter()
        let historyId = "AB78B2E3-4CE1-401C-9187-824387846365"
        let email = model.auth.currentUser?.email ?? "nouser"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let stringdate = dateFormatter.string(from: Date())
        let cointosellprice = self.selected(coin: cointosell).currentPrice
        let cointobuyprice = self.selected(coin: cointobuy).currentPrice
        let messagestring = "\(email) Bought \(buyamount) \(cointobuy) (current price \(cointobuyprice)) for \(sellamount) \(cointosell) (current price \(cointosellprice)) "
        model.sendMessage(id: historyId, message: MessageModel(id: 1, sender: self.getAccountInfo(), senderemail: self.getAccountEmail(), message: messagestring, time: stringdate, image: false))
    }
}