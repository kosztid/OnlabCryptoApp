import Foundation
import SwiftUI
import Combine

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
        NavigationLink("Account", destination: router.makeLoginView())
    }

    func makeButtonForAccount() -> some View {
        NavigationLink("Account", destination: router.makeAccountView())
    }
//    func makeButtonForPriceNotification() -> some View {
//        NavigationLink(destination: router.makePriceNotificationView(model: interactor.model)) {
//            Image(systemName: isNotificationViewed ? "bell.fill" : "bell.badge.fill")
//                .font(.system(size: 20))
//            }
//        .onAppear {self.interactor.setIsnotificationViewed()}
//        .foregroundColor(isNotificationViewed ? Color.theme.accentcolor : Color.theme.red)
//    }
    func makeButtonForViewchange() -> some View {
        Button {
            self.interactor.changeView()
        } label: {
            Image(systemName: "dollarsign.circle.fill")
                .font(.system(size: 20))
        }
    }
    func setIsnotificationViewed() {
        interactor.setIsnotificationViewed()
    }
}
