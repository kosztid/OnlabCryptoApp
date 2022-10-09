import Foundation

class PortfolioAdderPresenter: ObservableObject {
    private let interactor: PortfolioAdderInteractor

    init(interactor: PortfolioAdderInteractor) {
        self.interactor = interactor
    }

    func coindata() -> CoinModel {
        return interactor.coindata()
    }
    func addCoin(count: Double) {
        interactor.addCoin(count: count)
    }
}
