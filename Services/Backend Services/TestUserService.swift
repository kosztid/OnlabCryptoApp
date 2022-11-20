import Combine
import Foundation
// swiftlint:disable all
final class TestUserService: BaseUserService, UserService, ObservableObject {
    var userSub: AnyCancellable?
    var usersSub: AnyCancellable?
    var userLogsSub: AnyCancellable?

    override init() {
        super.init()
        accountVisible = false
        self.cryptoPortfolio = [CryptoServerModel(id: 1, coinid: "bitcoin", count: 10.0), CryptoServerModel(id: 2, coinid: "ethereum", count: 20.0)]
        self.cryptoFavs = [CryptoServerModel(id: 1, coinid: "bitcoin", count: 0.0)]
        self.cryptoWallet = [CryptoServerModel(id: 1, coinid: "bitcoin", count: 10.0), CryptoServerModel(id: 2, coinid: "ethereum", count: 20.0), CryptoServerModel(id: 3, coinid: "tether", count: 10000.0)]

        self.stockPortfolio = [StockServerModel(id: 1, stockSymbol: "AAPL", count: 10.0), StockServerModel(id: 2, stockSymbol: "AMZN", count: 15)]
        self.stockFavs = [StockServerModel(id: 1, stockSymbol: "AAPL", count: 10.0)]
        self.stockWallet = [StockServerModel(id: 1, stockSymbol: "AAPL", count: 10.0), StockServerModel(id: 2, stockSymbol: "AMZN", count: 15.0), StockServerModel(id: 3, stockSymbol: "GOOGL", count: 5.0)]
    }

    func signOut() {
        print("signout")
        self.isSignedIn = false
    }

    func signin(_ email: String, _ password: String) {
        print("signin")
        self.isSignedIn = true
    }

    func register(_ email: String, _ password: String) {
        self.registered = true
    }

    func userReload(_ origin: String = "Basic") {
        print("reloadedData \(origin)")
    }

    func getUserId() -> String {
        "unittestuser"
    }

    func getUserEmail() -> String {
        "unittestuser@test.com"
    }

    // MARK: - User data, account
    func loadUser() {
    }

    func registerUser(_ apikey: String, _ userId: String, _ email: String) {
        print("registeredUser")
    }

    // MARK: - Crypto portfolio
    func updateWallet(_ coinToSell: String, _ coinToBuy: String, _ sellAmount: Double, _ buyAmount: Double) {
        var idx = 0
        idx = cryptoWallet.firstIndex { $0.coinid == coinToSell} ?? 0
        cryptoWallet[idx].count -= sellAmount
        idx = cryptoWallet.firstIndex { $0.coinid == coinToBuy} ?? 0
        cryptoWallet[idx].count += buyAmount
    }

    func updatePortfolio(_ coinId: String, _ count: Double, _ buytotal: Double) {
        var idx = 0
        idx = cryptoPortfolio.firstIndex { $0.coinid == coinId} ?? 0
        cryptoPortfolio[idx].count = count
    }

    func updateFavs(_ coinId: String) {
        print(cryptoFavs)
        if cryptoFavs.contains(where: { $0.coinid == coinId }) {
            cryptoFavs.removeAll { $0.coinid == coinId}
        } else {
            cryptoFavs.append(CryptoServerModel(id: Int.random(in: 1...100000), coinid: coinId, count: 0.0))
        }
    }

    // MARK: - Stocks portfolio

    func updateStockWallet(_ symbolToSell: String, _ symbolToBuy: String, _ sellAmount: Double, _ buyAmount: Double) {
        var idx = 0
        idx = stockWallet.firstIndex { $0.stockSymbol == symbolToSell} ?? 0
        stockWallet[idx].count -= sellAmount
        idx = stockWallet.firstIndex { $0.stockSymbol == symbolToBuy} ?? 0
        stockWallet[idx].count += buyAmount
    }

    func updateStockPortfolio(_ symbol: String, _ count: Double, _ buytotal: Double) {
        var idx = 0
        idx = stockPortfolio.firstIndex { $0.stockSymbol == symbol} ?? 0
        stockPortfolio[idx].count = count
    }

    func updateStockFavs(_ symbol: String) {
        if stockFavs.contains(where: { $0.stockSymbol == symbol }) {
            stockFavs.removeAll { $0.stockSymbol == symbol }
        } else {
            stockFavs.append(StockServerModel(id: Int.random(in: 1...100000), stockSymbol: symbol, count: 0.0))
        }
    }

    func subscribe(_ subId: String) {
        if subscriptions.contains(subId) {
            subscriptions.removeAll { $0 == subId}
        } else {
            subscriptions.append(subId)
        }
    }

    func changeVisibility() {
        accountVisible.toggle()
    }
    func loadUsers() {
    }
    func loadUserActionLogs() {
    }
}
// swiftlint:enable all
