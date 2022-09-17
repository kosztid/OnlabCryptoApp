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
        print("fetchUsers")
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
                self?.favs = returnedUser.favfolio
                self?.portfolio = returnedUser.portfolio
                self?.wallet = returnedUser.wallet
                self?.userSub?.cancel()
            }
    }
}
