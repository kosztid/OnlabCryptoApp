import Foundation
import Combine

class SingleStockDownloader {
    var stockSub: AnyCancellable?
    @Published var stock = Stock(ticker: "Loading...", queryCount: 1, resultsCount: 1, adjusted: false, results: [], status: "Loading...", requestID: "Loading...", count: 1)

    func loadSingleStock(symbol: String) {
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
                if symbol == "USD" {
                    var result = Result(v: 1, vw: 1, o: 1, c: 1, h: 1, l: 1, t: 1, n: 1)
                    self.stock  = Stock(ticker: "USD", queryCount: 1, resultsCount: 1, adjusted: true, results: [result], status: "OK", requestID: UUID().uuidString, count: 1)
                } else {
                    self.stock = stock
                }
            }
            task.resume()
        }
    }
}
