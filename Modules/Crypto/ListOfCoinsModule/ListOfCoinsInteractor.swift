import Foundation

class ListOfCoinsInteractor {
    let model: DataModel
    let coinService: CoinService
    let userService: UserService

    init(model: DataModel) {
        self.model = model
        coinService = CoinService()
        userService = UserService()
        userService.userReload()
        print("interactor")
    }

    func setIsnotificationViewed() {
        model.isNotificationViewed = true
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
        userService.userReload()
    }

    func changeView() {
        model.currencyType = .stocks
    }
}
