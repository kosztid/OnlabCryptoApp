import Foundation
import SwiftUI
import Resolver

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
        return stockService.$stocks
    }

    func getOwnedStocks() -> Published<[StockServerModel]>.Publisher {
        return userService.$stockWallet
    }

    func swap(stockToSell: String, sellamount: Double, stockToBuy: String, buyamount: Double) {
        let ownedamountfromsell: Double = userService.stockWallet[userService.stockWallet.firstIndex(where: { $0.stockSymbol == stockToSell })!].count
        if ownedamountfromsell > sellamount {
            userService.updateStockWallet(stockToSell, stockToBuy, sellamount, buyamount)
            sendTradeHistory(id: "1", stockToSell: stockToSell, sellamount: sellamount, stockToBuy: stockToBuy, buyamount: buyamount)
        }
    }

    func selected(stock: String) -> StockListItem {
        // swiftlint:disable:next line_length
        return stockService.stocks.first(where: {$0.symbol == stock}) ?? StockListItem(symbol: "err", name: "err", lastsale: "err", netchange: "err", pctchange: "err", marketCap: "err", url: "err")
    }
    func ownedamount(stockSymbol: String) -> Double {
        let idx = userService.stockWallet.firstIndex(where: { $0.stockSymbol == stockSymbol })
        if userService.stockWallet.filter({ $0.stockSymbol == stockSymbol }).isEmpty == false {
            return userService.stockWallet[idx!].count
        } else {
            return 0.0
        }
    }

    func isOwned(stock: StockListItem) -> Bool {
        if userService.stockWallet.filter({ $0.stockSymbol == stock.symbol }).isEmpty == false {
            return true
        } else {
            return false
        }
    }

    func getAccountInfo() -> String {
        return userService.getUserId()
    }

    func getAccountEmail() -> String {
        return userService.getUserEmail()
    }

    func sendTradeHistory(id: String, stockToSell: String, sellamount: Double, stockToBuy: String, buyamount: Double) {
        let dateFormatter = DateFormatter()
        let historyId = "AB78B2E3-4CE1-401C-9187-824387846365"
        let email = userService.getUserEmail()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let stringdate = dateFormatter.string(from: Date())
        let stocktosellprice = Double(self.selected(stock: stockToSell).lastsale) ?? 1
        let stocktobuyprice = Double(self.selected(stock: stockToBuy).lastsale) ?? 1
        let messagestring = "\(email) Bought \(buyamount) \(stockToBuy) (current price \(stocktobuyprice)) for \(sellamount) \(stockToSell) (current price \(stocktosellprice)) "
        let message = MessageModel(id: 1, sender: self.getAccountInfo(), senderemail: self.getAccountEmail(), message: messagestring, time: stringdate, image: false)
        communityService.sendMessage(historyId, message)
    }
}
