//
//  PortfolioListItem.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 02..
//

import SwiftUI

struct PortfolioListItem: View {
    @ObservedObject var presenter: PortfolioPresenter
    var holding: Double
    // swiftlint:disable next line_length
   // var coin = CoinModel(id: "bitcoin", symbol: "btc", name: "teszt", image: "teszt", currentPrice: 10, marketCap: 10, marketCapRank: 279, fullyDilutedValuation: 10, totalVolume: 10, high24H: 10, low24H: 10, priceChange24H: 10, priceChangePercentage24H: 10, marketCapChange24H: 10, marketCapChangePercentage24H: 10, circulatingSupply: 10, totalSupply: 10, maxSupply: 10, ath: 10, athChangePercentage: 10, athDate: "teszt", atl: 10, atlChangePercentage: 10, atlDate: "teszt", lastUpdated: "teszt", sparklineIn7D: SparklineIn7D(price: []), priceChangePercentage24HInCurrency: 10)
    var coin: CoinModel
    
    var body: some View {
        ZStack{
            Color.theme.backgroundcolor
                .ignoresSafeArea()

            HStack {
                HStack(alignment: .center){
                    CachedAsyncImage(url: URL(string: coin.image)){ image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Circle()
                            .frame(width: 20, height: 20)
                    }
                    .frame(width: 20, height: 20)
                    .cornerRadius(20)
                    Text(coin.symbol.uppercased())
                        .foregroundColor(Color.theme.accentcolor)
                        .font(.system(size: 18))
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(coin.currentPrice.formatcurrency6digits())
                            .foregroundColor(Color.theme.accentcolor)
                            .font(.system(size: 16))
                            .frame(alignment: .leading)
                        Text(coin.priceChangePercentage24H?.formatpercent() ?? "0%")
                            .foregroundColor((coin.priceChangePercentage24H ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
                            .font(.system(size: 12))
                    }
                    .frame(alignment:.trailing)
                }
                .padding(.trailing, 10)
                .frame(alignment: .leading)
                Spacer()
                HStack{
                    VStack(alignment: .leading) {
                        Text("\(self.holding.format2digits())")
                            .foregroundColor(Color.theme.accentcolor)
                        Text(coin.symbol.uppercased())
                            .foregroundColor(Color.theme.accentcolorsecondary)
                    }
                    .font(.system(size: 16))
                    Spacer()
                    Text("(\((self.holding * coin.currentPrice).formatcurrency0digits()))")
                        .font(.system(size: 14))
                }
                .foregroundColor(Color.theme.accentcolor)
                .frame(width: UIScreen.main.bounds.width/2.5, alignment: .trailing)
            }
            .padding(.horizontal, 10.0)
        }

    }
}
struct PortfolioListItem_Previews: PreviewProvider {
    static var previews: some View {
        // swiftlint:disable:next line_length
        PortfolioListItem(presenter: PortfolioPresenter(interactor: PortfolioInteractor(model: DataModel())), holding: 10.1, coin: CoinModel(id: "teszt", symbol: "teszt", name: "teszt", image: "teszt", currentPrice: 10, marketCap: 10, marketCapRank: 279, fullyDilutedValuation: 10, totalVolume: 10, high24H: 10, low24H: 10, priceChange24H: 10, priceChangePercentage24H: 10, marketCapChange24H: 10, marketCapChangePercentage24H: 10, circulatingSupply: 10, totalSupply: 10, maxSupply: 10, ath: 10, athChangePercentage: 10, athDate: "teszt", atl: 10, atlChangePercentage: 10, atlDate: "teszt", lastUpdated: "teszt", sparklineIn7D: SparklineIn7D(price: []), priceChangePercentage24HInCurrency: 10))
    }
}
