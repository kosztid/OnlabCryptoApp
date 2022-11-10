import Combine
import Foundation
import SwiftUI

class ListOfStocksPresenter: ObservableObject {
    @Published var stocks: [StockListItem] = []
    private let interactor: ListOfStocksInteractor
    @Published var signedin = false
    private var cancellables = Set<AnyCancellable>()
    private let router = ListOfStocksRouter()

    init(interactor: ListOfStocksInteractor) {
        self.interactor = interactor
        interactor.getPublisher()
            .assign(to: \.stocks, on: self)
            .store(in: &cancellables)

        interactor.getSignInStatus()
            .assign(to: \.signedin, on: self)
            .store(in: &cancellables)
    }

    func reloadData() {
        interactor.reloadData()
    }

    func linkBuilder<Content: View>(
        for stock: StockListItem,
        @ViewBuilder content: () -> Content
    ) -> some View {
        NavigationLink(destination: router.makeStockDetailView(interactor: interactor.makeDetailInteractor(symbol: stock.symbol, item: stock))) {
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
            Image.bitcoinSignFill
                .foregroundColor(Color.theme.accentcolor)
                .font(.system(size: 20))
        }
    }
}
