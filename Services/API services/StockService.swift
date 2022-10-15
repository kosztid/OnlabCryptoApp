import Foundation
import Combine

class StockService {
    @Published var stocks: [StockListItem] = []
    @Published var detailedStocks: [Stock] = []

    var stocksSub: AnyCancellable?

    init() {
        loadStocks()
    }

    func loadStocks() {
        guard let url = URL(string: "https://api.nasdaq.com/api/screener/stocks?tableonly=true&limit=100&exchange=NASDAQ")
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
                self?.stocks.append(StockListItem(symbol: "USD", name: "US DOLLAR", lastsale: "$1", netchange: "0", pctchange: "0%", marketCap: "0", url: "0"))
                self?.stocksSub?.cancel()
            }
    }

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
                    let result = Result(v: 1, vw: 1, o: 1, c: 1, h: 1, l: 1, t: 1, n: 1)
                    self.detailedStocks.append(Stock(ticker: "USD", queryCount: 1, resultsCount: 1, adjusted: true, results: [result], status: "OK", requestID: UUID().uuidString, count: 1))
                } else {
                    self.detailedStocks.append(stock)
                }
            }
            task.resume()
        }
    }
}
