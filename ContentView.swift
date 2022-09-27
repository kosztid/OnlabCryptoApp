//
//  ContentView.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 25..
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .listofcoins
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var model: DataModel
    init() {
        UITabBar.appearance().barTintColor = UIColor(Color.theme.backgroundcolor)
        UINavigationBar.appearance().barTintColor = UIColor(Color.theme.backgroundcolor)
    }
    enum Tab {
        case listofcoins
        case communities
        case swap
        case portfolio
        case news
        
    }
    
    var body: some View {
        if model.currencyType == .crypto {
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
                    List {
                        Text("APPLE")
                        Text("TSLA")
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                model.currencyType = .crypto
                            } label: {
                                Image(systemName: "dollarsign.circle.fill")
                                    .font(.system(size: 20))
                            }
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .ignoresSafeArea()
                .tabItem { Label("Stocks", systemImage: "list.bullet")
                }
                .tag(Tab.listofcoins)

                // Portfolio tab
                NavigationView {
                    Text("StockPortfolio")
                }
                .tabItem { Label("Portfolio", systemImage: "star") }
                .accessibilityIdentifier("PortfolioViewButton")
                .tag(Tab.portfolio)

                // swap tab
                NavigationView {
                    Text("StockSwap")
                }
                .tabItem { Label("Swap", systemImage: "arrow.left.arrow.right") }
                .accessibilityIdentifier("SwapViewButton")
                .tag(Tab.swap)
                // News tab
                NavigationView {
                    NewsView(presenter: NewsPresenter(interactor: NewsInteractor(model: model)))
                }
                .navigationBarTitleDisplayMode(.inline)
                .tabItem { Label("News", systemImage: "newspaper") }
                .tag(Tab.news)

                // Communities tab
                NavigationView {
                    VStack(spacing: 10) {
                        CommunitiesView(presenter: CommunitiesPresenter(interactor: CommunitiesInteractor(model: model)))
                    }
                }
                .tabItem { Label("Chat", systemImage: "message") }
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
                    ListOfCoinsView(presenter: ListOfCoinsPresenter(interactor: ListOfCoinsInteractor(model: model)))
                }
                .navigationBarTitleDisplayMode(.inline)
                .ignoresSafeArea()
                .tabItem { Label("List", systemImage: "list.bullet")
                }
                .tag(Tab.listofcoins)

                // Portfolio tab
                NavigationView {
                    VStack(spacing: 10) {
                        PortfolioView(presenter: PortfolioPresenter(interactor: PortfolioInteractor(model: model)))
                    }
                }
                .tabItem { Label("Portfolio", systemImage: "star") }
                .accessibilityIdentifier("PortfolioViewButton")
                .tag(Tab.portfolio)

                // swap tab
                NavigationView {
                    VStack(spacing: 10) {
                        SwapView(presenter: SwapPresenter(interactor: SwapInteractor(model: model)))
                    }
                }
                .tabItem { Label("Swap", systemImage: "arrow.left.arrow.right") }
                .accessibilityIdentifier("SwapViewButton")
                .tag(Tab.swap)
                // News tab
                NavigationView {
                    NewsView(presenter: NewsPresenter(interactor: NewsInteractor(model: model)))
                }
                .navigationBarTitleDisplayMode(.inline)
                .tabItem { Label("News", systemImage: "newspaper") }
                .tag(Tab.news)

                // Communities tab
                NavigationView {
                    VStack(spacing: 10) {
                        CommunitiesView(presenter: CommunitiesPresenter(interactor: CommunitiesInteractor(model: model)))
                    }
                }
                .tabItem { Label("Chat", systemImage: "message") }
                .tag(Tab.communities)
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                print("Active")
                model.loadNotification()
            } else if newPhase == .inactive {
                print("inactive")
            } else if newPhase == .background {
                print("background")
                model.saveNotification()
                model.isNotificationViewed = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DataModel())
            .preferredColorScheme(.light)
    }
}
