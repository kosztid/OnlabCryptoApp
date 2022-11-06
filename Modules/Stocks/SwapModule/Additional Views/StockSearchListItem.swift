//
//  SearchListItem.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 26..
//

import SwiftUI

struct StockSearchListItem: View {
    var stock: StockListItem
    var body: some View {
        ZStack {
            Color.theme.backgroundcolor
                .ignoresSafeArea()

            HStack {
                Text(stock.symbol)
                    .font(.system(size: 15))
                    .foregroundColor(Color.theme.accentcolor)
                    .frame(minWidth: 25)
                    .frame(alignment: .trailing)
                Spacer()
                Text(stock.pctchange)
                    .foregroundColor(stock.pctchange.contains("-") ? Color.theme.red : Color.theme.green)
                    .font(.system(size: 12))

                VStack(alignment: .trailing) {
                    Text(stock.lastsale)
                        .foregroundColor(Color.theme.accentcolor)
                        .font(.system(size: 18))
                        .frame(alignment: .leading)
                }
                .frame(width: UIScreen.main.bounds.width / 4, alignment: .trailing)
            }
            .padding(.all, 5)
        }}
}
