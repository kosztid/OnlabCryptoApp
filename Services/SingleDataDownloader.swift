//
//  SingleDataDownloader.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 27..
//

import Foundation
import Combine

class SingleDataDownloader{
    var coinid: String
    @Published var coindetail: CoinDetailModel = CoinDetailModel(id: "bitcoin", symbol: "bitcoin", name: "bitcoin", blockTimeInMinutes: 10, hashingAlgorithm: "bitcoin", categories: ["bitcoin"], welcomeDescription: CoinDetailModel.Description(en: "leiras"), countryOrigin: "bitcoin", genesisDate: "bitcoin", sentimentVotesUpPercentage: 10, sentimentVotesDownPercentage: 10, marketCapRank: 10, coingeckoRank: 10, coingeckoScore: 10, developerScore: 10, communityScore: 10, liquidityScore: 10, publicInterestScore: 10, lastUpdated: "bitcoin")
    var singlecoinsub: AnyCancellable?

    init(coinid: String){
        self.coinid = coinid
        loadSinglecoinData(coinid: self.coinid)
    }
    
    func loadSinglecoinData(coinid: String){
            let urlstring = "https://api.coingecko.com/api/v3/coins/"+coinid+"?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
                
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
                        self?.coindetail = returnedCoins
                        self?.singlecoinsub?.cancel()
                        //let _ = print("otodik")
                    }
        }
        
}
