import Foundation
import SwiftUI
import Combine

class StockPortfolioPresenter: ObservableObject {
    @Published var selection: String = "wallet"
    private let interactor: StockPortfolioInteractor
    @Published var signedin = false
    @Published var favStocks: [StockServerModel] = []
    @Published var heldStocks: [StockServerModel] = []
    @Published var ownedStocks: [StockServerModel] = []
    private let router = StockPortfolioRouter()
    private var cancellables = Set<AnyCancellable>()

    init(interactor: StockPortfolioInteractor) {
        self.interactor = interactor

        interactor.model.$isSignedIn
            .assign(to: \.signedin, on: self)
            .store(in: &cancellables)

        interactor.model.$selection
            .assign(to: \.selection, on: self)
            .store(in: &cancellables)

        interactor.model.$favStocks
            .assign(to: \.favStocks, on: self)
            .store(in: &cancellables)

        interactor.model.$heldStocks
            .assign(to: \.heldStocks, on: self)
            .store(in: &cancellables)

        interactor.model.$ownedStocks
            .assign(to: \.ownedStocks, on: self)
            .store(in: &cancellables)
    }

    func isSelected(selected: String) -> Bool {
        return selected == self.selection
    }

    func portfoliototal() -> Double {
        return interactor.portfoliototal()
    }

    func portfoliobuytotal() -> Double {
        return interactor.portfoliobuytotal()
    }
    func favfoliochange() -> Double {
        return interactor.favfoliochange()
    }

    func makeList(selected: String) -> AnyView {
        if selected == "portfolio" {
            return AnyView(
                List {
                    ForEach(heldStocks) { stock in
                        StockPortfolioListItem(stock: stock, stockData: self.interactor.getStock(symbol: stock.stockSymbol), count: stock.count)
                    }
                    .listRowSeparatorTint(Color.theme.backgroundsecondary)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            )} else if selected == "favfolio" { return AnyView(
                List {
                    ForEach(favStocks) { stock in
                        StockFavListItem(stock: stock, stockData: self.interactor.getStock(symbol: stock.stockSymbol), setFav: self.interactor.setFav)
                    }
                    .listRowSeparatorTint(Color.theme.backgroundsecondary)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            )} else {
                return AnyView(
                    List {
                        ForEach(ownedStocks) { stock in
                            StockPortfolioListItem(stock: stock, stockData: self.interactor.getStock(symbol: stock.stockSymbol), count: stock.count)
                        }
                        .listRowSeparatorTint(Color.theme.backgroundsecondary)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                )}
    }

    func makeButtonForLogin() -> some View {
        NavigationLink("Account", destination: router.makeLoginView())
    }

    func makeButtonForAccount() -> some View {
        NavigationLink("Account", destination: router.makeAccountView())
    }

    func changeViewTo(viewname: String) {
        interactor.changeViewTo(viewname: viewname)
    }

    func makeButtonforPortfolioList() -> some View {
        Button {
            self.changeViewTo(viewname: "portfolio")
        } label: {
            Text("Portfolio")
                .frame(height: 30)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.3)
                .font(.system(size: 20))
                .background(self.isSelected(selected: "portfolio") ? Color.theme.accentcolor : Color.theme.backgroundsecondary)
                .foregroundColor(self.isSelected(selected: "portfolio") ? Color.theme.backgroundsecondary : Color.theme.accentcolor)
                .cornerRadius(10)
        }
    }
    func makeButtonforFavfolioList() -> some View {
        Button {
            self.changeViewTo(viewname: "favfolio")
        } label: {
            Text("Favorites")
                .frame(height: 30)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.3)
                .font(.system(size: 20))
                .background(self.isSelected(selected: "favfolio") ? Color.theme.accentcolor : Color.theme.backgroundsecondary)
                .foregroundColor(self.isSelected(selected: "favfolio") ? Color.theme.backgroundsecondary : Color.theme.accentcolor)
                .cornerRadius(10)
        }
    }
    func makeButtonforWalletList() -> some View {
        Button {
            self.changeViewTo(viewname: "wallet")
        } label: {
            Text("Wallet")
                .frame(height: 30)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.3)
                .font(.system(size: 20))
                .background(self.isSelected(selected: "wallet") ? Color.theme.accentcolor : Color.theme.backgroundsecondary)
                .foregroundColor(self.isSelected(selected: "wallet") ? Color.theme.backgroundsecondary : Color.theme.accentcolor)
                .cornerRadius(10)
        }
    }

    func makeFolioData(selected: String) -> AnyView {
        if selected == "portfolio" {
            return AnyView(
                Text("Portfolio")
            )
        } else if selected == "favfolio" {
            return AnyView(
                Text("Favorites")
            )
        } else {
            return AnyView(
                Text("Wallet")
            )
        }
    }
}
