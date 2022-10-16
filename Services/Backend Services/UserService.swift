import Combine
import Foundation
import FirebaseAuth

struct Favfolio: Codable {
    let id: Int
    let coinid: String
    let count: Double
    let buytotal: Double?
}

class UserService {
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
        DispatchQueue.main.async {
            self.isSignedIn = false
        }
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
                    self.loadUser(apikey: idToken ?? "error", userID: self.auth.currentUser!.uid)
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
                        self.loadUser(apikey: idToken ?? "error", userID: self.auth.currentUser!.uid)
                        //    self.communityService.loadCommunities(apikey: idToken ?? "error")
                    }
                }
            }
        })
    }

    // MARK: - User data, account
    func loadUser(apikey: String, userID: String) {
        print("lefutott")
        guard let url = URL(string: "http://localhost:\(port)/api/v1/users/\(userID)")
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
                self?.cryptoFavs = returnedUser.favfolio
                self?.cryptoPortfolio = returnedUser.portfolio
                self?.cryptoWallet = returnedUser.wallet
                self?.stockFavs = returnedUser.stockfavfolio
                self?.stockPortfolio = returnedUser.stockportfolio
                self?.stockWallet = returnedUser.stockwallet
                self?.userSub?.cancel()
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
            self.loadUser(apikey: apikey, userID: userId)
        }
        task.resume()
    }

    // MARK: - Crypto portfolio
    func updateWallet(_ apikey: String, _ userId: String, _ coinToSell: String, _ coinToBuy: String, _ sellAmount: Double, _ buyAmount: Double) {
        guard let url = URL(string: "http://localhost:\(port)/api/v1/users/\(userId)/wallet/") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
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
            self.loadUser(apikey: apikey, userID: userId)
        }
        task.resume()
    }

    func updatePortfolio(_ apikey: String, _ userId: String, _ coinId: String, _ count: Double, _ buytotal: Double) {
        guard let url = URL(string: "http://localhost:\(port)/api/v1/users/\(userId)/portfolio/") else {
            return
        }

        var request = URLRequest(url: url) /* 1 */
        request.httpMethod = "PUT" /* 2 */
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization") /* 3 */
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
            self.loadUser(apikey: apikey, userID: userId) /* 6 */
        }
        task.resume()
    }

    func updateFavs(_ apikey: String, _ userId: String, _ coinId: String) {
        guard let url = URL(string: "http://localhost:\(port)/api/v1/users/\(userId)/favfolio/") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        let body: [String: AnyHashable] = [
            "id": "\(coinId)"
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

    func updateStockWallet(_ apikey: String, _ userId: String, _ symbolToSell: String, _ symbolToBuy: String, _ sellAmount: Double, _ buyAmount: Double) {
        guard let url = URL(string: "http://localhost:\(port)/api/v1/users/\(userId)/stockwallet/") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
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
            self.loadUser(apikey: apikey, userID: userId)
        }
        task.resume()
    }

    func updateStockPortfolio(_ apikey: String, _ userId: String, _ symbol: String, _ count: Double, _ buytotal: Double) {
        guard let url = URL(string: "http://localhost:\(port)/api/v1/users/\(userId)/stockportfolio/") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
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
            self.loadUser(apikey: apikey, userID: userId)
        }
        task.resume()
    }

    func updateStockFavs(_ apikey: String, _ userId: String, _ symbol: String) {
        guard let url = URL(string: "http://localhost:\(port)/api/v1/users/\(userId)/stockfavfolio/") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        let body: [String: AnyHashable] = [
            "id": "\(symbol)"
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
}
