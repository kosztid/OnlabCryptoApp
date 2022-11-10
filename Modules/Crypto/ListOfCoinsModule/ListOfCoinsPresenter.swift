import Combine
import Foundation
import SwiftUI

class ListOfCoinsPresenter: ObservableObject {
    @Published var coins: [CoinModel] = []
    private let interactor: ListOfCoinsInteractor
    @Published var signedin = false
    @Published var isNotificationViewed = false
    private var cancellables = Set<AnyCancellable>()
    private let router = ListOfCoinsRouter()

    init(interactor: ListOfCoinsInteractor) {
        self.interactor = interactor
        interactor.getPublisher()
            .assign(to: \.coins, on: self)
            .store(in: &cancellables)

        interactor.getSignInStatus()
            .assign(to: \.signedin, on: self)
            .store(in: &cancellables)
    }

    func reloadData() {
        interactor.reloadData()
    }

    func linkBuilder<Content: View>(
        for coin: CoinModel,
        @ViewBuilder content: () -> Content
    ) -> some View {
        NavigationLink(destination: router.makeCoinDetailView(interactor: interactor.makeDetailInteractor(coin: coin))) {
            }.buttonStyle(PlainButtonStyle())
            .opacity(0)
    }
    func makeButtonForLogin() -> some View {
        NavigationLink(Strings.account, destination: router.makeLoginView())
            .buttonStyle(UnifiedBorderedButtonStyle())
    }

    func makeButtonForAccount() -> some View {
        NavigationLink(Strings.account, destination: router.makeAccountView())
            .buttonStyle(UnifiedBorderedButtonStyle())
    }
    func makeButtonForViewchange() -> some View {
        Button {
            self.interactor.changeView()
        } label: {
            Image.dollarSignFill
                .foregroundColor(Color.theme.accentcolor)
                .font(.system(size: 20))
        }
    }
}
