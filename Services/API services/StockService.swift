import Combine
import Foundation

class StockService {
    @Published var stocks: [StockListItem] = []
    @Published var detailedStocks: [Stock] = []

    var stocksSub: AnyCancellable?

    init() {
        loadStocks()
        print("stocksinit")
    }

    func loadStocks() {
        guard let url = URL(string: "https://api.nasdaq.com/api/screener/stocks?tableonly=true&limit=100&exchange=NASDAQ")
        else {
            return
        }
        stocksSub = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: StockData.self, decoder: JSONDecoder())
            .sink {completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] returned in
                self?.stocks = returned.data.table.rows
                self?.stocks.append(StockListItem(symbol: "USD", name: "US DOLLAR", lastsale: "$1", netchange: "0", pctchange: "0%", marketCap: "0", url: "0"))
                self?.stocksSub?.cancel()
            }
    }
}
