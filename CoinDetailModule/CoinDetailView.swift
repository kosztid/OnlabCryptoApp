//
//  CoinDetailView.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 26..
//

import SwiftUI

struct CoinDetailView: View {
    @ObservedObject var presenter: CoinDetailPresenter
    
    var body: some View {
        ZStack{
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            VStack{
                Text("\(presenter.coin().currentPrice)")
                Text("\(Double(presenter.coin().high24H ?? 0.0))")
                Text("\(Double(presenter.coin().low24H ?? 0.0))")
                Text(presenter.detailed().welcomeDescription?.en ?? "No description")
                ChartView(values: presenter.values())
            }
        }
    }
}

