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
            ScrollView{
                VStack{
                    HStack{
                        VStack{
                            Text("\(presenter.coin().currentPrice.formatcurrency6digits())")
                                .font(.system(size: 35))
                                .foregroundColor(Color.theme.accentcolor)
                                .frame(alignment:.trailing)
                            Text("\(presenter.coin().priceChangePercentage24H?.formatpercent() ?? "0%" )")
                                .foregroundColor((presenter.coin().priceChangePercentage24H ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
                        }
                        Spacer()
                    }
                    .frame(alignment: .trailing)
                    ChartView(values: presenter.values())
                        .foregroundColor((presenter.coin().priceChangePercentage24H ?? 0) >= 0 ? Color.theme.greengraph : Color.theme.redgraph)
                    Text("\(Double(presenter.coin().high24H ?? 0.0))")
                    Text("\(Double(presenter.coin().low24H ?? 0.0))")
                    //Text(presenter.detailed().welcomeDescription?.en ?? "No description")
                    Spacer()
                }
                .padding(10)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("\(presenter.coin().name)  (\(presenter.coin().symbol.uppercased()))")
        }
    }
}

struct CoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let model = DataModel()
        let interactor = CoinDetailInteractor(coin: CoinModel(id: "teszt", symbol: "teszt", name: "teszt", image: "teszt", currentPrice: 10, marketCap: 10, marketCapRank: 10, fullyDilutedValuation: 10, totalVolume: 10, high24H: 10, low24H: 10, priceChange24H: 10, priceChangePercentage24H: 10, marketCapChange24H: 10, marketCapChangePercentage24H: 10, circulatingSupply: 10, totalSupply: 10, maxSupply: 10, ath: 10, athChangePercentage: 10, athDate: "teszt", atl: 10, atlChangePercentage: 10, atlDate: "teszt", lastUpdated: "teszt", sparklineIn7D: SparklineIn7D(price: []), priceChangePercentage24HInCurrency: 10), model: model)
        let presenter = CoinDetailPresenter(interactor: interactor)
        CoinDetailView(presenter: presenter)
            .environmentObject(DataModel())
    }
}

