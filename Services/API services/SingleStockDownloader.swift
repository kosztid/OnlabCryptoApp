import Combine
import Foundation

class SingleStockDownloader {
    var stockSub: AnyCancellable?
    // swiftlint:disable:next line_length
    @Published var stock = Stock(ticker: "Loading...", queryCount: 1, resultsCount: 1, adjusted: false, results: [], status: "Loading...", requestID: "Loading...", count: 1)

    func loadSingleStock(symbol: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringdateToday = dateFormatter.string(from: Date())
        let stringdateLastWeek = dateFormatter.string(from: Date.now.addingTimeInterval(-604800))

        let urlString = "https://api.polygon.io/v2/aggs/ticker/\(symbol.uppercased())/range/1/hour/" + stringdateLastWeek + "/" + stringdateToday + "?adjusted=true&sort=asc&limit=120&apiKey=EYcBp6VoRXW0iyk_ch7sy3NgpEbAfXqs"

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
                    let res = Result(v: 1, vw: 1, o: 1, c: 1, h: 1, l: 1, t: 1, n: 1)
                    let id = UUID().uuidString
                    self.stock = Stock(ticker: "USD", queryCount: 1, resultsCount: 1, adjusted: true, results: [res], status: "OK", requestID: id, count: 1)
                } else {
                    self.stock = stock
                }
            }
            task.resume()
        }
    }
}
