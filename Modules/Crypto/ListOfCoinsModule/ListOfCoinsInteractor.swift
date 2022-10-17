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
        CoinDetailInteractor(coin: coin, model: model, service: userService)
    }

    func getPublisher() -> Published<[CoinModel]>.Publisher {
        return coinService.$coins
    }

    func changeView() {
        model.currencyType = .stocks
    }
}
