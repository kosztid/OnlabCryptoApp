import Combine
import FirebaseAuth
import Foundation

struct Favfolio: Codable {
    let id: Int
    let coinid: String
    let count: Double
    let buytotal: Double?
}

//  swiftlint:disable:next type_body_length
final class SpringUserService: BaseUserService, UserService, ObservableObject {
    let port = "8090"

    let auth: Auth

    var userSub: AnyCancellable?
    var usersSub: AnyCancellable?
    var userLogsSub: AnyCancellable?

    override init() {
        self.auth = Auth.auth()
        super.init()
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
                    self.loadUserActionLogs()
                    self.loadUsers()
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

    func userReload(_ origin: String = "Basic") {
        if Auth.auth().currentUser?.uid != nil {
            // swiftlint:disable:next trailing_closure
            auth.currentUser?.reload(completion: { error in
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
                            print(origin)
                            print(idToken)
                            self.loadUser()
                            self.loadUserActionLogs()
                            //    self.communityService.loadCommunities(apikey: idToken ?? "error")
                        }
                    }
                }
            })
        } else {
            print("else ág")
            DispatchQueue.main.async {
                self.isSignedIn = false
                self.subsLogList = []
                self.subscriptions = []
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
        auth.currentUser?.uid ?? "nouser"
    }

    func getUserEmail() -> String {
        auth.currentUser?.email ?? "nomail"
    }

    // MARK: - User data, account
    // swiftlint:disable:next function_body_length
    func loadUser() {
        // swiftlint:disable:next closure_body_length
        self.auth.currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            let apikey = idToken ?? "error"
            let userId = self.auth.currentUser?.uid ?? ""
            guard let url = URL(string: "http://localhost:\(self.port)/api/v1/users/\(userId)")
            else {
                return
            }

            var request = URLRequest(url: url)
            request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            self.userSub = URLSession.shared.dataTaskPublisher(for: request)
                .subscribe(on: DispatchQueue.global(qos: .default))
                .tryMap { output -> Data in
                    guard let response = output.response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
                        throw URLError(.badServerResponse)
                    }
                    return output.data
                }
                .receive(on: DispatchQueue.main)
                .decode(type: UserModel.self, decoder: JSONDecoder())
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                } receiveValue: { [weak self] returnedUser in
                    self?.accountVisible = returnedUser.visibility
                    self?.subscriptions = returnedUser.subscriptions
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
            let userId = self.auth.currentUser?.uid ?? ""
            guard let url = URL(string: "http://localhost:\(self.port)/api/v1/users/\(userId)/wallet/") else {
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
            let userId = self.auth.currentUser?.uid ?? ""
            guard let url = URL(string: "http://localhost:\(self.port)/api/v1/users/\(userId)/portfolio/") else {
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
            let userId = self.auth.currentUser?.uid ?? ""
            guard let url = URL(string: "http://localhost:\(self.port)/api/v1/users/\(userId)/favfolio/") else {
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
            let userId = self.auth.currentUser?.uid ?? ""
            guard let url = URL(string: "http://localhost:\(self.port)/api/v1/users/\(userId)/stockwallet/") else {
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
            let userId = self.auth.currentUser?.uid ?? ""
            guard let url = URL(string: "http://localhost:\(self.port)/api/v1/users/\(userId)/stockportfolio/") else {
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
            let userId = self.auth.currentUser?.uid ?? ""
            guard let url = URL(string: "http://localhost:\(self.port)/api/v1/users/\(userId)/stockfavfolio/") else {
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

    func subscribe(_ subId: String) {
        self.auth.currentUser?.getIDTokenForcingRefresh(true) { apikey, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            let userId = self.auth.currentUser?.uid ?? ""
            guard let url = URL(string: "http://localhost:\(self.port)/api/v1/users/\(userId)/subscribe/\(subId)") else {
                return
            }

            let token = apikey ?? "error"

            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            let task = URLSession.shared.dataTask(with: request) { _, _, error in
                guard error == nil else {
                    return
                }
                if self.subscriptions.contains(subId) {
                    self.subscriptions.removeAll {$0 == subId}
                } else {
                    self.subscriptions.append(subId)
                }
                self.loadUser()
                self.loadUserActionLogs()
            }
            task.resume()
        }
    }

    func changeVisibility() {
        self.auth.currentUser?.getIDTokenForcingRefresh(true) { apikey, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            let userId = self.auth.currentUser?.uid ?? ""
            guard let url = URL(string: "http://localhost:\(self.port)/api/v1/users/\(userId)/changeVisibility") else {
                return
            }

            let token = apikey ?? "error"

            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            let task = URLSession.shared.dataTask(with: request) { _, _, error in
                guard error == nil else {
                    return
                }
                self.loadUser()
            }
            task.resume()
        }
    }
    func loadUsers() {
        self.auth.currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            let apikey = idToken ?? "error"
            guard let url = URL(string: "http://localhost:\(self.port)/api/v1/users")
            else {
                return
            }

            var request = URLRequest(url: url)
            request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            self.usersSub = URLSession.shared.dataTaskPublisher(for: request)
                .subscribe(on: DispatchQueue.global(qos: .default))
                .tryMap { output -> Data in
                    guard let response = output.response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
                        throw URLError(.badServerResponse)
                    }
                    return output.data
                }
                .receive(on: DispatchQueue.main)
                .decode(type: [UserModel].self, decoder: JSONDecoder())
                .sink {completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                } receiveValue: { [weak self] returnedUsers in
                    print(returnedUsers)
                    self?.userList = returnedUsers.filter {$0.id != self?.auth.currentUser!.uid}
                    self?.usersSub?.cancel()
                }
        }
    }
    // swiftlint:disable:next function_body_length
    func loadUserActionLogs() {
        // swiftlint:disable:next closure_body_length
        self.auth.currentUser?.getIDTokenForcingRefresh(true) { apikey, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            let token = apikey ?? ""
            let userId = self.auth.currentUser?.uid ?? ""
            guard let url = URL(string: "http://localhost:\(self.port)/api/v1/users/\(userId)/actionsList")
            else {
                return
            }
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            self.userLogsSub = URLSession.shared.dataTaskPublisher(for: request)
                .subscribe(on: DispatchQueue.global(qos: .default))
                .tryMap { output -> Data in
                    guard let response = output.response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
                        throw URLError(.badServerResponse)
                    }
                    return output.data
                }
                .receive(on: DispatchQueue.main)
                .decode(type: [UserLog].self, decoder: JSONDecoder())
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                } receiveValue: { [weak self] logs in
                    self?.subsLogList = logs
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = Strings.dateformat
                    self?.subsLogList.sort {
                        dateFormatter.date(from: $0.time)! > dateFormatter.date(from: $1.time)!
                    }
                    self?.userLogsSub?.cancel()
                }
        }
    }
}
// swiftlint:disable:this file_length
