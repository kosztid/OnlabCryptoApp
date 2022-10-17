import Foundation
import Combine
import SwiftUI

class StockSwapPresenter: ObservableObject {
    @Published var buyorsell = "none"
    @Published var stock1 = "AAPL"
    @Published var stock2 = "TSLA"
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

        interactor.model.$stock1
            .assign(to: \.stock1, on: self)
            .store(in: &cancellables)

        interactor.model.$stock2
            .assign(to: \.stock2, on: self)
            .store(in: &cancellables)

        interactor.model.$stocksToBuy
            .assign(to: \.stockstobuy, on: self)
            .store(in: &cancellables)

        interactor.model.$stocksToSell
            .assign(to: \.stockstosell, on: self)
            .store(in: &cancellables)

        interactor.model.$buyorsell
            .assign(to: \.buyorsell, on: self)
            .store(in: &cancellables)

        interactor.model.$stocks
            .assign(to: \.stocks, on: self)
            .store(in: &cancellables)

        interactor.model.$ownedStocks
            .assign(to: \.ownedStocks, on: self)
            .store(in: &cancellables)
    }

    func makeButtonForSelector(bos: BuyOrSell) -> some View {
        NavigationLink("Select stock", destination: router.makeSelectorView(presenter: self, buyorsell: bos))
    }

    func setSellAmount() {
        let stock1 = self.selected(stockSymbol: stock1)
        let stock2 = self.selected(stockSymbol: stock2)
        let amount = (Double(stock2.lastsale.dropFirst()) ?? 1) * stockstobuy
        interactor.setStockstoSell(amount: amount / (Double(stock1.lastsale.dropFirst()) ?? 1))
    }

    func setBuyAmount() {
        let stock1 = self.selected(stockSymbol: stock1)
        let stock2 = self.selected(stockSymbol: stock2)
        let amount = (Double(stock1.lastsale.dropFirst()) ?? 1) * stockstosell
        interactor.setStockstoBuy(amount: amount / (Double(stock2.lastsale.dropFirst()) ?? 1))

    }

    func selected(stockSymbol: String) -> StockListItem {
        return interactor.selected(stock: stockSymbol)
    }

    func swap() {
        interactor.swap(stockToSell: stock1, sellamount: stockstosell, stockToBuy: stock2, buyamount: stockstobuy)
    }

    func setStockstobuy(amount: Double) {
        interactor.setStockstoBuy(amount: amount)
    }

    func setStockstosell(amount: Double) {
        interactor.setStockstoSell(amount: amount)
    }

    func setStock1(stock: String) {
        interactor.setStock1(stock: stock)
    }

    func setStock2(stock: String) {
        interactor.setStock2(stock: stock)
    }

    func setBuyorSell(boolean: String) {
        interactor.setBuyorSell(boolean: boolean)
    }

    func returnmodel() -> DataModel {
        return interactor.model
    }

    func ownedamount(stockSymbol: String) -> Double {
        return interactor.ownedamount(stock: selected(stockSymbol: stockSymbol))
    }

    func isOwned(stock: StockListItem) -> Bool {
        return interactor.isOwned(stock: stock)
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
