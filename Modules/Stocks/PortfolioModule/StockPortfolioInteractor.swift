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

    func setFav(_ symbol: String) {
        model.addFavStock(symbol: symbol)
    }
    func getDownloader() -> SingleStockDownloader {
        return downloader
    }
}
