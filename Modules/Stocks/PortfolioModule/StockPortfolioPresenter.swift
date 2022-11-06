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
    }

    func makeButtonForAccount() -> some View {
        NavigationLink(Strings.account, destination: router.makeAccountView())
    }

    func changeViewTo(viewname: Folio) {
        selection = viewname
    }

    func makeButtonforPortfolioList() -> some View {
        Button {
            self.changeViewTo(viewname: .portfolio)
        } label: {
            Text(Strings.portfolio)
                .frame(height: 30)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.3)
                .font(.system(size: 20))
                .background(self.isSelected(selected: .portfolio) ? Color.theme.accentcolor : Color.theme.backgroundsecondary)
                .foregroundColor(self.isSelected(selected: .portfolio) ? Color.theme.backgroundsecondary : Color.theme.accentcolor)
                .cornerRadius(10)
        }
    }
    func makeButtonforFavfolioList() -> some View {
        Button {
            self.changeViewTo(viewname: .favorites)
        } label: {
            Text(Strings.favorites)
                .frame(height: 30)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.3)
                .font(.system(size: 20))
                .background(self.isSelected(selected: .favorites) ? Color.theme.accentcolor : Color.theme.backgroundsecondary)
                .foregroundColor(self.isSelected(selected: .favorites) ? Color.theme.backgroundsecondary : Color.theme.accentcolor)
                .cornerRadius(10)
        }
    }
    func makeButtonforWalletList() -> some View {
        Button {
            self.changeViewTo(viewname: .wallet)
        } label: {
            Text(Strings.wallet)
                .frame(height: 30)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.3)
                .font(.system(size: 20))
                .background(self.isSelected(selected: .wallet) ? Color.theme.accentcolor : Color.theme.backgroundsecondary)
                .foregroundColor(self.isSelected(selected: .wallet) ? Color.theme.backgroundsecondary : Color.theme.accentcolor)
                .cornerRadius(10)
        }
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
                            .font(.system(size: 18))
                        Spacer()
                        Text("\(self.portfoliototal().formatcurrency4digits())")
                            .font(.system(size: 18))
                            .frame(alignment: .leading)
                    }
                    HStack {
                        Text(Strings.portfolioInvested)
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
                            .font(.system(size: 20))
                        Spacer()
                    }
                    HStack {
                        Text(Strings.favoritesChange)
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
                            .font(.system(size: 18))
                        Spacer()
                        Text("\(self.interactor.wallettotal().formatcurrency4digits())")
                            .font(.system(size: 18))
                            .frame(alignment: .leading)
                    }
                    HStack {
                        Text(Strings.walletyesterday)
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
