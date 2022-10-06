//
//  DataDownloader.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 27..
//

import Foundation
import Combine

class DataDownloader {
    @Published var coins: [CoinModel] = []
    @Published var coindetail: [CoinDetailModel] = []
    @Published var stocks: [StockListItem] = []
    @Published var detailedStocks: [Stock] = []
    @Published var news = News(status: nil, totalResults: nil, articles: nil)
    @Published var stockNews = News(status: nil, totalResults: nil, articles: nil)
    var coinsub: AnyCancellable?
    var newssub: AnyCancellable?
    var stockNewssub: AnyCancellable?
    var stocksSub: AnyCancellable?
    var stockSub: AnyCancellable?
    var singlecoinsub: AnyCancellable?
    
    init(){
        loadCoins()
        loadnews()
        loadStocknews()
        loadStocks()
    }

    func loadCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=200&page=1&sparkline=true&price_change_percentage=24h")
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
            .sink {(completion) in
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

    func loadStocks() {
        print("loadstocks")
        detailedStocks = []
        guard let url = URL(string: "https://api.nasdaq.com/api/screener/stocks?tableonly=true&limit=10&exchange=NASDAQ")
        else {
            return
        }

        stocksSub = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { (output) -> Data in
                guard let response = output.response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {

                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: StockData.self, decoder: JSONDecoder())
            .sink {(completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] (returned) in
                self?.stocks = returned.data.table.rows
                self?.stocksSub?.cancel()
            }
    }

    func loadSingleStock(symbol: String) {
        print("lefutott")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringdateToday = dateFormatter.string(from: Date())
        let stringdateLastWeek = dateFormatter.string(from: Date.now.addingTimeInterval(-604800))
        // swiftlint:disable:next line_length
        let urlString = "https://api.polygon.io/v2/aggs/ticker/\(symbol.uppercased())/range/1/hour/"+stringdateLastWeek+"/"+stringdateToday+"?adjusted=true&sort=asc&limit=120&apiKey=EYcBp6VoRXW0iyk_ch7sy3NgpEbAfXqs"

        let url = URL(string: urlString)
        if let url = url {
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    print("error getting quote: \(error)")
                    return
                }

                guard let stockData = data else {
                    print("symbol search data not valid")
                    return
                }

                let returnedStock = try? JSONDecoder().decode(Stock.self, from: stockData)
                guard let stock = returnedStock else {
                    return
                }
                self.detailedStocks.append(stock)
            }
            task.resume()
        }

    }

    func loadnews() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let stringdate = dateFormatter.string(from: Date())
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=crypto&from="+stringdate+"&sortBy=publishedAt&apiKey=2755ba3f91f94ff890427a7629def7f6")
        else {
            return
        }
        let stringdateLastWeek = dateFormatter.string(from: Date.now.addingTimeInterval(-604800))
        print(stringdateLastWeek)
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
            .sink {(completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(String(describing: error))
                }
            } receiveValue: { [weak self] (returnednews) in
                self?.news = returnednews
                self?.newssub?.cancel()
            }
    }

    func loadStocknews() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let stringdate = dateFormatter.string(from: Date())
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=stocks&from="+stringdate+"&sortBy=publishedAt&apiKey=2755ba3f91f94ff890427a7629def7f6")
        else {
            return
        }
        let stringdateLastWeek = dateFormatter.string(from: Date.now.addingTimeInterval(-604800))
        print(stringdateLastWeek)
        stockNewssub = URLSession.shared.dataTaskPublisher(for: url)
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
            .sink {(completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(String(describing: error))
                }
            } receiveValue: { [weak self] (returnednews) in
                self?.stockNews = returnednews
                self?.stockNewssub?.cancel()
            }
    }

    func loadSinglecoinData(coinid: String) {
        let urlstring = "https://api.coingecko.com/api/v3/coins/bitcoin?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
        guard let url = URL(string: urlstring)
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
                .sink {(completion) in
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
