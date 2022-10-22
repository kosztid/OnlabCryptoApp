import Foundation
import Combine
import SwiftUI

class ListOfStocksPresenter: ObservableObject {
    @Published var stocks: [StockListItem] = []
    private let interactor: ListOfStocksInteractor
    @Published var signedin = false
    @Published var isNotificationViewed = false
    private var cancellables = Set<AnyCancellable>()
    private let router = ListOfStocksRouter()

    init(interactor: ListOfStocksInteractor) {
        self.interactor = interactor
        interactor.model.$stocks
            .assign(to: \.stocks, on: self)
            .store(in: &cancellables)

        interactor.model.$isSignedIn
            .assign(to: \.signedin, on: self)
            .store(in: &cancellables)

        interactor.model.$isNotificationViewed
            .assign(to: \.isNotificationViewed, on: self)
            .store(in: &cancellables)

    }

    func linkBuilder<Content: View>(
        for stock: StockListItem,
        @ViewBuilder content: () -> Content
    ) -> some View {
        NavigationLink(destination: router.makeStockDetailView(stock: stock.symbol, model: interactor.model, item: stock)) {
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
