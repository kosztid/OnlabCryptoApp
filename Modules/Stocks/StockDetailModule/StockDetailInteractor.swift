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
        stockListItem
    }
    func makeGraphData(values: [Double]) -> [CGFloat] {
        var data: [CGFloat]
        data = values.map { CGFloat($0)}
        return data
    }

    func getFavs() -> Published<[StockServerModel]>.Publisher {
        userService.$stockFavs
    }

    func getSignInStatus() -> Published<Bool>.Publisher {
        userService.$isSignedIn
    }
    func getStock() {
        downloader.loadSingleStock(symbol: symbol)
    }
    func getStockCount() -> Double {
        if let index = userService.stockPortfolio.firstIndex(where: { $0.stockSymbol == self.symbol}) {
            return userService.stockPortfolio[index].count
        } else {
            return 0.0
        }
    }

    func addFavStock() {
        userService.updateStockFavs(symbol)
    }
    func isFav() -> Bool {
        userService.stockFavs.contains { $0.stockSymbol == self.symbol }
    }
    func addPortfolio(amount: Double, currentprice: Double) {
        userService.updateStockPortfolio(self.symbol, amount, currentprice)
    }
    func getDownloader() -> SingleStockDownloader {
        downloader
    }
}
