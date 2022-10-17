import Foundation
import Combine

class PortfolioInteractor {
    let model: DataModel
    private var userService: UserService
    var coinService: CoinService

    init(model: DataModel) {
        self.model = model
        coinService = CoinService()
        userService = UserService()
        userService.userReload()
    }

    func makeDetailInteractor(coin: CoinModel) -> CoinDetailInteractor {
        CoinDetailInteractor(coin: coin, model: model, service: userService)
    }

    func getCoins() -> Published<[CoinModel]>.Publisher {
        return coinService.$coins
    }

    func getFavs() -> Published<[CryptoServerModel]>.Publisher {
        return userService.$cryptoFavs
    }
    func getservice() -> UserService {
        return userService
    }

    func reloadData() {
        userService.loadUser()
    }

    func heldcoins() -> [String] {
        var arr: [String] = []
        for coin in userService.cryptoPortfolio {
            arr.append(coin.coinid)
        }
        return arr
    }

    func heldfavcoins() -> [String] {
        var arr: [String] = []
        for coin in userService.cryptoFavs {
            arr.append(coin.coinid)
        }
        return arr
    }

    func ownedcoins() -> [String] {
        var arr: [String] = []
        for coin in userService.cryptoWallet {
            arr.append(coin.coinid)
        }
        return arr
    }

    func getmodel() -> DataModel {
        return model
    }

    func removeCoin(_ index: IndexSet) {
        userService.updatePortfolio(coinService.coins[index.first!].id, 0.0, 0.0)
    }

    func getholdingcount(coin: CoinModel) -> Double {
        if let index = userService.cryptoPortfolio.firstIndex(where: { $0.coinid == coin.id }) {
            return userService.cryptoPortfolio[index].count
        } else {
            return 0.0
        }
    }

    func getownedcount(coin: CoinModel) -> Double {
        if let index = userService.cryptoWallet.firstIndex(where: { $0.coinid == coin.id }) {
            return userService.cryptoWallet[index].count
        } else {
            return 0.0
        }
    }

    func portfoliototal() -> Double {
        if userService.cryptoPortfolio.count == 0 {
            return 0
        }
        var total: Double = 0
        for ind in 0...(userService.cryptoPortfolio.count - 1) {
            let currentprice = coinService.coins.first(where: {$0.id == userService.cryptoPortfolio[ind].coinid})?.currentPrice ?? 0.0
            total += (userService.cryptoPortfolio[ind].count * currentprice)
        }
        return total
    }

    func portfoliobuytotal() -> Double {
        if userService.cryptoPortfolio.count == 0 {
            return 0
        }
        var total: Double = 0
        for ind in 0...(userService.cryptoPortfolio.count-1) {
            total += (userService.cryptoPortfolio[ind].count * (userService.cryptoPortfolio[ind].buytotal ?? 0))
        }
        return total
    }

    func wallettotal() -> Double {
        if userService.cryptoWallet.count == 0 {
            return 0
        }
        var total: Double = 0
        for ind in 0...(userService.cryptoWallet.count - 1) {
            let coindx = coinService.coins.firstIndex(where: { $0.id == userService.cryptoWallet[ind].coinid })
            total += userService.cryptoWallet[ind].count * model.coins[coindx!].currentPrice
        }
        return total
    }
    func walletyesterday() -> Double {
        return (self.wallettotal()-self.walletchange())
    }
    func walletchange() -> Double {
        if userService.cryptoWallet.count == 0 {
            return 0
        }
        var total: Double = 0
        for ind in 0...(userService.cryptoWallet.count-1) {
            let idx = coinService.coins.firstIndex(where: { $0.id == userService.cryptoWallet[ind].coinid })
            let change = coinService.coins[idx!].priceChange24H ?? 0
            let changecounted = userService.cryptoWallet[ind].count * change
            total += changecounted
        }
        return total
    }

    func favfoliochange() -> Double {
        if userService.cryptoFavs.count == 0 {
            return 0
        }
        var total: Double = 0
        for ind in 0...(userService.cryptoFavs.count-1) {
            let idx = coinService.coins.firstIndex(where: { $0.id == userService.cryptoFavs[ind].coinid })
            total += coinService.coins[idx!].priceChangePercentage24H ?? 0
        }
        total /= Double(model.favcoins.count)
        return total
    }

    func changeViewTo(viewname: String) {
        model.selection = viewname
    }
}
