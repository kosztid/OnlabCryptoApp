import Foundation

class ListOfCoinsInteractor {
    let coinService: CoinService
    let userService: UserService

    init() {
        coinService = CoinService()
        userService = UserService()
        userService.userReload("listofcoins")
        print("interactor")
    }

    func setIsnotificationViewed() {
    }

    func makeDetailInteractor(coin: CoinModel) -> CoinDetailInteractor {
        CoinDetailInteractor(coin: coin, service: userService)
    }

    func getSignInStatus() -> Published<Bool>.Publisher {
        return userService.$isSignedIn
    }

    func getPublisher() -> Published<[CoinModel]>.Publisher {
        return coinService.$coins
    }

    func reloadData() {
        userService.userReload("listofcoins")
    }

    func changeView() {
//       TODO: model.currencyType = .stocks
    }
}
