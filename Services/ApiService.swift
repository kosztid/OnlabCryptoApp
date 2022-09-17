//
//  ApiService.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 09. 17..
//
import Combine
import Foundation

struct User: Codable {
    let id: String
    let email: String
    let favfolio, portfolio, wallet: [Favfolio]
}

struct Favfolio: Codable {
    let id: Int
    let coinid: String
    let count: Double
    let buytotal: Double?
}


class ApiService {
    @Published var favs: [CoinDataFirebaseModel] = []
    @Published var portfolio: [CoinDataFirebaseModel] = []
    @Published var wallet: [CoinDataFirebaseModel] = []
    var userSub: AnyCancellable?

    func loadUser() {
        let baseUrl = "http://localhost:8080/api/v1/users/"
        guard let url = URL(string:"\(baseUrl)CvCslkZ5EnQvtgzMbXLtc90TJ6J2")
        else {
            return
        }

        userSub = URLSession.shared.dataTaskPublisher(for: url)
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
            .sink{(completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] (returnedUser) in
                print(returnedUser.favfolio)
                self?.favs = returnedUser.favfolio
                self?.portfolio = returnedUser.portfolio
                self?.wallet = returnedUser.wallet
                self?.userSub?.cancel()
            }
    }

    func updateWallet(_ userId: String, _ coinToSell: String,_ coinToBuy: String, _ sellAmount: Double, _ buyAmount: Double) {
        guard let url = URL(string: "http://localhost:8080/api/v1/users/\(userId)/wallet/") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "cointoSell": "\(coinToSell)",
            "cointoBuy": "\(coinToBuy)",
            "sellAmount": sellAmount,
            "buyAmount": buyAmount
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                return
            }
            self.loadUser()
        }
        task.resume()
    }

    func updatePortfolio(_ userId: String, _ coinId: String, _ count: Double, _ buytotal: Double) {
        guard let url = URL(string: "http://localhost:8080/api/v1/users/\(userId)/portfolio/") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "coinid": "\(coinId)",
            "count": count,
            "buytotal": buytotal
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                return
            }
            self.loadUser()
        }
        task.resume()
    }

    func updateFavs(_ userId: String, _ coinId: String) {
        guard let url = URL(string: "http://localhost:8080/api/v1/users/\(userId)/favfolio/") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "coinid": "\(coinId)"
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                return
            }
            self.loadUser()
        }
        task.resume()
    }

}
