//
//  DataModel.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 26..
//

import Foundation
import SwiftUI
import Combine

/*
 URL for coins https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=200&page=1&sparkline=true&price_change_percentage=24h
 pl:
 {
     "id": "bitcoin",
     "symbol": "btc",
     "name": "Bitcoin",
     "image": "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
     "current_price": 38929,
     "market_cap": 737608692589,
     "market_cap_rank": 1,
     "fully_diluted_valuation": 816598025132,
     "total_volume": 20918136482,
     "high_24h": 39877,
     "low_24h": 38486,
     "price_change_24h": 143.98,
     "price_change_percentage_24h": 0.37121,
     "market_cap_change_24h": 6107947597,
     "market_cap_change_percentage_24h": 0.83499,
     "circulating_supply": 18968675,
     "total_supply": 21000000,
     "max_supply": 21000000,
     "ath": 69045,
     "ath_change_percentage": -43.68057,
     "ath_date": "2021-11-10T14:24:11.849Z",
     "atl": 67.81,
     "atl_change_percentage": 57245.80991,
     "atl_date": "2013-07-06T00:00:00.000Z",
     "roi": null,
     "last_updated": "2022-02-26T10:05:10.524Z",
     "sparkline_in_7d": {
       "price": [
         40289.25829858139,
         39429.4575868969
       ]
     },
     "price_change_percentage_24h_in_currency": 0.3712147223907504
   }
 
 */
final class DataModel: ObservableObject{
    @Published var coins: [CoinModel] = []
    @Published var coindetail: [CoinDetailModel] = []
    //@Published var coinimages: [UIImage] = []
    private let datadownloader = DataDownloader()
    @Published var heldcoins: [String] = ["terra-luna","ethereum-classic"]
    @Published var heldcoinscount: [Double] = [10,19.123]
    //private var datadownloaderfordetail = SingleDataDownloader(coinid: "ethereum")
   // var singlecoinsub: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        addSub()
       // coins.append(CoinModel(id: "teszt", symbol: "teszt", name: "teszt", image: "teszt", currentPrice: 10, marketCap: 10, marketCapRank: 10, fullyDilutedValuation: 10, totalVolume: 10, high24H: 10, low24H: 10, priceChange24H: 10, priceChangePercentage24H: 10, marketCapChange24H: 10, marketCapChangePercentage24H: 10, circulatingSupply: 10, totalSupply: 10, maxSupply: 10, ath: 10, athChangePercentage: 10, athDate: "teszt", atl: 10, atlChangePercentage: 10, atlDate: "teszt", lastUpdated: "teszt", sparklineIn7D: SparklineIn7D(price: []), priceChangePercentage24HInCurrency: 10))
    }
    
    func addSub(){
        datadownloader.$coins
            .sink{ [weak self] (datareceived) in self?.coins = datareceived}
            .store(in: &cancellables)
                   
    }
    
    func addHolding(coinid: String,coincount: Double){
        if heldcoins.contains(coinid){
            return
        }
        else {
            heldcoins.append(coinid)
            heldcoinscount.append(coincount)
        }
    }
    
    func removeCoin(cointoremove: CoinModel){
        if let index = heldcoins.firstIndex(where: { $0 == cointoremove.id }) {
            heldcoins.remove(at: index)
            heldcoinscount.remove(at: index)
        }
    }
    
    func portfoliototal() -> Double {
        if heldcoins.count == 0 {
            return 0
        }
        var total: Double = 0
        for a in 0...(heldcoins.count-1) {
            let currentprice = coins.first(where: {$0.id == heldcoins[a]})?.currentPrice ?? 0.0
            total += (heldcoinscount[a] * currentprice)
        }
        return total
    }
   /* func loaddetailedcoin(coinid: String){
        datadownloaderfordetail = SingleDataDownloader(coinid: coinid)
        datadownloaderfordetail.$coindetail
            .sink{ [weak self] (datareceived) in self?.coindetail = datareceived}
            .store(in: &cancellables2)

    
    }
    */
    /*
    func loaddetailedcoin(){
        for a in 0...200{
            let urlstring = "https://api.coingecko.com/api/v3/coins/terra-luna?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
                
            guard let url = URL(string:urlstring)
                else {
                    return
                }
                
                singlecoinsub = URLSession.shared.dataTaskPublisher(for: url)
                    .subscribe(on: DispatchQueue.global(qos: .default))
                    .tryMap { (output) -> Data in
                        guard let response = output.response as? HTTPURLResponse,
                        response.statusCode >= 200 && response.statusCode < 300 else {
                            
                            throw URLError(.badServerResponse)
                        }
                        return output.data
                    }
                    .receive(on: DispatchQueue.main)
                    .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
                    .sink{(completion) in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    } receiveValue: { [weak self] (returnedCoins) in
                        //let _ = print("negyedik")
                        self?.coindetail.append(returnedCoins)
                        self?.singlecoinsub?.cancel()
                        //let _ = print("otodik")
                    }
        }
        }
     */
        
}
