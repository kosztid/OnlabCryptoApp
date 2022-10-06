import Foundation
import SwiftUI

class StockDetailInteractor {
    private let model: DataModel
    private let stockListItem: StockListItem
    private let symbol: String
    let downloader: SingleStockDownloader

    init(model: DataModel, symbol: String, item: StockListItem) {
        self.model = model
        self.symbol = symbol
        self.downloader = SingleStockDownloader()
        self.stockListItem = item
    }

    func getmodel() -> DataModel {
        return model
    }
    func getStockData() -> StockListItem {
        return stockListItem
    }
    func makeGraphData(values: [Double]) -> [CGFloat] {
        var data: [CGFloat]
        data = values.map { CGFloat($0)}
        return data
    }
    func getStock() {
        downloader.loadSingleStock(symbol: symbol)
    }

    func addFavCoin() {
        model.addFavStock(symbol: symbol)
    }
//    func isFav() -> Bool {
//        return !(model.favstocks.filter({ $0.symbol == self.symbol }).isEmpty)
//    }

    func getDownloader() -> SingleStockDownloader {
        return downloader
    }
}
