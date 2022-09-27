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
        ZStack {
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            VStack {
                presenter.makeFolioData(selected: presenter.selection)
                    .padding(5)
                VStack {
                    HStack {
                        Spacer()
                        presenter.makeButtonforPortfolioList()
                        presenter.makeButtonforFavfolioList()
                            .accessibilityIdentifier("FavfolioButton")
                        presenter.makeButtonforWalletList()                            
                            .accessibilityIdentifier("WalletButton")
                        Spacer()
                    }
                }
                .padding(.horizontal, 5)
                .frame(height: 100, alignment: .leading)
                presenter.makeList(selected: presenter.selection)
                .toolbar{
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
