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
final class DataModel: ObservableObject{
    @Published var lastmessageId = ""
    let auth : Auth
    let storage: Storage
    @Published var isSignedIn = false
    @Published var loginerror = false
    @Published var registererror = false
    @Published var IsnotificationViewed = false
    @Published var registered = false
    @Published var coins: [CoinModel] = []
    @Published var news = News(status: nil, totalResults: nil, articles: nil)
    //@Published var coindetail: [CoinDetailModel] = []
    @Published var communities: [MessageGroupModel] = []
    private let datadownloader = DataDownloader()
    @Published var heldcoins: [CoinDataFirebaseModel] = []
    @Published var favcoins: [CoinDataFirebaseModel] = []
    @Published var ownedcoins: [CoinDataFirebaseModel] = []
    @Published var buyorsell : String = "none"
    @Published var coin1 : String = "ethereum"
    @Published var coin2 : String = "tether"
    @Published var coinstobuy : Double = 0
    @Published var coinstosell : Double = 0
    @Published var events: [ChangeDataModel] = []
    //private var datadownloaderfordetail = SingleDataDownloader(coinid: "ethereum")
   // var singlecoinsub: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    @Published var selection: String
    
    init(){
        self.selection = "portfolio"
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        addSub()
        communitiesPullFromDB()
        userreload()
        
    }
    
    
    
    func addSub(){
        datadownloader.$coins
            .sink{ [weak self] (datareceived) in self?.coins = datareceived}
            .store(in: &cancellables)
        
        datadownloader.$news
            .sink{ [weak self] (datareceived) in self?.news = datareceived}
            .store(in: &cancellables)
    }
    func addFavCoin(coinid: String){
        let db = Firestore.firestore()
        let user = self.auth.currentUser?.uid ?? ""
        if self.favcoins.filter({ $0.coinid == coinid }).isEmpty == false {
            let firebaseid = self.favcoins[favcoins.firstIndex(where: { $0.coinid == coinid })!].firebaseid
            DispatchQueue.main.async{
                db.collection("users").document(user).collection("favfolio").document(firebaseid).delete { error in
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
        else {
            DispatchQueue.main.async {
                db.collection("users").document(user).collection("favfolio").addDocument(data: ["coinid":coinid,"count":0]){
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
    
    
    
    func favcoinPullFromDB(){
        let db = Firestore.firestore()
        let userid = self.auth.currentUser?.uid
        db.collection("users").document(userid!).collection("favfolio").addSnapshotListener { snapshot, error in
            if error == nil {
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        self.favcoins = snapshot.documents.map { d in
                            return CoinDataFirebaseModel(firebaseid: d.documentID, coinid: d["coinid"] as? String ?? "", count: Double(d["count"] as? Double ?? 0), buytotal: Double(d["count"] as? Double ?? 0))
                        }
                    }
                    
                }
            }
            else {
                //error handling
            }
        }
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

    func addHolding(coinid: String,coincount: Double,currprice: Double){
        let db = Firestore.firestore()
        let user = self.auth.currentUser?.uid ?? ""
        if self.heldcoins.filter({ $0.coinid == coinid }).isEmpty == false {
            let dx = heldcoins.firstIndex(where: { $0.coinid == coinid })!
            let firebaseid = self.heldcoins[dx].firebaseid
            var holdingtotal = self.heldcoins[dx].buytotal
            let holdingcount = self.heldcoins[dx].count
            if holdingcount < coincount {
                holdingtotal += (coincount - holdingcount) * currprice
            } else {
                holdingtotal = holdingtotal * coincount / holdingcount
            }
            DispatchQueue.main.async {
                db.collection("users").document(user).collection("portfolio").document(firebaseid).setData([ "count": coincount, "buytotal":holdingtotal ], merge: true)
            }
        }
        else {
            DispatchQueue.main.async {
                db.collection("users").document(user).collection("portfolio").addDocument(data: ["coinid":coinid,"count":coincount,"buytotal":(coincount*currprice)]){
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
    
    func modifywallet(coinid: String,coincount: Double){
        let db = Firestore.firestore()
        let user = self.auth.currentUser?.uid ?? ""
        if self.ownedcoins.filter({ $0.coinid == coinid }).isEmpty == false {
            let dx = ownedcoins.firstIndex(where: { $0.coinid == coinid })!
            let firebaseid = self.ownedcoins[dx].firebaseid
            if coincount == 0 {
                DispatchQueue.main.async {
                    db.collection("users").document(user).collection("wallet").document(firebaseid).delete { error in
                        if error == nil {
                        }
                        else {
                        }
                        
                    }
                }
                
            } else {
                DispatchQueue.main.async {
                    db.collection("users").document(user).collection("wallet").document(firebaseid).setData(["count": coincount], merge: true)
                }
                
            }
        }
        else{
            DispatchQueue.main.async {
                db.collection("users").document(user).collection("wallet").addDocument(data: ["coinid":coinid,"count":coincount]){
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
    func walletPullFromDB(){
        let db = Firestore.firestore()
        let userid = self.auth.currentUser?.uid
        db.collection("users").document(userid!).collection("wallet").addSnapshotListener { snapshot, error in
            if error == nil {
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        self.ownedcoins = snapshot.documents.map { d in
                            return CoinDataFirebaseModel(firebaseid: d.documentID, coinid: d["coinid"] as? String ?? "", count: Double(d["count"] as? Double ?? 0),buytotal:0)
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
    
    func portfolioPullFromDB(){
        let db = Firestore.firestore()
        let userid = self.auth.currentUser?.uid
        db.collection("users").document(userid!).collection("portfolio").addSnapshotListener { snapshot, error in
            if error == nil {
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        self.heldcoins = snapshot.documents.map { d in
                            return CoinDataFirebaseModel(firebaseid: d.documentID, coinid: d["coinid"] as? String ?? "", count: Double(d["count"] as? Double ?? 0),buytotal: Double(d["buytotal"] as? Double ?? 0))
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
    
    func addCommunityMember(id:String, member: String){
        let db = Firestore.firestore()
        let dx = communities.firstIndex(where: { $0.id == id })!
        if self.communities[dx].members.filter({ $0 == member }).isEmpty{
            DispatchQueue.main.async {
            db.collection("communities").document(id).collection("members").addDocument(data: ["member":member]){
                error in
                if error == nil {
                }
                else {
                    //error handling
                }
            }}
        }
    }
    
    func communitiesPullFromDB(){
        let db = Firestore.firestore()
        db.collection("communities").addSnapshotListener { snapshot, error in
            if error == nil {
                if let snapshot = snapshot{
                        self.communities = snapshot.documents.map { d in
                            return MessageGroupModel(id: d.documentID, name: d["name"] as? String ?? "", messages: [], members: [], lastid: "")
                        }
                        for c in self.communities{
                            self.messagemembersPullFromDB(idtoget: c.id)
                            self.messagesPullFromDB(idtoget: c.id)
                        }
                }
            }
            else {
                //error handling
            }
        }
        
    }
    
    func messagemembersPullFromDB(idtoget: String){
        var members: [String] = []
        let db = Firestore.firestore()
        db.collection("communities").document(idtoget).collection("members").addSnapshotListener { snapshot, error in
            if error == nil {
                if let snapshot = snapshot{
                        members = snapshot.documents.map { d in
                            return String(d["member"] as? String ?? "Unknown")
                        }
                    if let i = self.communities.firstIndex(where: {$0.id == idtoget}) {
                        self.communities[i].members = members
                        //print("loaded")
                    }
                }
            }
            else {
                //error handling
            }
        }
        
    }
    
    func messagesPullFromDB(idtoget: String){
        var messages: [MessageModel] = []
        let db = Firestore.firestore()
        db.collection("communities").document(idtoget).collection("messages").addSnapshotListener { snapshot, error in
            if error == nil {
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        messages = snapshot.documents.map { d in
                            return MessageModel(id: d.documentID,sender: d["sender"] as? String ?? "Unknown",senderemail: d["senderemail"] as? String ?? "nomail", message: d["message"] as? String ?? "", time: d["time"] as? String ?? "2000-02-02 10:00:00", image: d["image"] as? Bool ?? false)
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
    /*
    func getAccountInfo() -> String{
        return self.auth.currentUser?.uid ?? "nouser"
    }*/
    func addCommunity(name: String){
        let db = Firestore.firestore()
        db.collection("communities").addDocument(data: ["name":name]){
            error in
            if error == nil{
                //good
            } else{
                //error handling
            }
        }
    }
    func sendMessage(id: String, message: MessageModel){
        let db = Firestore.firestore()
        let sender = self.auth.currentUser?.uid ?? message.sender
        db.collection("communities").document(id).collection("messages").addDocument(data: ["sender":sender,"message":message.message,"senderemail":message.senderemail,"time":message.time,"image":message.image]){
            error in
            if error == nil {
            }
            else {
                //error handling
            }
        }
    }
    
    func loadNotification(){
        if isSignedIn{
            let db = Firestore.firestore()
            let userid = self.auth.currentUser?.uid
            db.collection("events").document(userid!).collection("events").addSnapshotListener { snapshot, error in
                if error == nil {
                    if let snapshot = snapshot{
                        DispatchQueue.main.async {
                            self.events = snapshot.documents.map {
                                d in
                                return ChangeDataModel(id: d["id"] as? String ?? "", coinid: d["coinid"] as? String ?? "", price: Double(d["price"] as? Double ?? 0))
                            }
                        }
                    }
                }
                else {
                    //error handling
                }
            }
        }
    }
    
    func saveNotification(){
        if isSignedIn {
            let db = Firestore.firestore()
            let userid = self.auth.currentUser?.uid
            if events.count == 0 {
                let notificationcoins = [ChangeDataModel(id: UUID().uuidString, coinid: "bitcoin", price: self.coins.first(where: {$0.id == "bitcoin"})?.currentPrice ?? 0),ChangeDataModel(id: UUID().uuidString, coinid: "ethereum", price: self.coins.first(where: {$0.id == "ethereum"})?.currentPrice ?? 0),ChangeDataModel(id: UUID().uuidString, coinid: "terra-luna", price: self.coins.first(where: {$0.id == "terra-luna"})?.currentPrice ?? 0)]
                
                for a in 0...notificationcoins.count-1{
                    DispatchQueue.main.async {
                        db.collection("events").document(userid!).collection("events").document(notificationcoins[a].id).setData(["id":notificationcoins[a].id, "coinid":notificationcoins[a].coinid, "price":notificationcoins[a].price], merge: true){ error in
                            if error == nil {
                            }
                            else {
                                //error handling
                            }
                        }
                    }
                }
            } else {
                for a in 0...events.count-1{
                    DispatchQueue.main.async {
                        db.collection("events").document(userid!).collection("events").document(self.events[a].id).setData(["id":self.events[a].id, "coinid":self.events[a].coinid, "price":self.events[a].price], merge: true){ error in
                            if error == nil {
                            }
                            else {
                                //error handling
                            }
                        }
                    }
                    
                }
            }
            
            
            
        }
        
    }
    
    func sendPhoto(image: UIImage, message: MessageModel, communityid: String){
        let id = UUID().uuidString
        let ref = storage.reference(withPath: id)
        guard let imagedata = image.jpegData(compressionQuality: 0.1) else {return}
        ref.putData(imagedata, metadata: nil){metadata, error in
            if error == nil{
                
            }
            else {
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
    
    
    func userreload(){
        auth.currentUser?.reload(completion: { (error) in
            if let error = error {
                print(String(describing: error))
            } else{
                DispatchQueue.main.async {
                    self.isSignedIn = true
                    let _ = print(self.auth.currentUser!.uid)
                    let _ = print(self.auth.currentUser!.email ?? "")
                    self.portfolioPullFromDB()
                    self.favcoinPullFromDB()
                    self.walletPullFromDB()
                    self.loadNotification()
                }
                
            }
        })
    }
    
    func signIn(email: String, password: String){
        auth.signIn(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                self.loginerror = true
                return
            }
            DispatchQueue.main.async {
                self.isSignedIn = true
                let _ = print(self.auth.currentUser!.uid)
                let _ = print(self.auth.currentUser!.email ?? "")
                self.portfolioPullFromDB()
                self.favcoinPullFromDB()
                self.walletPullFromDB()
                self.loadNotification()
            }
        }
    }
    
    func register(email: String, password: String){
        auth.createUser(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                self.registererror = true
                print("error creating user")
                return
            }
            self.registered = true
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
                    db.collection("events").document(id ?? "err").setData(["id": id ?? "err"]){
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
        
    }
    
    func signOut(){
        try?auth.signOut()
        DispatchQueue.main.async {
            self.isSignedIn = false
            self.heldcoins = []
            self.favcoins = []
            self.ownedcoins = []
            self.events = []
        }
    }
}
