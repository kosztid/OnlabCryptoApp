import Foundation
import Resolver

class ListOfCoinsInteractor {
    let coinService: CoinService
    let userService: UserService
    let changeView: () -> Void

    init(_ action: @escaping () -> Void = {}) {
        changeView = action
        coinService = CoinService()
        userService = Resolver.resolve()
        userService.userReload("listofcoins")
    }

    func makeDetailInteractor(coin: CoinModel) -> CoinDetailInteractor {
        CoinDetailInteractor(coin: coin, service: userService)
    }

    func getSignInStatus() -> Published<Bool>.Publisher {
        userService.$isSignedIn
    }

    func getPublisher() -> Published<[CoinModel]>.Publisher {
        coinService.$coins
    }

    func reloadData() {
        userService.userReload("listofcoins")
    }
}
