import Foundation
import Resolver

class StockPortfolioInteractor {
    let downloader: SingleStockDownloader
    private var userService: UserService
    var stockService: StockService

    init() {
        self.downloader = SingleStockDownloader()
        stockService = StockService()
        userService = Resolver.resolve()
        userService.userReload("stockportfoliointeracotr")
    }

    func getCoins() -> Published<[StockListItem]>.Publisher {
        stockService.$stocks
    }

    func getSignInStatus() -> Published<Bool>.Publisher {
        userService.$isSignedIn
    }

    func getFavs() -> Published<[StockServerModel]>.Publisher {
        userService.$stockFavs
    }
    func getHeld() -> Published<[StockServerModel]>.Publisher {
        userService.$stockPortfolio
    }
    func getOwned() -> Published<[StockServerModel]>.Publisher {
        userService.$stockWallet
    }
    func getservice() -> UserService {
        userService
    }

    func getStock(symbol: String) -> StockListItem {
        let baseItem = StockListItem(symbol: "", name: "", lastsale: "", netchange: "", pctchange: "", marketCap: "", url: "")
        return stockService.stocks.first {$0.symbol == symbol.uppercased()} ?? baseItem
    }
    func makeDetailInteractor(symbol: String, item: StockListItem) -> StockDetailInteractor {
        StockDetailInteractor(symbol: symbol, item: item, service: userService)
    }

    func portfoliototal() -> Double {
        if userService.stockPortfolio.isEmpty {
            return 0
        }
        var total: Double = 0
        for ind in 0...(userService.stockPortfolio.count - 1) {
            let currentprice = Double(stockService.stocks.first {$0.symbol == userService.stockPortfolio[ind].stockSymbol}?.lastsale.dropFirst() ?? "") ?? 0
            total += (userService.stockPortfolio[ind].count * currentprice)
        }
        return total
    }

    func portfoliobuytotal() -> Double {
        if userService.stockPortfolio.isEmpty {
            return 0
        }
        var total: Double = 0
        for ind in 0...(userService.stockPortfolio.count - 1) {
            total += (userService.stockPortfolio[ind].count * (userService.stockPortfolio[ind].buytotal ?? 0))
        }
        return total
    }

    func favfoliochange() -> Double {
        if userService.stockFavs.isEmpty {
            return 0
        }
        var total: Double = 0
        for ind in 0...(userService.stockFavs.count - 1) {
            let idx = stockService.stocks.firstIndex { $0.symbol == stockService.stocks[ind].symbol }
            total += Double(stockService.stocks[idx!].pctchange.dropFirst()) ?? 0
        }
        total /= Double(userService.stockFavs.count)
        return total
    }

    func wallettotal() -> Double {
        if userService.stockWallet.isEmpty {
            return 0
        }
        var total: Double = 0
        for ind in 0...(userService.stockWallet.count - 1) {
            let coindx = stockService.stocks.firstIndex { $0.symbol == userService.stockWallet[ind].stockSymbol }
            total += userService.stockWallet[ind].count * (Double(stockService.stocks[coindx!].lastsale.dropFirst()) ?? 0)
        }
        return total
    }
    func walletyesterday() -> Double {
        (self.wallettotal() - self.walletchange())
    }
    func walletchange() -> Double {
        if userService.cryptoWallet.isEmpty {
            return 0
        }
        var total: Double = 0
        for ind in 0...(userService.stockWallet.count - 1) {
            let idx = stockService.stocks.firstIndex { $0.symbol == userService.stockWallet[ind].stockSymbol }
            let change = Double(stockService.stocks[idx!].pctchange.dropLast(1)) ?? 0
            let changecounted = userService.stockWallet[ind].count * change
            total += changecounted
        }
        return total
    }

    func reloadData() {
        userService.userReload("stockprotffunc")
    }

    func setFav(_ symbol: String) {
        userService.updateStockFavs(symbol)
    }
    func getDownloader() -> SingleStockDownloader {
        downloader
    }
}
