//
//  PortfolioView.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 25..
//

import SwiftUI

struct PortfolioView: View {
    @ObservedObject var presenter: PortfolioPresenter
    var body: some View {
        ZStack{
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            
            VStack{
                VStack{
                    Text("Portfolio Total:")
                    Text("\(presenter.portfoliototal().formatcurrency4digits())")
                }
                List{
                    ForEach(presenter.coins){ coin in
                        if presenter.heldcoins().contains(coin.id) {
                            ZStack{
                                Color.theme.backgroundcolor
                                        .ignoresSafeArea()
                                    
                                PortfolioListItem(presenter: presenter,holding: presenter.getholdingcount(coin: coin), coin: coin)
                                    .frame(height: 80)
                                self.presenter.linkBuilder(for: coin){
                                    EmptyView()
                                }.buttonStyle(PlainButtonStyle())
                            }
                            .frame(height: 60)
                        }
                        
                    }
                    .onDelete(perform: presenter.removeCoin)
                    .listRowSeparatorTint(Color.theme.backgroundsecondary)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        presenter.makeButtonForLogin()
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        let model = DataModel()
        let interactor = PortfolioInteractor(model: model)
        let presenter = PortfolioPresenter(interactor: interactor)
        PortfolioView(presenter: presenter)
            .environmentObject(DataModel())
    }
}
