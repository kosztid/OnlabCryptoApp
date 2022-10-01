//
//  ListOfStocksView.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 09. 28..
//

import SwiftUI

struct ListOfStocksView: View {
    @ObservedObject var presenter: ListOfStocksPresenter
    var body: some View {
        ZStack {
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            List {
                ForEach(presenter.stocks) { stock in
                    ZStack {
                        Color.theme.backgroundcolor
                                .ignoresSafeArea()
                        ListOfStocksListItem(stock: stock)
                            .frame(height: 40)
                        self.presenter.linkBuilder(for: stock) {
                            EmptyView()
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
                .listRowSeparatorTint(Color.theme.backgroundsecondary)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    presenter.makeButtonForViewchange()
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
