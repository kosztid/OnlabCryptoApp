import Foundation
import SwiftUI

class ListOfCoinsRouter {
    func makeCoinDetailView(interactor: CoinDetailInteractor) -> some View {
        let presenter = CoinDetailPresenter(interactor: interactor)
        return CoinDetailView(presenter: presenter)
    }

    func makeAccountView() -> some View {
        return AccountView(presenter: AccountPresenter(interactor: AccountInteractor()))
    }

    func makeLoginView() -> some View {
        let presenter = LoginScreenPresenter(interactor: LoginScreenInteractor())
        return LoginScreenView(presenter: presenter)
    }

    func makePriceNotificationView(model: DataModel) -> some View {
        let presenter = PriceNotificationPresenter(interactor: PriceNotificationInteractor(model: model))
        return PriceNotificationView(presenter: presenter)
    }
}
