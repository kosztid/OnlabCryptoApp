//
//  ContentView.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 25..
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .listofcoins
    @EnvironmentObject var model: DataModel
    init() {
        UITabBar.appearance().barTintColor = UIColor(Color.theme.backgroundcolor)
        UINavigationBar.appearance().barTintColor = UIColor(Color.theme.backgroundcolor)
       }
    
    enum Tab{
        case listofcoins
        case communities
        case swap
        case portfolio
        case news
        
    }
    
    var body: some View {
        ZStack{
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            //main view with tab selections
            TabView(selection: $selection){
                //CoinList view
                NavigationView{
                    VStack{
                        ListOfCoinsView(presenter: ListOfCoinsPresenter(interactor: ListOfCoinsInteractor(model: model)))
                    }
                }
                .navigationBarHidden(true)
                .ignoresSafeArea()
                    .tabItem { Label("List", systemImage: "list.bullet")
                    }
                    .tag(Tab.listofcoins)
                
                //Portfolio tab
                NavigationView {
                    VStack(spacing: 10) {
                        PortfolioView(presenter: PortfolioPresenter(interactor: PortfolioInteractor(model: model)))
                    }
                }
                    .tabItem { Label("Portfolio", systemImage: "list.bullet") }
                    .accessibility(identifier: "PortfolioViewButton")
                    .tag(Tab.portfolio)
                
                //swap tab
                NavigationView {
                    VStack(spacing: 10) {
                        SwapView(presenter: SwapPresenter(interactor: SwapInteractor(model: model)))
                    }
                }
                    .tabItem { Label("Swap", systemImage: "list.bullet") }
                    .accessibility(identifier: "SwapViewButton")
                    .tag(Tab.swap)
                
                //News tab
                NavigationView {
                    VStack(spacing: 10) {
                        NewsView(presenter: NewsPresenter(interactor: NewsInteractor(model: model)))
                    }
                }
                    .tabItem { Label("News", systemImage: "list.bullet") }
                    .tag(Tab.news)
                
                //Communities tab
                NavigationView {
                    VStack(spacing: 10) {
                        CommunitiesView(presenter: CommunitiesPresenter(interactor: CommunitiesInteractor(model: model)))
                    }
                }
                    .tabItem { Label("Chat", systemImage: "list.bullet") }
                    .tag(Tab.communities)
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
