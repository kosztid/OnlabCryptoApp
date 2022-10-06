//
//  FavfolioListItemView.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 19..
//

import SwiftUI

struct FavfolioListItemView: View {
    @ObservedObject var presenter: FavfolioListItemPresenter
    var body: some View {
        ZStack{
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            
            HStack {

                HStack(alignment: .center){
                    CachedAsyncImage(url: URL(string: presenter.getcoin().image)){ image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Circle()
                            .frame(width: 20, height: 20)
                    }
                    .frame(width: 20, height: 20)
                    .cornerRadius(20)

                    Text(presenter.getcoin().symbol.uppercased())
                        .foregroundColor(Color.theme.accentcolor)
                        .font(.system(size: 18))
                    Spacer()

                    VStack(alignment: .trailing) {
                        Text(presenter.getcoin().currentPrice.formatcurrency6digits())
                            .foregroundColor(Color.theme.accentcolor)
                            .font(.system(size: 16))
                            .frame(alignment: .leading)
                        Text(presenter.getcoin().priceChangePercentage24H?.formatpercent() ?? "0%")
                            .foregroundColor((presenter.getcoin().priceChangePercentage24H ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
                            .font(.system(size: 12))
                    }
                    .frame(alignment: .trailing)
                }
                .padding(.trailing, 10)
                .frame(alignment: .leading)
                Spacer()
                presenter.makeFavButton()
            }
            .padding(.horizontal, 10.0)
        }
    }
}
/*
struct FavfolioListItemView_Previews: PreviewProvider {
    static var previews: some View {
        FavfolioListItemView()
    }
}
*/
