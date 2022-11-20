import Foundation
import Resolver
import SwiftUI

class StockSwapInteractor {
    private var userService: UserService
    private var stockService: StockService
    private var communityService: CommunityService

    init() {
        stockService = StockService()
        userService = Resolver.resolve()
        communityService = Resolver.resolve()
    }

    func loadService() {
        userService.userReload("stockswapinteractor")
    }

    func getStocks() -> Published<[StockListItem]>.Publisher {
        stockService.$stocks
    }

    func getOwnedStocks() -> Published<[StockServerModel]>.Publisher {
        userService.$stockWallet
    }

    func swap(stockToSell: String, sellamount: Double, stockToBuy: String, buyamount: Double) {
        if stockToSell == "-" || stockToBuy == "-" {
        } else {
            let ownedamountfromsell: Double = userService.stockWallet[userService.stockWallet.firstIndex { $0.stockSymbol == stockToSell }!].count
            if ownedamountfromsell >= sellamount {
                userService.updateStockWallet(stockToSell, stockToBuy, sellamount, buyamount)
                sendTradeHistory(id: "1", stockToSell: stockToSell, sellamount: sellamount, stockToBuy: stockToBuy, buyamount: buyamount)
            }
        }
    }

    func selected(stock: String) -> StockListItem {
        // swiftlint:disable:next line_length
        return stockService.stocks.first {$0.symbol == stock} ?? StockListItem(symbol: "err", name: "err", lastsale: "err", netchange: "err", pctchange: "err", marketCap: "err", url: "err")
    }
    func ownedamount(stockSymbol: String) -> Double {
        let idx = userService.stockWallet.firstIndex { $0.stockSymbol == stockSymbol }
        if userService.stockWallet.contains(where: { $0.stockSymbol == stockSymbol }) {
            return userService.stockWallet[idx!].count
        } else {
            return 0.0
        }
    }

    func isOwned(stock: StockListItem) -> Bool {
        if userService.stockWallet.contains(where: { $0.stockSymbol == stock.symbol }) {
            return true
        } else {
            return false
        }
    }

    func getAccountInfo() -> String {
        userService.getUserId()
    }

    func getAccountEmail() -> String {
        userService.getUserEmail()
    }

//    swiftlint:disable:next function_parameter_count
    func sendTradeHistory(id: String, stockToSell: String, sellamount: Double, stockToBuy: String, buyamount: Double) {
        let dateFormatter = DateFormatter()
        let historyId = "AB78B2E3-4CE1-401C-9187-824387846365"
        let mail = userService.getUserEmail()
        dateFormatter.dateFormat = Strings.dateformat
        let date = dateFormatter.string(from: Date())
        let sellPrice = Double(self.selected(stock: stockToSell).lastsale) ?? 1
        let buyPrice = Double(self.selected(stock: stockToBuy).lastsale) ?? 1
        let msgString = "\(mail) Bought \(buyamount) \(stockToBuy) (current price \(buyPrice)) for \(sellamount) \(stockToSell) (current price \(sellPrice)) "
        let message = MessageModel(id: 1, sender: self.getAccountInfo(), senderemail: self.getAccountEmail(), message: msgString, time: date, image: false)
        communityService.sendMessage(historyId, message)
    }
}
