//
//  DataDownloader.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 27..
//

import Foundation
import Combine

class DataDownloader{
    @Published var coins: [CoinModel] = []
    @Published var coindetail: [CoinDetailModel] = []
    @Published var news = News(status: nil, totalResults: nil, articles: nil)
    var coinsub: AnyCancellable?
    var newssub: AnyCancellable?
    var singlecoinsub: AnyCancellable?
    
    init(){
        loadCoins()
        loadnews()
    }
    
    func loadCoins(){
        guard let url = URL(string:"https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=200&page=1&sparkline=true&price_change_percentage=24h")
        else {
            return
        }
        
        coinsub = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { (output) -> Data in
                guard let response = output.response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {
                    
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink{(completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] (returnedCoins) in
                self?.coins = returnedCoins
                self?.coinsub?.cancel()
            }
        
    }
    
    func loadnews(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringdate = dateFormatter.string(from: Date())
        
        guard let url = URL(string:"https://newsapi.org/v2/everything?q=crypto&from="+stringdate+"&sortBy=publishedAt&apiKey=2755ba3f91f94ff890427a7629def7f6")
        else {
            return
        }
        
        newssub = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { (output) -> Data in
                guard let response = output.response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: News.self, decoder: JSONDecoder())
            .sink{(completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(String(describing: error))
                }
            } receiveValue: { [weak self] (returnedCoins) in
                self?.news = returnedCoins
                self?.newssub?.cancel()
            }
        
    }
    
    
    func loadSinglecoinData(coinid: String){
        let urlstring = "https://api.coingecko.com/api/v3/coins/bitcoin?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
            
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
                .decode(type: [CoinDetailModel].self, decoder: JSONDecoder())
                .sink{(completion) in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                } receiveValue: { [weak self] (returnedCoins) in
                    self?.coindetail = returnedCoins
                    self?.singlecoinsub?.cancel()
                }
    }
}
