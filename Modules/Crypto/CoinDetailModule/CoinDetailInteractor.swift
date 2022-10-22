import Foundation
import SwiftUI

class CoinDetailInteractor {
    private let coin: CoinModel
    private var userService: UserService

    init(coin: CoinModel, service: UserService) {
        self.coin = coin
        self.userService = service
    }

    func getvalues() -> [CGFloat] {
        var newData: [CGFloat]
        let olddata = coin.sparklineIn7D?.price ?? []
        newData = olddata.map { CGFloat($0)}
        return newData
    }
    func getcoin() -> CoinModel {
        return coin
    }

    func getFavs() -> Published<[CryptoServerModel]>.Publisher {
        return userService.$cryptoFavs
    }

    func getSignInStatus() -> Published<Bool>.Publisher {
        return userService.$isSignedIn
    }

    func held() -> Bool {
        return !(userService.cryptoPortfolio.filter({ $0.coinid == self.coin.id }).isEmpty)
    }

    func getCoinCount() -> Double {
        if let index = userService.cryptoPortfolio.firstIndex(where: { $0.coinid == coin.id }) {
            return userService.cryptoPortfolio[index].count
        } else {
            return 0.0
        }
    }
    func addHolding(count: Double) {
        userService.updatePortfolio(coin.id, count, coin.currentPrice)
    }
    func addFavCoin() {
        userService.updateFavs(coin.id)
    }
    func isFav() -> Bool {
        return !(userService.cryptoFavs.filter({ $0.coinid == self.coin.id }).isEmpty)
    }
}
