import Foundation

class BaseUserService {
    @Published var cryptoFavs: [CryptoServerModel] = []
    @Published var cryptoPortfolio: [CryptoServerModel] = []
    @Published var cryptoWallet: [CryptoServerModel] = []
    @Published var stockFavs: [StockServerModel] = []
    @Published var stockPortfolio: [StockServerModel] = []
    @Published var stockWallet: [StockServerModel] = []
    @Published var subscriptions: [String] = []
    @Published var userList: [UserModel] = []
    @Published var subsLogList: [UserLog] = []
    @Published var isSignedIn = false
    @Published var accountVisible = false
    @Published var loginError = false
    @Published var registerError = false
    @Published var registered = false
}

protocol UserService: BaseUserService {
    func signOut()
    func signin(_ email: String, _ password: String)
    func register(_ email: String, _ password: String)
    func userReload(_ origin: String)
    func getUserId() -> String
    func getUserEmail() -> String
    func loadUser()
    func registerUser(_ apikey: String, _ userId: String, _ email: String)
    func updateWallet(_ coinToSell: String, _ coinToBuy: String, _ sellAmount: Double, _ buyAmount: Double)
    func updatePortfolio(_ coinId: String, _ count: Double, _ buytotal: Double)
    func updateFavs(_ coinId: String)
    func updateStockWallet(_ symbolToSell: String, _ symbolToBuy: String, _ sellAmount: Double, _ buyAmount: Double)
    func updateStockPortfolio(_ symbol: String, _ count: Double, _ buytotal: Double)
    func updateStockFavs(_ symbol: String)
    func subscribe(_ subId: String)
    func changeVisibility()
    func loadUsers()
    func loadUserActionLogs()
}
