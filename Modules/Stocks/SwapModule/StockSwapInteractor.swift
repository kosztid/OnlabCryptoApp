//
//  SwapInteractor.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 25..
//

import Foundation
import SwiftUI

class StockSwapInteractor{
    let model: DataModel

    init(model: DataModel) {
        self.model = model
    }
    func selected(stock: String) -> StockListItem {
        // swiftlint:disable:next line_length
        return model.stocks.first(where: {$0.symbol == stock}) ?? StockListItem(symbol: "err", name: "err", lastsale: "err", netchange: "err", pctchange: "err", marketCap: "err", url: "err")
    }

    func swap(stockToSell: String, sellamount: Double, stockToBuy: String, buyamount: Double) {
        let ownedamountfromsell: Double = model.ownedStocks[model.ownedStocks.firstIndex(where: { $0.stockSymbol == stockToSell })!].count
        if ownedamountfromsell < sellamount {
        } else {
            model.modifyStockwallet(stockToSell, stockToBuy, sellamount, buyamount)
            sendTradeHistory(id: "1", stockToSell: stockToSell, sellamount: sellamount, stockToBuy: stockToBuy, buyamount: buyamount)
        }
    }

    func ownedamount(stock: StockListItem) -> Double {
        let idx = model.ownedStocks.firstIndex(where: { $0.stockSymbol == stock.symbol })
        if model.ownedStocks.filter({ $0.stockSymbol == stock.symbol }).isEmpty == false {
            return model.ownedStocks[idx!].count
        } else {
            return 0.0
        }
    }

    func isOwned(stock: StockListItem) -> Bool {
        if model.ownedStocks.filter({ $0.stockSymbol == stock.symbol }).isEmpty == false {
            return true
        } else {
            return false
        }
    }

    func setStock1(stock: String) {
        model.stock1 = stock
    }
    func setStock2(stock: String) {
        model.stock2 = stock
    }
    func setBuyorSell(boolean: String) {
        model.buyorsell = boolean
    }
    func setStockstoBuy(amount: Double) {
        model.coinstobuy = amount
    }
    func setStockstoSell(amount: Double) {
        model.coinstosell = amount
    }

    func getAccountInfo() -> String {
        return model.auth.currentUser?.uid ?? "nouser"
    }

    func getAccountEmail() -> String {
        return model.auth.currentUser?.email ?? "nomail"
    }

    func sendTradeHistory(id: String, stockToSell: String, sellamount: Double, stockToBuy: String, buyamount: Double) {
        let dateFormatter = DateFormatter()
        let historyId = "AB78B2E3-4CE1-401C-9187-824387846365"
        let email = model.auth.currentUser?.email ?? "nouser"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let stringdate = dateFormatter.string(from: Date())
        let stocktosellprice = Double(self.selected(stock: stockToSell).lastsale) ?? 1
        let stocktobuyprice = Double(self.selected(stock: stockToBuy).lastsale) ?? 1
        let messagestring = "\(email) Bought \(buyamount) \(stockToBuy) (current price \(stocktobuyprice)) for \(sellamount) \(stockToSell) (current price \(stocktosellprice)) "
        model.sendMessage(id: historyId, message: MessageModel(id: 1, sender: self.getAccountInfo(), senderemail: self.getAccountEmail(), message: messagestring, time: stringdate, image: false))
    }
}
