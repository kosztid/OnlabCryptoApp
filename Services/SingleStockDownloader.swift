//
//  SingleStockDownloader.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 09. 28..
//

import Foundation
import Combine

class SingleStockDownloader {
    var stockSub: AnyCancellable?
    @Published var stock = Stock(ticker: "Loading...", queryCount: 1, resultsCount: 1, adjusted: false, results: [], status: "Loading...", requestID: "Loading...", count: 1)

//    init(symbol: String) {
//        loadSingleStock(symbol: symbol)
//    }

    func loadSingleStock(symbol: String) {
        print("lefutott")
        let urlString = "https://api.polygon.io/v2/aggs/ticker/\(symbol.uppercased())/range/1/day/2022-09-14/2022-09-30?adjusted=true&sort=asc&limit=120&apiKey=EYcBp6VoRXW0iyk_ch7sy3NgpEbAfXqs"

        let url = URL(string: urlString)
        if let url = url {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
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
                self.stock = stock
            }
            task.resume()
        }
    }
}
