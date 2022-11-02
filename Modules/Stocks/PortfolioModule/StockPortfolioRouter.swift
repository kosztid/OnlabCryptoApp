import Foundation
import SwiftUI

class StockPortfolioRouter {
    func makeStockDetailView(interactor: StockDetailInteractor) -> some View {
        let presenter = StockDetailPresenter(interactor: interactor)
        return StockDetailView(presenter: presenter)
    }

    func makeAccountView() -> some View {
        AccountView(presenter: AccountPresenter(interactor: AccountInteractor()))
    }

    func makeLoginView() -> some View {
        let presenter = LoginScreenPresenter(interactor: LoginScreenInteractor())
        return LoginScreenView(presenter: presenter)
    }
}
