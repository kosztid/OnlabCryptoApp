import Foundation
import Resolver

class ListOfCoinsInteractor {
    let coinService: CoinService
    let userService: UserService

    init() {
        coinService = CoinService()
        userService = Resolver.resolve()
        userService.userReload("listofcoins")
    }

    func setIsnotificationViewed() {
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

    func changeView() {
//       TODO: model.currencyType = .stocks
    }
}
