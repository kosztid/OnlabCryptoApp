import Foundation

class PortfolioAdderInteractor {
    let coin: CoinModel

    init(coin: CoinModel) {
        self.coin = coin
    }

    func coindata() -> CoinModel {
        return coin
    }

    func addCoin(count: Double) {
    }
}
