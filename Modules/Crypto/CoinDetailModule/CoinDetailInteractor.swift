import Foundation
import SwiftUI

class CoinDetailInteractor {
    private let coin: CoinModel
    private var userService: UserService

    init(coin: CoinModel, service: UserService) {
        self.coin = coin
        self.userService = service
    }

    func getValues() -> [CGFloat] {
        var newData: [CGFloat]
        let olddata = coin.sparklineIn7D?.price ?? []
        newData = olddata.map { CGFloat($0)}
        return newData
    }

    func getCoin() -> CoinModel {
        coin
    }

    func getSignInStatus() -> Published<Bool>.Publisher {
        userService.$isSignedIn
    }

    func getCoinCount() -> Double {
        if let index = userService.cryptoPortfolio.firstIndex(where: { $0.coinid == coin.id }) {
            return userService.cryptoPortfolio[index].count
        } else {
            return 0.0
        }
    }

    func isFav() -> Bool {
        userService.cryptoFavs.contains { $0.coinid == self.coin.id }
    }

    func addHolding(count: Double) {
        userService.updatePortfolio(coin.id, count, coin.currentPrice)
    }

    func addFavCoin() {
        userService.updateFavs(coin.id)
    }
}
