//
//  ListOfCoinsView.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 25..
//

import SwiftUI

struct ListOfCoinsView: View {
    @ObservedObject var presenter: ListOfCoinsPresenter
    var body: some View {
        ZStack{
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            List{
                ForEach(presenter.coins){ coin in
                    ZStack{
                        Color.theme.backgroundcolor
                                .ignoresSafeArea()
                        ListOfCoinsListItem(presenter: presenter, coin: coin)
                            .frame(height: 40)
                        self.presenter.linkBuilder(for: coin){
                            EmptyView()
                        }.buttonStyle(PlainButtonStyle())
                    }
                    
                }
                .listRowSeparatorTint(Color.theme.backgroundsecondary)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    presenter.makeButtonForPriceNotification()
                        .disabled(!presenter.signedin)
                        .accessibilityIdentifier("PriceNotificationButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if presenter.signedin {
                        presenter.makeButtonForAccount()
                            .accessibilityIdentifier("PortfolioAccountButton")
                    } else {
                        presenter.makeButtonForLogin()
                            .accessibilityIdentifier("PortfolioLoginButton")
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        
    }
}

struct ListOfCoinsView_Previews: PreviewProvider {
    static var previews: some View {
        let model = DataModel()
        let interactor = ListOfCoinsInteractor(model: model)
        let presenter = ListOfCoinsPresenter(interactor: interactor)
        ListOfCoinsView(presenter: presenter)
            .environmentObject(DataModel())
    }
}
