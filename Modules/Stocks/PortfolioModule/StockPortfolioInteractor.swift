import Foundation

class StockPortfolioInteractor {
    let model: DataModel
    let downloader: SingleStockDownloader

    init(model: DataModel) {
        self.downloader = SingleStockDownloader()
        self.model = model
    }

    func changeViewTo(viewname: String) {
        model.selection = viewname
    }

    func getStock(symbol: String) -> StockListItem {
        return model.stocks.first(where: {$0.symbol == symbol.uppercased()}) ?? StockListItem(symbol: "", name: "", lastsale: "", netchange: "", pctchange: "", marketCap: "", url: "")
    }

    func portfoliototal() -> Double {
        if model.heldStocks.count == 0 {
            return 0
        }
        var total: Double = 0
        for ind in 0...(model.heldStocks.count - 1) {
            let currentprice = Double(model.stocks.first(where: {$0.symbol == model.heldStocks[ind].stockSymbol})?.lastsale.dropFirst() ?? "") ?? 0
            total += (model.heldStocks[ind].count * currentprice)
        }
        return total
    }

    func portfoliobuytotal() -> Double {
        if model.heldStocks.count == 0 {
            return 0
        }
        var total: Double = 0
        for ind in 0...(model.heldStocks.count-1) {
            total += (model.heldStocks[ind].buytotal ?? 0)
        }
        return total
    }

    func favfoliochange() -> Double {
        if model.favStocks.count == 0 {
            return 0
        }
        var total: Double = 0
        for ind in 0...(model.favStocks.count-1) {
            let idx = model.stocks.firstIndex(where: { $0.symbol == model.stocks[ind].symbol })
            total += Double(model.stocks[idx!].pctchange.dropFirst()) ?? 0
        }
        total /= Double(model.favcoins.count)
        return total
    }

    func setFav(_ symbol: String) {
        model.addFavStock(symbol: symbol)
    }
    func getDownloader() -> SingleStockDownloader {
        return downloader
    }
}
