//
//  CoinDetailView.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 26..
//

import SwiftUI

struct CoinDetailView: View {
    @State var showalert : Bool = false
    @ObservedObject var presenter: CoinDetailPresenter
    var body: some View {
        ZStack{
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            ScrollView{
                VStack{
                    HStack{
                        VStack{
                            Text("\(presenter.getcoin().currentPrice.formatcurrency6digits())")
                                .font(.system(size: 35))
                                .foregroundColor(Color.theme.accentcolor)
                                .frame(alignment:.trailing)
                            HStack{
                                Text("\(presenter.getcoin().priceChangePercentage24H?.formatpercent() ?? "0%" )")
                                    
                                Text("(\(presenter.getcoin().priceChange24H?.formatcurrency4digits() ?? "0" ))")
                            }.foregroundColor((presenter.getcoin().priceChangePercentage24H ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
                        }
                        Spacer()
                     /*   Button("ADD"){
                            self.showalert = true
                        }
                        .alert(isPresented:$showalert){
                            Alert(title: Text("Add"), message: Text("type in the amount"), primaryButton: .destructive(Text("Add")){}, secondaryButton: .cancel())
                        }
                        }*/
                        presenter.makeFavButton()
                    }
                    .frame(alignment: .trailing)
                    ChartView(values: presenter.values())
                        .foregroundColor((presenter.getcoin().priceChangePercentage24H ?? 0) >= 0 ? Color.theme.greengraph : Color.theme.redgraph)
                    HStack{
                        Text("MarketCap: ")
                            .foregroundColor(Color.theme.accentcolorsecondary)
                        Spacer()
                        Text("\(presenter.getcoin().marketCap?.formatcurrency0digits() ?? "0")")
                    }
                    .font(.system(size: 18))
                    .padding(5)
                    .foregroundColor(Color.theme.accentcolor)
                    HStack{
                        VStack(alignment:.leading){
                            Text("24H High")
                                .font(.system(size: 18))
                                .foregroundColor(Color.theme.accentcolorsecondary)
                            HStack{
                                Text("\(presenter.getcoin().high24H?.formatcurrency6digits() ?? "0")")
                                    .foregroundColor(Color.theme.accentcolor)
                                    .font(.system(size: 18))
                            }
                        }
                        Spacer()
                        VStack(alignment:.trailing){
                            Text("24H Low")
                                .font(.system(size: 18))
                                .foregroundColor(Color.theme.accentcolorsecondary)
                            HStack{
                                Text("\(presenter.getcoin().low24H?.formatcurrency6digits() ?? "0")")
                                    .foregroundColor(Color.theme.accentcolor)
                                    .font(.system(size: 18))
                            }
                        }
                    }
                    .padding(5)
                    HStack{
                        VStack(alignment:.leading){
                            Text("All-Time High")
                                .font(.system(size: 18))
                                .foregroundColor(Color.theme.accentcolorsecondary)
                                .frame(alignment:.leading)
                            HStack{
                                Text("\(presenter.getcoin().ath?.formatcurrency6digits() ?? "0")")
                                    .foregroundColor(Color.theme.accentcolor)
                                    .font(.system(size: 18))
                                Text("\(presenter.getcoin().athChangePercentage?.formatpercent() ?? "0%")")
                                    .foregroundColor(Color.theme.red)
                                    .font(.system(size: 14))
                            }
                        }
                        Spacer()
                        VStack(alignment:.trailing){
                            Text("All-Time Low")
                                .font(.system(size: 18))
                                .foregroundColor(Color.theme.accentcolorsecondary)
                            HStack{
                                Text("\(presenter.getcoin().atl?.formatcurrency6digits() ?? "0")")
                                    .foregroundColor(Color.theme.accentcolor)
                                    .font(.system(size: 18))
                                Text("\(presenter.getcoin().atlChangePercentage?.formatpercent() ?? "0%")")
                                    .foregroundColor(Color.theme.greengraph)
                                    .font(.system(size: 14))
                            }
                        }
                    }
                    .padding(5)
                    
                    HStack{
                        VStack(alignment:.leading){
                            HStack(alignment: .top){
                                Text("Available Supply")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.theme.accentcolorsecondary)
                                Spacer()
                                Text("Total Supply")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.theme.accentcolorsecondary)
                            }
                            HStack{
                                Text("\(presenter.getcoin().circulatingSupply?.formatintstring() ?? "0")")
                                    .foregroundColor(Color.theme.accentcolor)
                                    .font(.system(size: 18))
                                Spacer()
                                Text("/")
                                Spacer()
                                Text("\(presenter.getcoin().totalSupply?.formatintstring() ?? "0")")
                                    .foregroundColor(Color.theme.accentcolor)
                                    .font(.system(size: 18))
                            }
                        }
                    }
                    .padding(5)
                    Spacer()
                }
                .padding(10)
            }
            .navigationBarItems(trailing: presenter.makeButtonForPortfolioAdderView())
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("\(presenter.getcoin().name)  (\(presenter.getcoin().symbol.uppercased()))")
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

