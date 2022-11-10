import Combine
import Foundation
import SwiftUI

class StockPortfolioPresenter: ObservableObject {
    @Published var selection = Folio.portfolio
    private let interactor: StockPortfolioInteractor
    @Published var signedin = false
    @Published var favStocks: [StockServerModel] = []
    @Published var heldStocks: [StockServerModel] = []
    @Published var ownedStocks: [StockServerModel] = []
    private let router = StockPortfolioRouter()
    private var cancellables = Set<AnyCancellable>()

    init(interactor: StockPortfolioInteractor) {
        self.interactor = interactor

        interactor.getSignInStatus()
            .assign(to: \.signedin, on: self)
            .store(in: &cancellables)

        interactor.getFavs()
            .assign(to: \.favStocks, on: self)
            .store(in: &cancellables)

        interactor.getHeld()
            .assign(to: \.heldStocks, on: self)
            .store(in: &cancellables)

        interactor.getOwned()
            .assign(to: \.ownedStocks, on: self)
            .store(in: &cancellables)
    }

    func isSelected(selected: Folio) -> Bool {
        selected == self.selection
    }

    func portfoliototal() -> Double {
        interactor.portfoliototal()
    }

    func portfoliobuytotal() -> Double {
        interactor.portfoliobuytotal()
    }
    func favfoliochange() -> Double {
        interactor.favfoliochange()
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

    func makeList(selected: Folio) -> AnyView {
        if selected == .portfolio {
            return AnyView(
                List {
                    ForEach(heldStocks) { stock in
                        StockPortfolioListItem(stock: stock, stockData: self.interactor.getStock(symbol: stock.stockSymbol), count: stock.count)
                    }
                    .listRowSeparatorTint(Color.theme.backgroundsecondary)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            )} else if selected == .favorites { return AnyView(
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
        NavigationLink(Strings.account, destination: router.makeLoginView())
            .buttonStyle(UnifiedBorderedButtonStyle())
    }

    func makeButtonForAccount() -> some View {
        NavigationLink(Strings.account, destination: router.makeAccountView())
            .buttonStyle(UnifiedBorderedButtonStyle())
    }

    func changeViewTo(viewname: Folio) {
        selection = viewname
    }

    func makeButtonforPortfolioList() -> some View {
        Button {
            self.changeViewTo(viewname: .portfolio)
        } label: {
            Text(Strings.portfolio)
        }
        .buttonStyle(UnifiedSelectorBorderedButtonStyle(isSelected: self.isSelected(selected: .portfolio), buttonCount: 3.0, height: 30.0, fontSize: 20))
    }
    func makeButtonforFavfolioList() -> some View {
        Button {
            self.changeViewTo(viewname: .favorites)
        } label: {
            Text(Strings.favorites)
        }
        .buttonStyle(UnifiedSelectorBorderedButtonStyle(isSelected: self.isSelected(selected: .favorites), buttonCount: 3.0, height: 30.0, fontSize: 20))
    }
    func makeButtonforWalletList() -> some View {
        Button {
            self.changeViewTo(viewname: .wallet)
        } label: {
            Text(Strings.wallet)
        }
        .buttonStyle(UnifiedSelectorBorderedButtonStyle(isSelected: self.isSelected(selected: .wallet), buttonCount: 3.0, height: 30.0, fontSize: 20))
    }

    func makeFolioData(selected: Folio) -> AnyView {
        if selected == .portfolio {
            return AnyView(
                self.makeportfolioData()
            )
        } else if selected == .favorites {
            return AnyView(
                self.makefavfolioData()
            )
        } else {
            return AnyView(
                self.makewalletData()
            )
        }
    }

    func makeportfolioData()-> some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(Strings.portfolioTotal)
                            .foregroundColor(Color.theme.accentcolor)
                            .font(.system(size: 18))
                        Spacer()
                        Text("\(self.portfoliototal().formatcurrency4digits())")
                            .foregroundColor(Color.theme.accentcolor)
                            .font(.system(size: 18))
                            .frame(alignment: .leading)
                    }
                    HStack {
                        Text(Strings.portfolioInvested)
                            .foregroundColor(Color.theme.accentcolor)
                            .font(.system(size: 16))
                        Spacer()
                        Text("\(self.portfoliobuytotal().formatcurrency4digits())")
                            .foregroundColor(Color.theme.accentcolorsecondary)
                            .font(.system(size: 16))
                            .frame(alignment: .leading)
                    }
                }.frame(width: UIScreen.main.bounds.width * 0.7)
                Spacer()
                Text("\(self.winlosepercent().formatpercent())")
                    .foregroundColor((self.winlosepercent() >= 0) ? Color.theme.green : Color.theme.red )
                    .frame(alignment: .leading)
                Spacer()
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.03)
    }

    func winlosepercent() -> Double {
        (1 - (self.portfoliobuytotal() / self.portfoliototal())) * 100
    }

    func makefavfolioData() -> some View {
        VStack(alignment: .leading) {
            HStack {
                VStack {
                    HStack {
                        Text(Strings.favoritesTotal)
                            .foregroundColor(Color.theme.accentcolor)
                            .font(.system(size: 20))
                        Spacer()
                    }
                    HStack {
                        Text(Strings.favoritesChange)
                            .foregroundColor(Color.theme.accentcolor)
                            .font(.system(size: 18))
                        Spacer()
                    }
                }
                Spacer()
                Text("\(self.favfoliochange().formatpercent())")
                    .foregroundColor((self.favfoliochange() >= 0) ? Color.theme.green : Color.theme.red )
                    .font(.system(size: 20))
                    .frame(alignment: .leading)
                Spacer()
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.03)
    }

    func makewalletData()-> some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(Strings.walletTotal)
                            .foregroundColor(Color.theme.accentcolor)
                            .font(.system(size: 18))
                        Spacer()
                        Text("\(self.interactor.wallettotal().formatcurrency4digits())")
                            .foregroundColor(Color.theme.accentcolor)
                            .font(.system(size: 18))
                            .frame(alignment: .leading)
                    }
                    HStack {
                        Text(Strings.walletyesterday)
                            .foregroundColor(Color.theme.accentcolor)
                            .font(.system(size: 16))
                        Spacer()
                        Text("\(self.interactor.walletyesterday().formatcurrency4digits())")
                            .foregroundColor(Color.theme.accentcolorsecondary)
                            .font(.system(size: 16))
                            .frame(alignment: .leading)
                    }
                }.frame(width: UIScreen.main.bounds.width * 0.7)
                Spacer()
                Text("\((self.interactor.wallettotal() / self.interactor.walletyesterday()).formatpercent())")
                    .foregroundColor(((self.interactor.wallettotal() / self.interactor.walletyesterday()) >= 0) ? Color.theme.green : Color.theme.red )
                    .frame(alignment: .leading)
                Spacer()
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.03)
    }
}
