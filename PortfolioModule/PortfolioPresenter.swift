//
//  PortfolioPresenter.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 25..
//
import Combine
import Foundation
import SwiftUI

class PortfolioPresenter: ObservableObject{
    @Published var selection: String = "wallet"
    @Published var coins: [CoinModel] = []
    @Published var favcoins: [CoinDataFirebase] = []
    @Published var signedin : Bool = false
    private let interactor: PortfolioInteractor
    private var cancellables = Set<AnyCancellable>()
    private let router = PortfolioRouter()
    
    init(interactor: PortfolioInteractor){
        self.interactor = interactor
        
        interactor.model.$selection
            .assign(to: \.selection, on: self)
            .store(in: &cancellables)
        
        interactor.model.$isSignedIn
            .assign(to: \.signedin, on: self)
            .store(in: &cancellables)
        
        interactor.model.$coins
            .assign(to: \.coins, on: self)
            .store(in: &cancellables)
        
        interactor.model.$favcoins
            .assign(to: \.favcoins, on: self)
            .store(in: &cancellables)
    }
    
    func changeViewTo(viewname: String){
        interactor.changeViewTo(viewname: viewname)
    }
    
    func linkBuilder<Content: View>(
        for coin: CoinModel,
        @ViewBuilder content: () -> Content
    ) -> some View{
        NavigationLink(destination:router.makeCoinDetailView(coin: coin,model: interactor.model)){
            }.buttonStyle(PlainButtonStyle())
            .opacity(0)
    }
    
    func heldcoins() -> [String] {
        return interactor.heldcoins()
    }
    
    func heldfavcoins() -> [String] {
        return interactor.heldfavcoins()
    }
    func ownedcoins() -> [String] {
        return interactor.ownedcoins()
    }
    func isSelected(selected: String) -> Bool {
        return selected == self.selection
    }
    
    func removeCoin(_ index: IndexSet){
        interactor.removeCoin(index)
    }
    /*
    func getholdingcount(coin: CoinModel) -> Double {
        return interactor.getholdingcount(coin: coin)
    }
    */
    func winlosepercent()->Double{
            return (1-(self.portfoliobuytotal()/self.portfoliototal()))*100
    }
    
    
    
    func makeButtonForLogin() -> some View {
        NavigationLink("Account", destination: router.makeLoginView(model: interactor.model))
    }
    
    func makeButtonForAccount() -> some View {
        NavigationLink("Account", destination: router.makeAccountView(model: interactor.model))
    }
    
    func portfoliototal()-> Double{
        return interactor.portfoliototal()
    }
    
    func portfoliobuytotal()->Double{
        return interactor.portfoliobuytotal()
    }
    func favfoliochange()->Double{
        return interactor.favfoliochange()
    }
    func makeList(selected: String) -> AnyView{
        if selected == "portfolio" {
        return AnyView(
        List{
            ForEach(self.coins){ coin in
                if self.heldcoins().contains(coin.id) {
                    ZStack{
                        Color.theme.backgroundcolor
                                .ignoresSafeArea()
                            
                        PortfolioListItem(presenter: self,holding: self.interactor.getholdingcount(coin: coin), coin: coin)
                            .frame(height: 80)
                        self.linkBuilder(for: coin){
                            EmptyView()
                        }.buttonStyle(PlainButtonStyle())
                    }
                    .frame(height: 60)
                }
                
            }
            .onDelete(perform: self.removeCoin)
            .listRowSeparatorTint(Color.theme.backgroundsecondary)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        }.accessibility(identifier: "PortfolioList")
        )}
        else if selected == "favfolio" { return AnyView(
            List{
                ForEach(self.coins){ coin in
                    if self.heldfavcoins().contains(coin.id) {
                        ZStack{
                            Color.theme.backgroundcolor
                                    .ignoresSafeArea()
                                
                            FavfolioListItemView(presenter: FavfolioListItemPresenter(interactor: FavfolioListItemInteractor(coin: coin,model: self.interactor.getmodel())))
                                .frame(height: 80)
                            self.linkBuilder(for: coin){
                                EmptyView()
                            }.buttonStyle(PlainButtonStyle())
                        }
                        .frame(height: 60)
                    }
                    
                }
                //.onDelete(perform: self.removeCoin)
                .listRowSeparatorTint(Color.theme.backgroundsecondary)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            })} else {
                return AnyView(
                List{
                    ForEach(self.coins){ coin in
                        if self.ownedcoins().contains(coin.id) {
                            ZStack{
                                Color.theme.backgroundcolor
                                        .ignoresSafeArea()
                                    
                                PortfolioListItem(presenter: self,holding: self.interactor.getownedcount(coin: coin), coin: coin)
                                    .frame(height: 80)
                                self.linkBuilder(for: coin){
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
    
    func makeFolioData(selected: String) -> AnyView{
        if selected == "portfolio" {
        return AnyView(
            self.makeportfolioData()
        )}
        else if selected == "favfolio" { return AnyView(
            self.makefavfolioData()
        )} else {
                return AnyView(
                    self.makefavfolioData()
                )}
    }
    
    func makeButtonforPortfolioList() -> some View{
        Button{
            self.changeViewTo(viewname: "portfolio")
        }
    label: {
       Text("Portfolio")
           .frame(height:30)
           .frame(maxWidth: UIScreen.main.bounds.width * 0.3)
           .font(.system(size: 20))
           .background(self.isSelected(selected: "portfolio") ? Color.theme.accentcolor : Color.theme.backgroundsecondary)
           .foregroundColor(self.isSelected(selected: "portfolio") ? Color.theme.backgroundsecondary : Color.theme.accentcolor)
           .cornerRadius(10)
    }
    }
    func makeButtonforFavfolioList() -> some View{
        Button{
            self.changeViewTo(viewname: "favfolio")
        } label: {
            Text("Favorites")
                .frame(height:30)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.3)
                .font(.system(size: 20))
                .background(self.isSelected(selected: "favfolio") ? Color.theme.accentcolor : Color.theme.backgroundsecondary)
                .foregroundColor(self.isSelected(selected: "favfolio") ? Color.theme.backgroundsecondary : Color.theme.accentcolor)
                .cornerRadius(10)
        }
    }
    func makeportfolioData()-> some View{
            VStack{
                HStack{
                    VStack(alignment: .leading){
                        HStack{
                            Text("Portfolio Total:")
                                .font(.system(size: 20))
                            Spacer()
                            Text("\(self.portfoliototal().formatcurrency4digits())")
                                .font(.system(size: 20))
                                .frame(alignment:.leading)
                        }
                        HStack{
                            Text("Portfolio invested:")
                                .font(.system(size: 18))
                            Spacer()
                            Text("\(self.portfoliobuytotal().formatcurrency4digits())")
                                .foregroundColor(Color.theme.accentcolorsecondary)
                                .font(.system(size: 18))
                                .frame(alignment:.leading)
                        }
                    }.frame(width:UIScreen.main.bounds.width*0.75)
                    Spacer()
                    Text("\(self.winlosepercent().formatpercent())")
                        .foregroundColor((self.winlosepercent() >= 0) ? Color.theme.green : Color.theme.red )
                        .frame(alignment:.leading)
                    Spacer()
                }
            }
    }
    
    func makefavfolioData()-> some View{
            VStack{
                HStack{
                    VStack(alignment: .leading){
                        HStack{
                            Text("Your favorites price change:")
                                .font(.system(size: 20))
                            Text("\(self.favfoliochange().formatpercent())")
                                .foregroundColor((self.favfoliochange() >= 0) ? Color.theme.green : Color.theme.red )
                                .font(.system(size: 18))
                                .frame(alignment:.leading)
                            Spacer()
                        }
                        HStack{
                            Text("in the last 24 hours")
                                .font(.system(size: 18))
                            Spacer()
                            
                        }
                    }
                    .padding(5)
                    .frame(width:UIScreen.main.bounds.width*0.75)
                    Spacer()
                }
            }
    }
    
    func makeButtonforWalletList() -> some View{
        Button{
            self.changeViewTo(viewname: "wallet")
        } label: {
            Text("Wallet")
                .frame(height:30)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.3)
                .font(.system(size: 20))
                .background(self.isSelected(selected: "wallet") ? Color.theme.accentcolor : Color.theme.backgroundsecondary)
                .foregroundColor(self.isSelected(selected: "wallet") ? Color.theme.backgroundsecondary : Color.theme.accentcolor)
                .cornerRadius(10)
        }
    }
    
}
