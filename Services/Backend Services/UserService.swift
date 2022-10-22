import Combine
import Foundation
import FirebaseAuth

struct Favfolio: Codable {
    let id: Int
    let coinid: String
    let count: Double
    let buytotal: Double?
}

final class UserService: ObservableObject {
    let port = "8090"
    @Published var cryptoFavs: [CryptoServerModel] = []
    @Published var cryptoPortfolio: [CryptoServerModel] = []
    @Published var cryptoWallet: [CryptoServerModel] = []
    @Published var stockFavs: [StockServerModel] = []
    @Published var stockPortfolio: [StockServerModel] = []
    @Published var stockWallet: [StockServerModel] = []
    @Published var isSignedIn = false
    @Published var loginError = false
    @Published var registerError = false
    @Published var registered = false
    let auth: Auth

    var userSub: AnyCancellable?

    init() {
        self.auth = Auth.auth()
    }

    func signOut() {
        try?auth.signOut()
        userReload()
    }

    func signin(_ email: String, _ password: String) {
        auth.signIn(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                self.loginError = true
                return
            }
            let currentUser = self.auth.currentUser
            currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                DispatchQueue.main.async {
                    self.isSignedIn = true
                    print(self.auth.currentUser!.uid)
                    print(self.auth.currentUser!.email ?? "")
                    self.loadUser()
                    //   self.communityService.loadCommunities(apikey: idToken ?? "error")
                }
            }

        }
    }

    func register(_ email: String, _ password: String) {
        auth.createUser(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                self.registerError = true
                print("error creating user")
                return
            }
            self.registered = true
            DispatchQueue.main.async {
                let currentUser = self.auth.currentUser
                let id = currentUser?.uid
                currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    self.registerUser(idToken ?? "error", id ?? "error", email)
                }
            }
        }
    }

    func userReload() {
        if Auth.auth().currentUser?.uid != nil {
            auth.currentUser?.reload(completion: { (error) in
                if let error = error {
                    print(String(describing: error))
                } else {
                    let currentUser = self.auth.currentUser
                    currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        DispatchQueue.main.async {
                            self.isSignedIn = true
                            print(self.auth.currentUser!.uid)
                            print(self.auth.currentUser!.email ?? "")
                            print(idToken)
                            self.loadUser()
                            //    self.communityService.loadCommunities(apikey: idToken ?? "error")
                        }
                    }
                }
            })
        } else {
            print("else ág")
            DispatchQueue.main.async {
                self.isSignedIn = false
                self.cryptoFavs = []
                self.cryptoPortfolio = []
                self.cryptoWallet = []
                self.stockFavs = []
                self.stockPortfolio = []
                self.stockWallet = []
            }
        }
    }

    func getUserId() -> String {
        return auth.currentUser?.uid ?? "nouser"
    }

    func getUserEmail() -> String {
        return auth.currentUser?.email ?? "nomail"
    }

    // MARK: - User data, account
    func loadUser() {
        self.auth.currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            let apikey = idToken ?? "error"
            guard let url = URL(string: "http://localhost:\(self.port)/api/v1/users/\(self.auth.currentUser!.uid)")
            else {
                return
            }

            var request = URLRequest(url: url)
            request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            self.userSub = URLSession.shared.dataTaskPublisher(for: request)
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
                    self?.cryptoFavs = returnedUser.favfolio
                    self?.cryptoPortfolio = returnedUser.portfolio
                    self?.cryptoWallet = returnedUser.wallet
                    self?.stockFavs = returnedUser.stockfavfolio
                    self?.stockPortfolio = returnedUser.stockportfolio
                    self?.stockWallet = returnedUser.stockwallet
                    self?.userSub?.cancel()
                }
        }
    }

    func registerUser(_ apikey: String, _ userId: String, _ email: String) {
        guard let url = URL(string: "http://localhost:\(port)/api/v1/users") else {
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
            self.loadUser()
        }
        task.resume()
    }

    // MARK: - Crypto portfolio
    func updateWallet(_ coinToSell: String, _ coinToBuy: String, _ sellAmount: Double, _ buyAmount: Double) {
        self.auth.currentUser?.getIDTokenForcingRefresh(true) { apikey, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let url = URL(string: "http://localhost:\(self.port)/api/v1/users/\(self.auth.currentUser!.uid)/wallet/") else {
                return
            }

            let token = apikey ?? "error"

            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let body: [String: AnyHashable] = [
                "toSell": "\(coinToSell)",
                "toBuy": "\(coinToBuy)",
                "sellAmount": sellAmount,
                "buyAmount": buyAmount
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
            let task = URLSession.shared.dataTask(with: request) { _, _, error in
                guard error == nil else {
                    return
                }
                self.loadUser()
            }
            task.resume()
        }
    }

    func updatePortfolio(_ coinId: String, _ count: Double, _ buytotal: Double) {
        self.auth.currentUser?.getIDTokenForcingRefresh(true) { apikey, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let url = URL(string: "http://localhost:\(self.port)/api/v1/users/\(self.auth.currentUser!.uid)/portfolio/") else {
                return
            }

            let token = apikey ?? "error"

            var request = URLRequest(url: url) /* 1 */
            request.httpMethod = "PUT" /* 2 */
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") /* 3 */
            request.setValue("application/json", forHTTPHeaderField: "Content-Type") /* 4 */
            let body: [String: AnyHashable] = [
                "id": "\(coinId)",
                "count": count,
                "buytotal": buytotal
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
            let task = URLSession.shared.dataTask(with: request) { _, _, error in /* 5 */
                guard error == nil else {
                    return
                }
                self.loadUser() /* 6 */
            }
            task.resume()
        }
    }

    func updateFavs(_ coinId: String) {
        self.auth.currentUser?.getIDTokenForcingRefresh(true) { apikey, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let url = URL(string: "http://localhost:\(self.port)/api/v1/users/\(self.auth.currentUser!.uid)/favfolio/") else {
                return
            }
            let token = apikey ?? "error"

            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let body: [String: AnyHashable] = [
                "id": "\(coinId)"
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
            let task = URLSession.shared.dataTask(with: request) { _, _, error in
                guard error == nil else {
                    return
                }
                self.loadUser()
            }
            task.resume()
        }
    }

    // MARK: - Stocks portfolio

    func updateStockWallet(_ symbolToSell: String, _ symbolToBuy: String, _ sellAmount: Double, _ buyAmount: Double) {
        self.auth.currentUser?.getIDTokenForcingRefresh(true) { apikey, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let url = URL(string: "http://localhost:\(self.port)/api/v1/users/\(self.auth.currentUser!.uid)/stockwallet/") else {
                return
            }

            let token = apikey ?? "error"

            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let body: [String: AnyHashable] = [
                "toSell": "\(symbolToSell)",
                "toBuy": "\(symbolToBuy)",
                "sellAmount": sellAmount,
                "buyAmount": buyAmount
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
            let task = URLSession.shared.dataTask(with: request) { _, _, error in
                guard error == nil else {
                    return
                }
                self.loadUser()
            }
            task.resume()
        }
    }

    func updateStockPortfolio(_ symbol: String, _ count: Double, _ buytotal: Double) {
        self.auth.currentUser?.getIDTokenForcingRefresh(true) { apikey, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let url = URL(string: "http://localhost:\(self.port)/api/v1/users/\(self.auth.currentUser!.uid)/stockportfolio/") else {
                return
            }

            let token = apikey ?? "error"

            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let body: [String: AnyHashable] = [
                "id": "\(symbol)",
                "count": count,
                "buytotal": buytotal
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
            let task = URLSession.shared.dataTask(with: request) { _, _, error in
                guard error == nil else {
                    return
                }
                self.loadUser()
            }
            task.resume()
        }
    }

    func updateStockFavs(_ symbol: String) {
        self.auth.currentUser?.getIDTokenForcingRefresh(true) { apikey, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let url = URL(string: "http://localhost:\(self.port)/api/v1/users/\(self.auth.currentUser!.uid)/stockfavfolio/") else {
                return
            }

            let token = apikey ?? "error"

            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            let body: [String: AnyHashable] = [
                "id": "\(symbol)"
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
            let task = URLSession.shared.dataTask(with: request) { _, _, error in
                guard error == nil else {
                    return
                }
                self.loadUser()
            }
            task.resume()
        }
    }
}
