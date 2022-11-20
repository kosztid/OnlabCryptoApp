import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .listofcoins
    @Environment(\.scenePhase) var scenePhase
    @State private var currencyType = CurrencyTypes.crypto

    init() {
        UITabBar.appearance().barTintColor = UIColor(Color.theme.backgroundcolor)
        UINavigationBar.appearance().barTintColor = UIColor(Color.theme.backgroundcolor)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accentcolor)]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accentcolor)]
    }

    var body: some View {
        if currencyType == .crypto {
            cryptoView
        } else {
            stocksView
        }
    }

    var stocksView: some View {
        ZStack {
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            // main view with tab selections
            TabView(selection: $selection) {
                stocksListView
                    .tabItem { Label {Text(Strings.list) } icon: {Image.bulletList} }
                .tag(Tab.listofcoins)

                // Portfolio tab
                stockPortfolioView
                    .tabItem { Label {Text(Strings.portfolio) } icon: {Image.star} }
                .accessibilityIdentifier("PortfolioViewButton")
                .tag(Tab.portfolio)

                // swap tab
                stockSwapView
                    .tabItem { Label {Text(Strings.swapTab) } icon: {Image.arrowLeftRight} }
                .accessibilityIdentifier("SwapViewButton")
                .tag(Tab.swap)
                // News tab
                stockNewsView
                    .tabItem { Label {Text(Strings.news) } icon: {Image.newspaper} }
                .tag(Tab.news)

                // Communities tab
                communitiesTab
                    .tabItem { Label {Text(Strings.communities) } icon: {Image.message} }
                .tag(Tab.communities)
            }
        }
    }

    var cryptoView: some View {
        ZStack {
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            // main view with tab selections
            TabView(selection: $selection) {
                // CoinList view
                cryptoListView
                    .tabItem { Label {Text(Strings.list) } icon: {Image.bulletList} }
                .tag(Tab.listofcoins)

                // Portfolio tab
                cryptoPortfolioView
                    .tabItem { Label {Text(Strings.portfolio) } icon: {Image.star} }
                .accessibilityIdentifier("PortfolioViewButton")
                .tag(Tab.portfolio)

                // swap tab
                cryptoSwapView
                    .tabItem { Label {Text(Strings.swapTab) } icon: {Image.arrowLeftRight} }
                .accessibilityIdentifier("SwapViewButton")
                .tag(Tab.swap)
                // News tab
                cryptoNewsView
                    .tabItem { Label {Text(Strings.news) } icon: {Image.newspaper} }
                .tag(Tab.news)

                // Communities tab
                communitiesTab
                    .tabItem { Label {Text(Strings.communities) } icon: {Image.message} }
                .tag(Tab.communities)
            }
        }
    }

    func changeBetweenCurrencyTypes() {
        if currencyType == .crypto {
            self.currencyType = .stocks
        } else {
            self.currencyType = .crypto
        }
    }
    // MARK: - View elements

    var cryptoListView: some View {
        NavigationView {
            ListOfCoinsView(presenter: ListOfCoinsPresenter(interactor: ListOfCoinsInteractor(changeBetweenCurrencyTypes)))
        }
        .ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)
    }

    var cryptoPortfolioView: some View {
        NavigationView {
            VStack(spacing: 10) {
                PortfolioView(presenter: PortfolioPresenter(interactor: PortfolioInteractor()))
            }
        }
    }

    var cryptoSwapView: some View {
        NavigationView {
            VStack(spacing: 10) {
                SwapView(presenter: SwapPresenter(interactor: SwapInteractor()))
            }
        }
    }

    var cryptoNewsView: some View {
        NavigationView {
            NewsView(presenter: NewsPresenter(interactor: NewsInteractor(), newsType: .crypto))
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    var communitiesTab: some View {
        NavigationView {
            VStack(spacing: 10) {
                CommunitiesView(presenter: CommunitiesPresenter(interactor: CommunitiesInteractor()))
            }
        }
    }
    var stocksListView: some View {
        NavigationView {
            ListOfStocksView(presenter: ListOfStocksPresenter(interactor: ListOfStocksInteractor(changeBetweenCurrencyTypes)))
        }
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea()
    }

    var stockPortfolioView: some View {
        NavigationView {
            VStack {
                StockPortfolioView(presenter: StockPortfolioPresenter(interactor: StockPortfolioInteractor()))
            }
        }
    }

    var stockSwapView: some View {
        NavigationView {
            StockSwapView(presenter: StockSwapPresenter(interactor: StockSwapInteractor()))
        }
    }

    var stockNewsView: some View {
        NavigationView {
            NewsView(presenter: NewsPresenter(interactor: NewsInteractor(), newsType: .stock))
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
    }
}
