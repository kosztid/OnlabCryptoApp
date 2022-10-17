import Foundation

class FavfolioListItemInteractor {
    private let coin: CoinModel
    private let userService: UserService

    init(coin: CoinModel, service: UserService) {
        self.coin = coin
        self.userService = service
    }

    func addFavCoin() {
        userService.updateFavs(coin.id)
    }
    
    func getcoin() -> CoinModel {
        return coin
    }

    func isFav() -> Bool {
        return !(userService.cryptoFavs.filter({ $0.coinid == self.coin.id }).isEmpty)
    }
}
