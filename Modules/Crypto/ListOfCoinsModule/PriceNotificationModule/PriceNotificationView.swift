//
//  PriceNotificationView.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 05. 02..
//

import SwiftUI

struct PriceNotificationView: View {
    @ObservedObject var presenter: PriceNotificationPresenter
    var body: some View {
        ZStack {
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            List {
                ForEach(presenter.events) { event in
                    ZStack {
                        Color.theme.backgroundcolor
                            .ignoresSafeArea()
                        HStack {
                            Text(presenter.coinname(coinid: event.coinid))
                            Spacer()
                            Text("\((-1*(100-(presenter.currentPrice(coinid: event.coinid)/event.price*100))).formatpercent())")
                        }.frame(width: UIScreen.main.bounds.width*0.9)
                    }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .toolbar {
            }
            .listStyle(PlainListStyle())
        }
    }
}
