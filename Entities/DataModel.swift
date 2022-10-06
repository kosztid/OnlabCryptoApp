//
//  DataModel.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 26..
//

import Foundation
import SwiftUI
import Combine
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

/*
 URL for coins https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=200&page=1&sparkline=true&price_change_percentage=24h
 pl:
 {
 "id": "bitcoin",
 "symbol": "btc",
 "name": "Bitcoin",
 "image": "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
 "current_price": 38929,
 "market_cap": 737608692589,
 "market_cap_rank": 1,
 "fully_diluted_valuation": 816598025132,
 "total_volume": 20918136482,
 "high_24h": 39877,
 "low_24h": 38486,
 "price_change_24h": 143.98,
 "price_change_percentage_24h": 0.37121,
 "market_cap_change_24h": 6107947597,
 "market_cap_change_percentage_24h": 0.83499,
 "circulating_supply": 18968675,
 "total_supply": 21000000,
 "max_supply": 21000000,
 "ath": 69045,
 "ath_change_percentage": -43.68057,
 "ath_date": "2021-11-10T14:24:11.849Z",
 "atl": 67.81,
 "atl_change_percentage": 57245.80991,
 "atl_date": "2013-07-06T00:00:00.000Z",
 "roi": null,
 "last_updated": "2022-02-26T10:05:10.524Z",
 "sparkline_in_7d": {
 "price": [
 40289.25829858139,
 39429.4575868969
 ]
 },
 "price_change_percentage_24h_in_currency": 0.3712147223907504
 }
 
 */
final class DataModel: ObservableObject {
    @Published var lastmessageId = ""
    let auth : Auth
    let storage: Storage
    @Published var currencyType = CurrencyTypes.crypto
    @Published var isSignedIn = false
    @Published var loginerror = false
    @Published var registererror = false
    @Published var isNotificationViewed = false
    @Published var registered = false
    @Published var coins: [CoinModel] = []
    @Published var stockNews = News(status: nil, totalResults: nil, articles: nil)
    @Published var cryptoNews = News(status: nil, totalResults: nil, articles: nil)
    @Published var communities: [MessageGroupModel] = []
    private let datadownloader = DataDownloader()
    private let communityService = CommunityService()
    private let apiService = UserService()
    @Published var heldcoins: [CryptoServerModel] = []
    @Published var favcoins: [CryptoServerModel] = []
    @Published var ownedcoins: [CryptoServerModel] = []
    @Published var heldStocks: [StockServerModel] = []
    @Published var favStocks: [StockServerModel] = []
    @Published var ownedStocks: [StockServerModel] = []
    @Published var stocks: [StockListItem] = []
    @Published var buyorsell = "none"
    @Published var coin1 = "ethereum"
    @Published var coin2 = "tether"
    @Published var coinstobuy = 0.0
    @Published var coinstosell = 0.0
    @Published var events: [ChangeDataModel] = []
    private var cancellables = Set<AnyCancellable>()
    @Published var selection: String

    init() {
        self.selection = "portfolio"
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        addSub()
        userreload()

    }
    func addSub() {
        datadownloader.$coins
            .sink { [weak self] (datareceived) in self?.coins = datareceived}
            .store(in: &cancellables)

        datadownloader.$stocks
            .sink { [weak self] (datareceived) in self?.stocks = datareceived}
            .store(in: &cancellables)

        datadownloader.$news
            .sink { [weak self] (datareceived) in self?.cryptoNews = datareceived}
            .store(in: &cancellables)

        datadownloader.$stockNews
            .sink { [weak self] (datareceived) in self?.stockNews = datareceived}
            .store(in: &cancellables)

        apiService.$cryptoFavs
            .sink { [weak self] (datareceived) in self?.favcoins = datareceived}
            .store(in: &cancellables)
        apiService.$cryptoPortfolio
            .sink { [weak self] (datareceived) in self?.heldcoins = datareceived}
            .store(in: &cancellables)
        apiService.$cryptoWallet
            .sink { [weak self] (datareceived) in self?.ownedcoins = datareceived}
            .store(in: &cancellables)

        apiService.$stockFavs
            .sink { [weak self] (datareceived) in self?.favStocks = datareceived}
            .store(in: &cancellables)
        apiService.$stockPortfolio
            .sink { [weak self] (datareceived) in self?.heldStocks = datareceived}
            .store(in: &cancellables)
        apiService.$stockWallet
            .sink { [weak self] (datareceived) in self?.ownedStocks = datareceived}
            .store(in: &cancellables)
        
        communityService.$communities
            .sink { [weak self] (datareceived) in self?.communities = datareceived}
            .store(in: &cancellables)
    }
    func addFavCoin(coinid: String) {
        let currentUser = self.auth.currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.apiService.updateFavs(idToken ?? "error", self.auth.currentUser!.uid, coinid)
        }
        favcoinPullFromDB()
    }
    func addFavStock(symbol: String) {
        let currentUser = self.auth.currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            // TODO: fav api stock
        }
        favcoinPullFromDB()
    }
    func favcoinPullFromDB() {
        DispatchQueue.main.async {
            self.favcoins = self.apiService.cryptoFavs
        }
    }

    func removeCoin(cointoremove: CoinModel) {
        let currentUser = self.auth.currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("token:\(idToken ?? "error")")
            self.apiService.updatePortfolio(idToken ?? "error", self.auth.currentUser!.uid, cointoremove.id, 0.0, 0.0)
        }

    }

    func addHolding(coinid: String, coincount: Double, currprice: Double) {
        let currentUser = self.auth.currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("token:\(idToken ?? "error")")
            self.apiService.updatePortfolio(idToken ?? "error", self.auth.currentUser!.uid, coinid, coincount, currprice)
        }
    }

    func modifywallet( _ coinToSell: String,_ coinToBuy: String, _ sellAmount: Double, _ buyAmount: Double) {
        let currentUser = self.auth.currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        self.apiService.updateWallet(idToken ?? "error", self.auth.currentUser!.uid, coinToSell, coinToBuy, sellAmount, buyAmount)
        }
    }
    func walletPullFromDB() {
        DispatchQueue.main.async {
            self.ownedcoins = self.apiService.cryptoWallet
        }
    }

    func portfolioPullFromDB() {
        DispatchQueue.main.async {
            self.heldcoins = self.apiService.cryptoPortfolio
        }
    }
    func addCommunityMember(id: String, member: String) {
        let database = Firestore.firestore()
        let index = communities.firstIndex(where: { $0.id == id })!
        if self.communities[index].members.filter({ $0 == member }).isEmpty {
            DispatchQueue.main.async {
                database.collection("communities").document(id).collection("members").addDocument(data: ["member": member]) { error in
                    if error == nil {
                    } else {
                        // error handling
                    }
                }}
        }
    }
    func communitiesPullFromDB() {
    }

    func messagemembersPullFromDB(idtoget: String) {
        var members: [String] = []
        let database = Firestore.firestore()
        database.collection("communities").document(idtoget).collection("members").addSnapshotListener { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    members = snapshot.documents.map { data in
                        return String(data["member"] as? String ?? "Unknown")
                    }
                    if let index = self.communities.firstIndex(where: {$0.id == idtoget}) {
                        self.communities[index].members = members
                    }
                }
            } else {
                // error handling
            }
        }
    }

    func messagesPullFromDB(idtoget: String) {
    }
    func addCommunity(name: String) {
        self.auth.currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.communityService.addCommunity(idToken ?? "error", name)
        }
    }
    func sendMessage(id: String, message: MessageModel) {
        let sender = self.auth.currentUser?.uid ?? message.sender
        let variedMessage = MessageModel(id: message.id, sender: sender, senderemail: message.senderemail, message: message.message, time: message.time, image: message.image)
        self.auth.currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("message1")
            self.communityService.sendMessage(idToken ?? "error", id, variedMessage)
        }

    }

    func loadNotification() {
        if isSignedIn {
            let database = Firestore.firestore()
            let userid = self.auth.currentUser?.uid
            database.collection("events").document(userid!).collection("events").addSnapshotListener { snapshot, error in
                if error == nil {
                    if let snapshot = snapshot {
                        DispatchQueue.main.async {
                            self.events = snapshot.documents.map { data in
                                return ChangeDataModel(id: data["id"] as? String ?? "", coinid: data["coinid"] as? String ?? "", price: Double(data["price"] as? Double ?? 0))
                            }
                        }
                    }
                } else {
                    // error handling
                }
            }
        }
    }

    func saveNotification() {
        if isSignedIn {
            let database = Firestore.firestore()
            let userid = self.auth.currentUser?.uid
            if events.count == 0 {
                // swiftlint:disable:next line_length
                let notificationcoins = [ChangeDataModel(id: UUID().uuidString, coinid: "bitcoin", price: self.coins.first(where: {$0.id == "bitcoin"})?.currentPrice ?? 0),ChangeDataModel(id: UUID().uuidString, coinid: "ethereum", price: self.coins.first(where: {$0.id == "ethereum"})?.currentPrice ?? 0),ChangeDataModel(id: UUID().uuidString, coinid: "terra-luna", price: self.coins.first(where: {$0.id == "terra-luna"})?.currentPrice ?? 0)]
                for coinid in 0...notificationcoins.count-1 {
                    DispatchQueue.main.async {
                        // swiftlint:disable:next line_length
                        database.collection("events").document(userid!).collection("events").document(notificationcoins[coinid].id).setData(["id":notificationcoins[coinid].id, "coinid":notificationcoins[coinid].coinid, "price": notificationcoins[coinid].price], merge: true){ error in
                            if error == nil {
                            } else {
                                // error handling
                            }
                        }
                    }
                }
            } else {
                for coinid in 0...events.count-1 {
                    DispatchQueue.main.async {
                        // swiftlint:disable:next line_length
                        database.collection("events").document(userid!).collection("events").document(self.events[coinid].id).setData(["id": self.events[coinid].id, "coinid": self.events[coinid].coinid, "price": self.coins.first(where: {$0.id == self.events[coinid].coinid})?.currentPrice ?? 0], merge: true) { error in
                            if error == nil {
                            } else {
                                // error handling
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    func sendPhoto(image: UIImage, message: MessageModel, communityid: String) {
        let id = UUID().uuidString
        let ref = storage.reference(withPath: id)
        guard let imagedata = image.jpegData(compressionQuality: 0.1) else {return}
        ref.putData(imagedata, metadata: nil) { _, error in
            if error == nil {
            } else {
                print(error!.localizedDescription)
            }
            ref.downloadURL {url, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                var messagewithurl = message
                messagewithurl.message = url?.absoluteString ?? "nolink"
                self.sendMessage(id: communityid, message: messagewithurl)

            }
        }
    }

    func userreload() {
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
                        self.apiService.loadUser(apikey: idToken ?? "error", userID: self.auth.currentUser!.uid)
                        self.communityService.loadCommunities(apikey: idToken ?? "error")
                    }
                }
            }
        })
    }

    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                self.loginerror = true
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
                    self.apiService.loadUser(apikey: idToken ?? "error", userID: self.auth.currentUser!.uid)
                    self.communityService.loadCommunities(apikey: idToken ?? "error")
                }
            }

        }
    }

    func register(email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                self.registererror = true
                print("error creating user")
                return
            }
            self.registered = true
            DispatchQueue.main.async {
                let database = Firestore.firestore()
                let currentUser = self.auth.currentUser
                let id = currentUser?.uid
                currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    self.apiService.registerUser(idToken ?? "error", id ?? "error", email)
                }
                database.collection("users").document(id ?? "err").setData(["email": email]) { error in
                    if error == nil {
                    } else {
                        // error handling
                    }
                    database.collection("events").document(id ?? "err").setData(["id": id ?? "err"]) {
                        error in
                        if error == nil {
                        } else {
                            // error handling
                        }
                    }
                }
            }
        }
    }

    func signOut() {
        try?auth.signOut()
        DispatchQueue.main.async {
            self.isSignedIn = false
            self.heldcoins = []
            self.favcoins = []
            self.ownedcoins = []
            self.events = []
            self.communities = []
        }
    }
}
