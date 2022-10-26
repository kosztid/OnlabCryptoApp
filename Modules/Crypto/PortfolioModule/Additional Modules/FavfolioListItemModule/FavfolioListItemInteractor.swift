import Foundation

class FavfolioListItemInteractor {
    private let coin: CoinModel
    let updateFav: (String) -> Void
    let isFavorite: (String) -> Bool

    init(coin: CoinModel, _ updateFav : @escaping (String) -> Void = { _ in }, _ isFavorite : @escaping (String) -> Bool = { _ in return true }) {
        self.coin = coin
        self.updateFav = updateFav
        self.isFavorite = isFavorite
    }

    func addFavCoin() {
        updateFav(coin.id)
    }
    func getcoin() -> CoinModel {
        return coin
    }

    func isFav() -> Bool {
        return isFavorite(coin.id)
    }
}
