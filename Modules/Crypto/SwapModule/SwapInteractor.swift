import Foundation
import Resolver
import SwiftUI

class SwapInteractor {
    private var userService: UserService
    private var coinService: CoinService
    private var communityService: CommunityService

    init() {
        coinService = CoinService()
        userService = Resolver.resolve()
        communityService = Resolver.resolve()
    }

    func loadService() {
        userService.userReload("swapmodule")
    }

    func selected(coin: String) -> CoinModel {
        // swiftlint:disable:next line_length
        return coinService.coins.first {$0.id == coin} ?? CoinModel(id: "btc", symbol: "btc", name: "btc", image: "btc", currentPrice: 10, marketCap: 10, marketCapRank: 10, fullyDilutedValuation: 10, totalVolume: 10, high24H: 10, low24H: 10, priceChange24H: 10, priceChangePercentage24H: 10, marketCapChange24H: 10, marketCapChangePercentage24H: 10, circulatingSupply: 10, totalSupply: 10, maxSupply: 10, ath: 10, athChangePercentage: 10, athDate: "btc", atl: 10, atlChangePercentage: 10, atlDate: "btc", lastUpdated: "btc", sparklineIn7D: nil, priceChangePercentage24HInCurrency: 10)
    }

    func getCoins() -> Published<[CoinModel]>.Publisher {
        coinService.$coins
    }

    func swap(_ cointosell: String, _ sellamount: Double, _ cointobuy: String, _ buyamount: Double) {
        if cointosell == Strings.error || cointobuy == Strings.error {
        } else {
            let ownedamountfromsell: Double = userService.cryptoWallet[userService.cryptoWallet.firstIndex { $0.coinid == cointosell }!].count
            print(ownedamountfromsell)
            print(sellamount)
            if ownedamountfromsell >= sellamount {
                print("lefut")
                userService.updateWallet(cointosell, cointobuy, sellamount, buyamount)
                sendTradeHistory(id: "1", cointosell: cointosell, sellamount: sellamount, cointobuy: cointobuy, buyamount: buyamount)
            }
        }
    }

    func ownedamount(coin: CoinModel) -> Double {
        let idx = userService.cryptoWallet.firstIndex { $0.coinid == coin.id }
        if userService.cryptoWallet.contains(where: { $0.coinid == coin.id }) {
            return userService.cryptoWallet[idx!].count
        } else {
            return 0.0
        }
    }

    func isOwned(coin: CoinModel) -> Bool {
        if userService.cryptoWallet.contains(where: { $0.coinid == coin.id }) {
            return true
        } else {
            return false
        }
    }

    func getOwnedCoins() -> Published<[CryptoServerModel]>.Publisher {
        userService.$cryptoWallet
    }

    func getAccountInfo() -> String {
        userService.getUserId()
    }

    func getAccountEmail() -> String {
        userService.getUserEmail()
    }

//    swiftlint:disable:next function_parameter_count
    func sendTradeHistory(id: String, cointosell: String, sellamount: Double, cointobuy: String, buyamount: Double) {
        let dateFormatter = DateFormatter()
        let historyId = "AB78B2E3-4CE1-401C-9187-824387846365"
        let mail = userService.getUserEmail()
        dateFormatter.dateFormat = Strings.dateformat
        let date = dateFormatter.string(from: Date())
        let sellprice = self.selected(coin: cointosell).currentPrice
        let buyprice = self.selected(coin: cointobuy).currentPrice
        let msgString = "\(mail) Bought \(buyamount) \(cointobuy) (current price \(buyprice)) for \(sellamount) \(cointosell) (current price \(sellprice)) "
        let message = MessageModel(id: 1, sender: self.getAccountInfo(), senderemail: self.getAccountEmail(), message: msgString, time: date, image: false)
        communityService.sendMessage(historyId, message)
    }
}
