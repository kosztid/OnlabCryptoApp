//
//  PortfolioAdderView.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 02..
//

import SwiftUI

struct PortfolioAdderView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var presenter: PortfolioAdderPresenter
    
    var body: some View {
        VStack{
            HStack{
                Text("The selected coin is:")
                Text(presenter.coindata().name)
            }
            
            Button{
                presenter.addCoin()
                self.presentationMode.wrappedValue.dismiss()
            } label : {
                Text("Add")
                    .frame(height:50)
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 20))
                    .background(Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)))
                    .cornerRadius(10)
            }
        }
        
    }
}

struct PortfolioAdderView_Previews: PreviewProvider {
    static var previews: some View {
        let model = DataModel()
        let interactor = PortfolioAdderInteractor(coin: CoinModel(id: "teszt", symbol: "teszt", name: "teszt", image: "teszt", currentPrice: 10, marketCap: 10, marketCapRank: 10, fullyDilutedValuation: 10, totalVolume: 10, high24H: 10, low24H: 10, priceChange24H: 10, priceChangePercentage24H: 10, marketCapChange24H: 10, marketCapChangePercentage24H: 10, circulatingSupply: 10, totalSupply: 10, maxSupply: 10, ath: 10, athChangePercentage: 10, athDate: "teszt", atl: 10, atlChangePercentage: 10, atlDate: "teszt", lastUpdated: "teszt", sparklineIn7D: SparklineIn7D(price: []), priceChangePercentage24HInCurrency: 10), model: model)
        let presenter = PortfolioAdderPresenter(interactor: interactor)
        PortfolioAdderView(presenter: presenter)
            .environmentObject(DataModel())
    }
}
