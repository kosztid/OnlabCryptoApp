import Foundation
import SwiftUI

class StockDetailInteractor {
    private let stockListItem: StockListItem
    private var userService: UserService
    private let symbol: String
    private let downloader: SingleStockDownloader

    init(symbol: String, item: StockListItem, service: UserService) {
        self.symbol = symbol
        self.userService = service
        self.downloader = SingleStockDownloader()
        self.stockListItem = item
    }
    
    func getStockData() -> StockListItem {
        return stockListItem
    }
    func makeGraphData(values: [Double]) -> [CGFloat] {
        var data: [CGFloat]
        data = values.map { CGFloat($0)}
        return data
    }

    func getFavs() -> Published<[StockServerModel]>.Publisher {
        return userService.$stockFavs
    }

    func getSignInStatus() -> Published<Bool>.Publisher {
        return userService.$isSignedIn
    }
    func getStock() {
        downloader.loadSingleStock(symbol: symbol)
    }

    func addFavStock() {
        userService.updateStockFavs(symbol)
    }
    func isFav() -> Bool {
        return !(userService.stockFavs.filter({ $0.stockSymbol == self.symbol }).isEmpty)
    }
    func addPortfolio(amount: Double, currentprice: Double) {
        userService.updateStockPortfolio(self.symbol, amount, currentprice)
    }
    func getDownloader() -> SingleStockDownloader {
        return downloader
    }
}
