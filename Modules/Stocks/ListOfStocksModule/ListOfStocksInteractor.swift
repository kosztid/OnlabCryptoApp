import Combine

class ListOfStocksInteractor {
    let stockService: StockService
    let userService: UserService

    init() {
        stockService = StockService()
        userService = UserService()
        userService.userReload("listofstocks")
    }

    func getSignInStatus() -> Published<Bool>.Publisher {
        return userService.$isSignedIn
    }

    func makeDetailInteractor(symbol: String, item: StockListItem) -> StockDetailInteractor {
        StockDetailInteractor(symbol: symbol, item: item, service: userService)
    }

    func getPublisher() -> Published<[StockListItem]>.Publisher {
        return stockService.$stocks
    }

    func reloadData() {
        userService.userReload("listofstocks")
    }

    func changeView() {
//     TODO:   model.currencyType = .crypto
    }
}
