import Combine
import Foundation

struct Favfolio: Codable {
    let id: Int
    let coinid: String
    let count: Double
    let buytotal: Double?
}

class UserService {
    @Published var cryptoFavs: [CryptoServerModel] = []
    @Published var cryptoPortfolio: [CryptoServerModel] = []
    @Published var cryptoWallet: [CryptoServerModel] = []
    @Published var stockFavs: [StockServerModel] = []
    @Published var stockPortfolio: [StockServerModel] = []
    @Published var stockWallet: [StockServerModel] = []
    
    var userSub: AnyCancellable?
    
    // MARK: - User data, account
    func loadUser(apikey: String, userID: String) {
        print("lefutott")
        guard let url = URL(string: "http://localhost:8080/api/v1/users/\(userID)")
        else {
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        userSub = URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { (output) -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {

                          throw URLError(.badServerResponse)
                      }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: UserModel.self, decoder: JSONDecoder())
            .sink {(completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] (returnedUser) in
                print(returnedUser.favfolio)
                self?.cryptoFavs = returnedUser.favfolio
                self?.cryptoPortfolio = returnedUser.portfolio
                self?.cryptoWallet = returnedUser.wallet
                self?.stockFavs = returnedUser.stockfavfolio
                self?.stockPortfolio = returnedUser.stockportfolio
                self?.stockWallet = returnedUser.stockwallet
                print(returnedUser.stockportfolio)
                self?.userSub?.cancel()
            }
    }

    func registerUser(_ apikey: String, _ userId: String, _ email: String) {
        guard let url = URL(string: "http://localhost:8080/api/v1/users") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "id": userId,
            "email": email
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        let task = URLSession.shared.dataTask(with: request) { _, _, error in
            guard error == nil else {
                return
            }
            self.loadUser(apikey: apikey, userID: userId)
        }
        task.resume()
    }

    // MARK: - Crypto portfolio
    func updateWallet(_ apikey: String, _ userId: String, _ coinToSell: String, _ coinToBuy: String, _ sellAmount: Double, _ buyAmount: Double) {
        guard let url = URL(string: "http://localhost:8080/api/v1/users/\(userId)/wallet/") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "cointoSell": "\(coinToSell)",
            "cointoBuy": "\(coinToBuy)",
            "sellAmount": sellAmount,
            "buyAmount": buyAmount
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        let task = URLSession.shared.dataTask(with: request) { _, _, error in
            guard error == nil else {
                return
            }
            self.loadUser(apikey: apikey, userID: userId)
        }
        task.resume()
    }

    func updatePortfolio(_ apikey: String, _ userId: String, _ coinId: String, _ count: Double, _ buytotal: Double) {
        guard let url = URL(string: "http://localhost:8080/api/v1/users/\(userId)/portfolio/") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "coinid": "\(coinId)",
            "count": count,
            "buytotal": buytotal
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        let task = URLSession.shared.dataTask(with: request) { _, _, error in
            guard error == nil else {
                return
            }
            self.loadUser(apikey: apikey, userID: userId)
        }
        task.resume()
    }

    func updateFavs(_ apikey: String, _ userId: String, _ coinId: String) {
        guard let url = URL(string: "http://localhost:8080/api/v1/users/\(userId)/favfolio/") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        let body: [String: AnyHashable] = [
            "coinid": "\(coinId)"
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        let task = URLSession.shared.dataTask(with: request) { _, _, error in
            guard error == nil else {
                return
            }
            self.loadUser(apikey: apikey, userID: userId)
        }
        task.resume()
    }

    // MARK: - Stocks portfolio
    

}
