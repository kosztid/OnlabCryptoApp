import Combine
import Foundation
import SwiftUI

class StockSwapPresenter: ObservableObject {
    @Published var buyorsell = "none"
    @Published var stock1 = "AAPL"
    @Published var stock2 = "TSLA"
    @Published var stockmodel1 = StockListItem(symbol: "-", name: "-", lastsale: "-", netchange: "-", pctchange: "-", marketCap: "-", url: "-")
    @Published var stockmodel2 = StockListItem(symbol: "-", name: "-", lastsale: "-", netchange: "-", pctchange: "-", marketCap: "-", url: "-")
    @Published var stockstosell = 0.0
    @Published var stockstobuy = 0.0
    private let router = StockSwapRouter()
    let interactor: StockSwapInteractor
    @Published var stocks: [StockListItem] = []
    @Published var ownedStocks: [StockServerModel] = []
    private var cancellables = Set<AnyCancellable>()
    @State private var showingAlert = false

    init(interactor: StockSwapInteractor) {
        self.interactor = interactor

        interactor.getStocks()
            .assign(to: \.stocks, on: self)
            .store(in: &cancellables)

        interactor.getOwnedStocks()
            .assign(to: \.ownedStocks, on: self)
            .store(in: &cancellables)

        stockmodel1 = selected(stock: "AAPL")
        stockmodel2 = selected(stock: "TSLA")
    }

    func setStock1(stock: String) {
        stockmodel1 = selected(stock: stock)
        setBuyAmount()
    }

    func setStock2(stock: String) {
        stockmodel2 = selected(stock: stock)
        setSellAmount()
    }

    func makeButtonForSelector(bos: BuyOrSell) -> some View {
        NavigationLink(Strings.selectStock, destination: router.makeSelectorView(presenter: self, buyorsell: bos))
    }

    func setSellAmount() {
        let stock1 = stockmodel1
        let stock2 = stockmodel2
        let amount = (Double(stock2.lastsale.dropFirst()) ?? 1) * stockstobuy
        stockstosell = amount / (Double(stock1.lastsale.dropFirst()) ?? 1)
    }

    func setBuyAmount() {
        let stock1 = stockmodel1
        let stock2 = stockmodel2
        let amount = (Double(stock1.lastsale.dropFirst()) ?? 1) * stockstosell
        stockstobuy = amount / (Double(stock2.lastsale.dropFirst()) ?? 1)
    }

    func selected(stock: String) -> StockListItem {
        // swiftlint:disable:next line_length
        return stocks.first {$0.symbol == stock} ?? StockListItem(symbol: "-", name: "-", lastsale: "-", netchange: "-", pctchange: "-", marketCap: "-", url: "-")
    }

    func swap() {
        interactor.swap(stockToSell: stockmodel1.symbol, sellamount: stockstosell, stockToBuy: stockmodel2.symbol, buyamount: stockstobuy)
        stockstobuy = 0.0
        stockstosell = 0.0
    }

    func loadService() {
        interactor.loadService()
    }

    func ownedamount(stockSymbol: String) -> Double {
        interactor.ownedamount(stockSymbol: stockSymbol)
    }

    func isOwned(stock: StockListItem) -> Bool {
        interactor.isOwned(stock: stock)
    }

    func makeButtonForSwap() -> some View {
        Button {
            self.swap()
        } label: {
            Text(Strings.swap)
                .frame(height: 30)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.3)
                .font(.system(size: 20))
        }
        .buttonStyle(UnifiedBorderedButtonStyle())
    }
}
