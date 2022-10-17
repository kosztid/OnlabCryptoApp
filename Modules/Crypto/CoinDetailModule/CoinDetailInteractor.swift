import Foundation
import SwiftUI

class CoinDetailInteractor {
    private let coin: CoinModel
    private let model: DataModel
    @ObservedObject private var userService: UserService

    init(coin: CoinModel, model: DataModel, service: UserService) {
        self.coin = coin
        self.model = model
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

    func getmodel() -> DataModel {
        return model
    }

    func getFavs() -> Published<[CryptoServerModel]>.Publisher {
        return userService.$cryptoFavs
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
    func addFavCoin() {
        userService.updateFavs(coin.id)
    }
    func isFav() -> Bool {
        return !(userService.cryptoFavs.filter({ $0.coinid == self.coin.id }).isEmpty)
    }
}
