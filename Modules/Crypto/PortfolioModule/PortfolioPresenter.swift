import Combine
import Foundation
import SwiftUI

// swiftlint:disable:next type_body_length
class PortfolioPresenter: ObservableObject {
    @Published var selection = Folio.portfolio
    @Published var coins: [CoinModel] = []
    @Published var favcoins: [CryptoServerModel] = []
    @Published var signedin = false
    private let interactor: PortfolioInteractor
    private var cancellables = Set<AnyCancellable>()
    private let router = PortfolioRouter()

    init(interactor: PortfolioInteractor) {
        self.interactor = interactor

        interactor.getSignInStatus()
            .assign(to: \.signedin, on: self)
            .store(in: &cancellables)

        interactor.getFavs()
            .assign(to: \.favcoins, on: self)
            .store(in: &cancellables)

        interactor.getCoins()
            .assign(to: \.coins, on: self)
            .store(in: &cancellables)
    }

    func changeViewTo(viewname: Folio) {
        selection = viewname
    }

    func linkBuilder<Content: View>(
        for coin: CoinModel,
        @ViewBuilder content: () -> Content
    ) -> some View {
        NavigationLink(destination: router.makeCoinDetailView(interactor: interactor.makeDetailInteractor(coin: coin))) {
        }.buttonStyle(PlainButtonStyle())
            .opacity(0)
    }

    func heldcoins() -> [String] {
        interactor.heldcoins()
    }

    func heldfavcoins() -> [String] {
        interactor.heldfavcoins()
    }
    func ownedcoins() -> [String] {
        interactor.ownedcoins()
    }
    func isSelected(selected: Folio) -> Bool {
        selected == self.selection
    }

    func removeCoin(_ index: IndexSet) {
        interactor.removeCoin(index)
    }
    func winlosepercent() -> Double {
        (1 - (self.portfoliobuytotal() / self.portfoliototal())) * 100
    }

    func makeButtonForLogin() -> some View {
        NavigationLink(Strings.account, destination: router.makeLoginView())
            .buttonStyle(UnifiedBorderedButtonStyle())
    }

    func makeButtonForAccount() -> some View {
        NavigationLink(Strings.account, destination: router.makeAccountView())
            .buttonStyle(UnifiedBorderedButtonStyle())
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

    // swiftlint:disable:next function_body_length
    func makeList(selected: Folio) -> AnyView {
        if selected == .portfolio {
            return AnyView(
                List {
                    ForEach(self.coins) { coin in
                        if self.heldcoins().contains(coin.id) {
                            ZStack {
                                Color.theme.backgroundcolor
                                    .ignoresSafeArea()
                                PortfolioListItem(presenter: self, holding: self.interactor.getholdingcount(coin: coin), coin: coin)
                                    .frame(height: 80)
                                self.linkBuilder(for: coin) {
                                    EmptyView()
                                }.buttonStyle(PlainButtonStyle())
                            }
                            .frame(height: 60)
                        }
                    }
                    .onDelete(perform: self.removeCoin)
                    .listRowSeparatorTint(Color.theme.backgroundsecondary)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                }.accessibilityIdentifier("PortfolioList")
            )} else if selected == .favorites { return AnyView(
                List {
                    ForEach(self.coins) { coin in
                        if self.heldfavcoins().contains(coin.id) {
                            ZStack {
                                Color.theme.backgroundcolor
                                    .ignoresSafeArea()
//                                swiftlint:disable:next line_length
                                FavfolioListItemView(presenter: FavfolioListItemPresenter(interactor: FavfolioListItemInteractor(coin: coin, self.interactor.updateFav, self.interactor.isFav)))
                                    .frame(height: 80)
                                self.linkBuilder(for: coin) {
                                    EmptyView()
                                }.buttonStyle(PlainButtonStyle())
                            }
                            .frame(height: 60)
                        }
                    }
                    // .onDelete(perform: self.removeCoin)
                    .listRowSeparatorTint(Color.theme.backgroundsecondary)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                })} else {
                    return AnyView(
                        List {
                            ForEach(self.coins) { coin in
                                if self.ownedcoins().contains(coin.id) {
                                    ZStack {
                                        Color.theme.backgroundcolor
                                            .ignoresSafeArea()
                                        PortfolioListItem(presenter: self, holding: self.interactor.getownedcount(coin: coin), coin: coin)
                                            .frame(height: 80)
                                        self.linkBuilder(for: coin) {
                                            EmptyView()
                                        }.buttonStyle(PlainButtonStyle())
                                    }
                                    .frame(height: 60)
                                }
                            }
                            .listRowSeparatorTint(Color.theme.backgroundsecondary)
                            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        })}
    }

    func makeFolioData(selected: Folio) -> AnyView {
        if selected == Folio.portfolio {
            return AnyView(
                self.makeportfolioData()
            )} else if selected == Folio.favorites { return AnyView(
                self.makefavfolioData()
            )} else {
                return AnyView(
                    self.makewalletData()
                )}
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
                }.frame(width: UIScreen.main.bounds.width * 0.75)
                Spacer()
                Text("\((self.interactor.wallettotal() / self.interactor.walletyesterday()).formatpercent())")
                    .foregroundColor(((self.interactor.wallettotal() / self.interactor.walletyesterday()) >= 0) ? Color.theme.green : Color.theme.red )
                    .frame(alignment: .leading)
                Spacer()
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.03)
    }

    func makeButtonforWalletList() -> some View {
        Button {
            self.changeViewTo(viewname: .wallet)
        } label: {
            Text(Strings.wallet)
        }
        .buttonStyle(UnifiedSelectorBorderedButtonStyle(isSelected: self.isSelected(selected: .wallet), buttonCount: 3.0, height: 30.0, fontSize: 20))
    }
}
