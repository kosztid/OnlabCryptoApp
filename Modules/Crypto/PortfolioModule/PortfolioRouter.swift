import Foundation
import SwiftUI

class PortfolioRouter {
    func makeCoinDetailView(interactor: CoinDetailInteractor) -> some View {
        let presenter = CoinDetailPresenter(interactor: interactor)
        return CoinDetailView(presenter: presenter)
    }

    func makeAccountView() -> some View {
        AccountView(presenter: AccountPresenter(interactor: AccountInteractor()))
    }

    func makeLoginView() -> some View {
        let presenter = LoginScreenPresenter(interactor: LoginScreenInteractor())
        return LoginScreenView(presenter: presenter)
    }
}
