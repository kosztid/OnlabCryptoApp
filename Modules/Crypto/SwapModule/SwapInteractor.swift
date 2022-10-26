import Foundation
import SwiftUI

class SwapInteractor {
    private var userService: UserService
    private var coinService: CoinService
    private var communityService: CommunityService

    init() {
        coinService = CoinService()
        userService = UserService()
        communityService = CommunityService()
    }

    func loadService() {
        userService.userReload("swapmodule")
    }

    func selected(coin: String) -> CoinModel {
        // swiftlint:disable:next line_length
        return coinService.coins.first(where: {$0.id == coin}) ?? CoinModel(id: "btc", symbol: "btc", name: "btc", image: "btc", currentPrice: 10, marketCap: 10, marketCapRank: 10, fullyDilutedValuation: 10, totalVolume: 10, high24H: 10, low24H: 10, priceChange24H: 10, priceChangePercentage24H: 10, marketCapChange24H: 10, marketCapChangePercentage24H: 10, circulatingSupply: 10, totalSupply: 10, maxSupply: 10, ath: 10, athChangePercentage: 10, athDate: "btc", atl: 10, atlChangePercentage: 10, atlDate: "btc", lastUpdated: "btc", sparklineIn7D: nil, priceChangePercentage24HInCurrency: 10)
    }

    func getCoins() -> Published<[CoinModel]>.Publisher {
        return coinService.$coins
    }

    func swap(cointosell: String, sellamount: Double, cointobuy: String, buyamount: Double) {
        let ownedamountfromsell: Double = userService.cryptoWallet[userService.cryptoWallet.firstIndex(where: { $0.coinid == cointosell })!].count
        if ownedamountfromsell > sellamount {
            userService.updateWallet(cointosell, cointobuy, sellamount, buyamount)
            sendTradeHistory(id: "1", cointosell: cointosell, sellamount: sellamount, cointobuy: cointobuy, buyamount: buyamount)
        }
    }

    func ownedamount(coin: CoinModel) -> Double {
        let idx = userService.cryptoWallet.firstIndex(where: { $0.coinid == coin.id })
        if userService.cryptoWallet.filter({ $0.coinid == coin.id }).isEmpty == false {
            return userService.cryptoWallet[idx!].count
        } else {
            return 0.0
        }
    }

    func isOwned(coin: CoinModel) -> Bool {
        if userService.cryptoWallet.filter({ $0.coinid == coin.id }).isEmpty == false {
            return true
        } else {
            return false
        }
    }


    func getOwnedCoins() -> Published<[CryptoServerModel]>.Publisher {
        return userService.$cryptoWallet
    }

    func getAccountInfo() -> String {
        return userService.getUserId()
    }

    func getAccountEmail() -> String {
        return userService.getUserEmail()
    }

    func sendTradeHistory(id: String, cointosell: String, sellamount: Double, cointobuy: String, buyamount: Double) {
        let dateFormatter = DateFormatter()
        let historyId = "AB78B2E3-4CE1-401C-9187-824387846365"
        let email = userService.getUserEmail() 
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let stringdate = dateFormatter.string(from: Date())
        let cointosellprice = self.selected(coin: cointosell).currentPrice
        let cointobuyprice = self.selected(coin: cointobuy).currentPrice
        let messagestring = "\(email) Bought \(buyamount) \(cointobuy) (current price \(cointobuyprice)) for \(sellamount) \(cointosell) (current price \(cointosellprice)) "
        let message = MessageModel(id: 1, sender: self.getAccountInfo(), senderemail: self.getAccountEmail(), message: messagestring, time: stringdate, image: false)
        communityService.sendMessage(historyId, message)
    }
}
