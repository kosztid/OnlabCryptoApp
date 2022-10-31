import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .listofcoins
    @Environment(\.scenePhase) var scenePhase
    var currencyType = CurrencyTypes.crypto

    init() {
        UITabBar.appearance().barTintColor = UIColor(Color.theme.backgroundcolor)
        UINavigationBar.appearance().barTintColor = UIColor(Color.theme.backgroundcolor)
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
                // CoinList view
                NavigationView {
                    ListOfStocksView(presenter: ListOfStocksPresenter(interactor: ListOfStocksInteractor()))
                }
                .navigationBarTitleDisplayMode(.inline)
                .ignoresSafeArea()
                .tabItem { Label("Stocks", systemImage: "list.bullet")
                }
                .tag(Tab.listofcoins)

                // Portfolio tab
                NavigationView {
                    VStack {
                        StockPortfolioView(presenter: StockPortfolioPresenter(interactor: StockPortfolioInteractor()))
                    }
                }
                .tabItem { Label("Portfolio", systemImage: "star") }
                .accessibilityIdentifier("PortfolioViewButton")
                .tag(Tab.portfolio)

                // swap tab
                NavigationView {
                    StockSwapView(presenter: StockSwapPresenter(interactor: StockSwapInteractor()))
                }
                .tabItem { Label("Swap", systemImage: "arrow.left.arrow.right") }
                .accessibilityIdentifier("SwapViewButton")
                .tag(Tab.swap)
                // News tab
                NavigationView {
                    NewsView(presenter: NewsPresenter(interactor: NewsInteractor(), newsType: .stock))
                }
                .navigationBarTitleDisplayMode(.inline)
                .tabItem { Label("News", systemImage: "newspaper") }
                .tag(Tab.news)

                // Communities tab
                NavigationView {
                    VStack(spacing: 10) {
                        CommunitiesView(presenter: CommunitiesPresenter(interactor: CommunitiesInteractor()))
                    }
                }
                .tabItem { Label("Communities", systemImage: "message") }
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
                NavigationView {
                    ListOfCoinsView(presenter: ListOfCoinsPresenter(interactor: ListOfCoinsInteractor()))
                }
                .navigationBarTitleDisplayMode(.inline)
                .ignoresSafeArea()
                .tabItem { Label("List", systemImage: "list.bullet")
                }
                .tag(Tab.listofcoins)

                // Portfolio tab
                NavigationView {
                    VStack(spacing: 10) {
                        PortfolioView(presenter: PortfolioPresenter(interactor: PortfolioInteractor()))
                    }
                }
                .tabItem { Label("Portfolio", systemImage: "star") }
                .accessibilityIdentifier("PortfolioViewButton")
                .tag(Tab.portfolio)

                // swap tab
                NavigationView {
                    VStack(spacing: 10) {
                        SwapView(presenter: SwapPresenter(interactor: SwapInteractor()))
                    }
                }
                .tabItem { Label("Swap", systemImage: "arrow.left.arrow.right") }
                .accessibilityIdentifier("SwapViewButton")
                .tag(Tab.swap)
                // News tab
                NavigationView {
                    NewsView(presenter: NewsPresenter(interactor: NewsInteractor(), newsType: .crypto))
                }
                .navigationBarTitleDisplayMode(.inline)
                .tabItem { Label("News", systemImage: "newspaper") }
                .tag(Tab.news)

                // Communities tab
                NavigationView {
                    VStack(spacing: 10) {
                        CommunitiesView(presenter: CommunitiesPresenter(interactor: CommunitiesInteractor()))
                    }
                }
                .tabItem { Label("Communities", systemImage: "message") }
                .tag(Tab.communities)
            }
        }
//        .onChange(of: scenePhase) { newPhase in
//            if newPhase == .active {
//                print("Active")
//                model.loadNotification()
//            } else if newPhase == .inactive {
//                print("inactive")
//            } else if newPhase == .background {
//                print("background")
//                model.saveNotification()
//                model.isNotificationViewed = false
//            }
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
    }
}
