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
final class DataModel: ObservableObject{
    @Published var lastmessageId = ""
    let auth : Auth
    @Published var isSignedIn = false
    @Published var coins: [CoinModel] = []
    @Published var coindetail: [CoinDetailModel] = []
    @Published var communities: [MessageGroup] = []
    //@Published var coinimages: [UIImage] = []
    private let datadownloader = DataDownloader()
    //@Published var heldcoinid: [String] = []
   // @Published var heldcoins: [String] = []
    //@Published var heldcoinscount: [Double] = []
    @Published var heldcoins: [CoinDataFirebase] = []
    //private var datadownloaderfordetail = SingleDataDownloader(coinid: "ethereum")
   // var singlecoinsub: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        self.auth = Auth.auth()
        addSub()
        communitiesPullFromDB()
        self.signOut()
       // coins.append(CoinModel(id: "teszt", symbol: "teszt", name: "teszt", image: "teszt", currentPrice: 10, marketCap: 10, marketCapRank: 10, fullyDilutedValuation: 10, totalVolume: 10, high24H: 10, low24H: 10, priceChange24H: 10, priceChangePercentage24H: 10, marketCapChange24H: 10, marketCapChangePercentage24H: 10, circulatingSupply: 10, totalSupply: 10, maxSupply: 10, ath: 10, athChangePercentage: 10, athDate: "teszt", atl: 10, atlChangePercentage: 10, atlDate: "teszt", lastUpdated: "teszt", sparklineIn7D: SparklineIn7D(price: []), priceChangePercentage24HInCurrency: 10))
    }
    
    func addSub(){
        datadownloader.$coins
            .sink{ [weak self] (datareceived) in self?.coins = datareceived}
            .store(in: &cancellables)
                   
    }
    
    
    
    func removeCoin(cointoremove: CoinModel){
        //let index = heldcoins.firstIndex(where: { $0 == cointoremove.id })
        let firebaseid = self.heldcoins[heldcoins.firstIndex(where: { $0.coinid == cointoremove.id })!].firebaseid
        let db = Firestore.firestore()
        let userid = self.auth.currentUser?.uid
        DispatchQueue.main.async {
            db.collection("users").document(userid!).collection("portfolio").document(firebaseid).delete { error in
                if error == nil {
                  //  self.heldcoinid.remove(at: index!)
                   // self.heldcoins.remove(at: index!)
                   // self.heldcoinscount.remove(at: index!)
                }
                else {
                    //error handling
                }
                
            }
        }
    }
    
    func portfoliototal() -> Double {
        if heldcoins.count == 0 {
            return 0
        }
        var total: Double = 0
        for a in 0...(heldcoins.count-1) {
            let currentprice = coins.first(where: {$0.id == heldcoins[a].coinid})?.currentPrice ?? 0.0
            total += (heldcoins[a].count * currentprice)
        }
        return total
    }
    
    func addHolding(coinid: String,coincount: Double){
        let db = Firestore.firestore()
        let user = self.auth.currentUser?.uid ?? ""
        if self.heldcoins.filter({ $0.coinid == coinid }).isEmpty == false {
            let firebaseid = self.heldcoins[heldcoins.firstIndex(where: { $0.coinid == coinid })!].firebaseid
            db.collection("users").document(user).collection("portfolio").document(firebaseid).setData([ "count": coincount ], merge: true)
        }
        else {
            db.collection("users").document(user).collection("portfolio").addDocument(data: ["coinid":coinid,"count":coincount]){
                error in
                if error == nil {
                }
                else {
                    //error handling
                }
            }
        }
        
    }
    func portfolioPullFromDB(){
        let db = Firestore.firestore()
        let userid = self.auth.currentUser?.uid
        db.collection("users").document(userid!).collection("portfolio").addSnapshotListener { snapshot, error in
            if error == nil {
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        self.heldcoins = snapshot.documents.map { d in
                            return CoinDataFirebase(firebaseid: d.documentID, coinid: d["coinid"] as? String ?? "", count: Double(d["count"] as? Double ?? 0))
                           // MessageGroup(id: d.documentID, name: d["name"] as? String ?? "", messages: [], lastid: "")
                        }
                    }
                    
                }
            }
            else {
                //error handling
            }
        }
    }
    
    func communitiesPullFromDB(){
        let db = Firestore.firestore()
        db.collection("communities").getDocuments { snapshot, error in
            if error == nil {
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        self.communities = snapshot.documents.map { d in
                            return MessageGroup(id: d.documentID, name: d["name"] as? String ?? "", messages: [], lastid: "")
                        }
                        for c in self.communities{
                            
                            self.messagesPullFromDB(idtoget: c.id)
                        }
                    }
                    
                }
            }
            else {
                //error handling
            }
        }
        
    }
    
    func messagesPullFromDB(idtoget: String){
        var messages: [Message] = []
        let db = Firestore.firestore()
        db.collection("communities").document(idtoget).collection("messages").addSnapshotListener { snapshot, error in
            if error == nil {
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        messages = snapshot.documents.map { d in
                            return Message(id: d.documentID,sender: d["sender"] as? String ?? "Unknown", message: d["message"] as? String ?? "", time: d["time"] as? String ?? "2000-02-02 10:00:00", received: d["received"]  as? Bool ?? false )
                        }
                        
                        if let i = self.communities.firstIndex(where: {$0.id == idtoget}) {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            self.communities[i].messages = messages
                            self.communities[i].messages.sort {
                                dateFormatter.date(from: $0.time)! < dateFormatter.date(from: $1.time)!
                            }
                            if let id = self.communities[i].messages.last?.id {
                                self.communities[i].lastid = id
                            }
                        }
                    }
                    
                }
            }
            else {
                //error handling
            }
        }
        
    }
    
    func getAccountInfo() -> String{
        return self.auth.currentUser?.uid ?? "nouser"
    }
    
    func sendMessage(id: String, message: Message){
        let db = Firestore.firestore()
        let sender = self.auth.currentUser?.uid ?? message.sender
        db.collection("communities").document(id).collection("messages").addDocument(data: ["sender":sender,"message":message.message,"time":message.time,"received":false]){
            error in
            if error == nil {
            }
            else {
                //error handling
            }
        }
    }
    
    func signIn(email: String, password: String){
        auth.signIn(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                return
            }
            DispatchQueue.main.async {
                self.isSignedIn = true
                let _ = print(self.auth.currentUser!.uid)
                let _ = print(self.auth.currentUser!.email ?? "")
                self.portfolioPullFromDB()
            }
            
        }
    }
    
    func register(email: String, password: String){
        auth.createUser(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                print("error creating user")
                return
            }
            DispatchQueue.main.async {
                let db = Firestore.firestore()
                let id = self.auth.currentUser?.uid
                db.collection("users").document(id ?? "err").setData(["email": email]){
                    error in
                    if error == nil {
                    }
                    else {
                        //error handling
                    }
                }
            }
        }
        
    }
    
    func signOut(){
        try?auth.signOut()
        DispatchQueue.main.async {
            self.isSignedIn = false
            self.heldcoins = []
        }
    }
}
