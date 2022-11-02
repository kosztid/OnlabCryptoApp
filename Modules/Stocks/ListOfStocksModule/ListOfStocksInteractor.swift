import Combine
import Resolver

class ListOfStocksInteractor {
    let stockService: StockService
    let userService: UserService
    let changeView: () -> Void

    init(_ action: @escaping () -> Void = {}) {
        changeView = action
        stockService = StockService()
        userService = Resolver.resolve()
        userService.userReload("listofstocks")
    }

    func getSignInStatus() -> Published<Bool>.Publisher {
        userService.$isSignedIn
    }

    func makeDetailInteractor(symbol: String, item: StockListItem) -> StockDetailInteractor {
        StockDetailInteractor(symbol: symbol, item: item, service: userService)
    }

    func getPublisher() -> Published<[StockListItem]>.Publisher {
        stockService.$stocks
    }

    func reloadData() {
        userService.userReload("listofstocks")
    }
}
