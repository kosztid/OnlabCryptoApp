import Combine
import Foundation

class CoinService {
    @Published var coins: [CoinModel] = []
    let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=200&page=1&sparkline=true&price_change_percentage=24h"
    var cancellable: AnyCancellable?

    init() {
        loadCoins()
    }
    func loadCoins() {
        guard let url = URL(string: urlString)
        else {
            return
        }
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] returnedCoins in
                self?.coins = returnedCoins
                self?.cancellable?.cancel()
            }
    }
}
