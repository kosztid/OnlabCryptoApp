import Foundation
import SwiftUI

class ListOfCoinsRouter {
    func makeCoinDetailView(interactor: CoinDetailInteractor) -> some View {
        let presenter = CoinDetailPresenter(interactor: interactor)
        return CoinDetailView(presenter: presenter)
    }

    func makeAccountView(model: DataModel) -> some View {
        return AccountView(presenter: AccountPresenter(interactor: AccountInteractor(model: model)))
    }

    func makeLoginView(model: DataModel) -> some View {
        let presenter = LoginScreenPresenter(interactor: LoginScreenInteractor(model: model))
        return LoginScreenView(presenter: presenter)
    }

    func makePriceNotificationView(model: DataModel) -> some View {
        let presenter = PriceNotificationPresenter(interactor: PriceNotificationInteractor(model: model))
        return PriceNotificationView(presenter: presenter)
    }
}
