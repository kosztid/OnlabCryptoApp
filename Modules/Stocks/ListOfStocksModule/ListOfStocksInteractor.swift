import Combine

class ListOfStocksInteractor {
    let model: DataModel
    let stockService: StockService
    let userService: UserService

    init(model: DataModel) {
        self.model = model
        stockService = StockService()
        userService = UserService()
        userService.userReload()
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
        userService.userReload()
    }

    func changeView() {
        model.currencyType = .crypto
    }
}
