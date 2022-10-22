import Foundation
import Combine
import SwiftUI

class SwapPresenter: ObservableObject {
    @Published var buyorsell = "none"

    // swiftlint:disable:next line_length
    @Published var coinmodel1 = CoinModel(id: "btc", symbol: "btc", name: "btc", image: "btc", currentPrice: 10, marketCap: 10, marketCapRank: 10, fullyDilutedValuation: 10, totalVolume: 10, high24H: 10, low24H: 10, priceChange24H: 10, priceChangePercentage24H: 10, marketCapChange24H: 10, marketCapChangePercentage24H: 10, circulatingSupply: 10, totalSupply: 10, maxSupply: 10, ath: 10, athChangePercentage: 10, athDate: "btc", atl: 10, atlChangePercentage: 10, atlDate: "btc", lastUpdated: "btc", sparklineIn7D: nil, priceChangePercentage24HInCurrency: 10)

    // swiftlint:disable:next line_length
    @Published var coinmodel2 = CoinModel(id: "btc", symbol: "btc", name: "btc", image: "btc", currentPrice: 10, marketCap: 10, marketCapRank: 10, fullyDilutedValuation: 10, totalVolume: 10, high24H: 10, low24H: 10, priceChange24H: 10, priceChangePercentage24H: 10, marketCapChange24H: 10, marketCapChangePercentage24H: 10, circulatingSupply: 10, totalSupply: 10, maxSupply: 10, ath: 10, athChangePercentage: 10, athDate: "btc", atl: 10, atlChangePercentage: 10, atlDate: "btc", lastUpdated: "btc", sparklineIn7D: nil, priceChangePercentage24HInCurrency: 10)
    @Published var coin1 = "ethereum"
    @Published var coin2 = "tether"
    @Published var coinstosell = 0.0
    @Published var coinstobuy = 0.0
    private let router = SwapRouter()
    let interactor: SwapInteractor
    @Published var coins: [CoinModel] = []
    @Published var ownedcoins: [CryptoServerModel] = []
    private var cancellables = Set<AnyCancellable>()
    @State private var showingAlert = false

    init(interactor: SwapInteractor) {
        self.interactor = interactor

        interactor.getCoins()
            .assign(to: \.coins, on: self)
            .store(in: &cancellables)

        interactor.getOwnedCoins()
            .assign(to: \.ownedcoins, on: self)
            .store(in: &cancellables)

        coinmodel1 = selected(coin: "ethereum")
        coinmodel2 = selected(coin: "tether")

    }

    func makeButtonForSelector(coin: String) -> some View {
        NavigationLink("Select coin", destination: router.makeSelectorView(presenter: self, coin: coin))
    }

    func setSellAmount() {
        let coin1 = coinmodel1
        print(coin1.currentPrice)
        let coin2 = coinmodel2
        print(coin2.currentPrice)
        let amount = coin2.currentPrice*coinstobuy
        print(amount)
        coinstosell = amount / coin1.currentPrice
    }

    func setBuyAmount() {
        let coin1 = coinmodel1
        print(coin1.currentPrice)
        let coin2 = coinmodel2
        print(coin2.currentPrice)
        let amount = coin1.currentPrice*coinstosell
        print(amount)
        coinstobuy = amount / coin2.currentPrice
    }

    func selected(coin: String) -> CoinModel {
        // swiftlint:disable:next line_length
        return coins.first(where: {$0.id == coin}) ?? CoinModel(id: "-", symbol: "-", name: "-", image: "btc", currentPrice: 10, marketCap: 10, marketCapRank: 10, fullyDilutedValuation: 10, totalVolume: 10, high24H: 10, low24H: 10, priceChange24H: 10, priceChangePercentage24H: 10, marketCapChange24H: 10, marketCapChangePercentage24H: 10, circulatingSupply: 10, totalSupply: 10, maxSupply: 10, ath: 10, athChangePercentage: 10, athDate: "btc", atl: 10, atlChangePercentage: 10, atlDate: "btc", lastUpdated: "btc", sparklineIn7D: nil, priceChangePercentage24HInCurrency: 10)
    }

    func swap() {
        interactor.swap(cointosell: coinmodel1.id, sellamount: coinstosell, cointobuy: coinmodel2.id, buyamount: coinstobuy)

        coinstosell = 0.0
        coinstobuy = 0.0
    }

    func getFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }
    func loadService() {
        interactor.loadService()
    }

    func setCoinstobuy(amount: Double) {
        interactor.setCoinstoBuy(amount: amount)
    }

    func setCoinstosell(amount: Double) {
        interactor.setCoinstoSell(amount: amount)
    }

    func setCoin1(coin1: String) {
        coinmodel1 = selected(coin: coin1)
        setBuyAmount()
    }

    func setCoin2(coin2: String) {
        coinmodel2 = selected(coin: coin2)
        setSellAmount()
    }

    func setBuyorSell(boolean: String) {
        interactor.setBuyorSell(boolean: boolean)
    }

    func ownedamount(coinid: String) -> Double {
        let idx = ownedcoins.firstIndex(where: { $0.coinid == coinid})
        if ownedcoins.filter({ $0.coinid == coinid }).isEmpty == false {
            return ownedcoins[idx!].count
        } else {
            return 0.0
        }
    }

    func isOwned(coin: CoinModel) -> Bool {
        return interactor.isOwned(coin: coin)
    }

    func makeButtonForSwap() -> some View {
        Button {
            self.swap()
        } label: {
            Text("Swap")
                .frame(height: 60)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.3)
                .font(.system(size: 20))
                .foregroundColor(Color.theme.accentcolor)
                .background(Color.theme.backgroundsecondary)
                .cornerRadius(10)
        }
    }
}