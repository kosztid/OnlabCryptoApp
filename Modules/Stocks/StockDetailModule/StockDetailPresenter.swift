import Combine
import Foundation
import SwiftUI

class StockDetailPresenter: ObservableObject {
    private let interactor: StockDetailInteractor
//    swiftlint:disable:next line_length
    @Published var stock = Stock(ticker: "Loading...", queryCount: 1, resultsCount: 1, adjusted: false, results: [], status: "Loading...", requestID: "Loading...", count: 1)
    @Published var favStocks: [StockServerModel] = []
    @Published var currentPrices: [Double] = [1]
    @Published var currentMin = 0.0
    @Published var currentMax = 0.0
    @Published var lastPrice = 0.0
    @Published var lastVolume = 0
    @Published var marketCap = ""
    @Published var changePct = ""
    @Published var fullName = ""
    @Published var graphColor = Color.accentColor
    @Published var signedin = false
    private var cancellables = Set<AnyCancellable>()

    init(interactor: StockDetailInteractor) {
        self.interactor = interactor

        self.interactor.getDownloader().$stock
            .assign(to: \.stock, on: self)
            .store(in: &cancellables)

        self.interactor.getSignInStatus()
            .assign(to: \.signedin, on: self)
            .store(in: &cancellables)

        interactor.getFavs()
            .assign(to: \.favStocks, on: self)
            .store(in: &cancellables)
    }

    func makeGraphData() {
        currentPrices = []
        for res in stock.results {
            currentPrices.append(res.c)
        }
        if currentPrices[stock.resultsCount - 1] > currentPrices[stock.resultsCount - 2] {
            graphColor = Color.theme.green
        } else {
            graphColor = Color.theme.red
        }
    }

    func refreshData() {
        marketCap = interactor.getStockData().marketCap
        changePct = interactor.getStockData().pctchange
        fullName = interactor.getStockData().name
        lastPrice = currentPrices.last ?? 0.0
        lastVolume = stock.results[stock.resultsCount - 1].v
        currentMax = currentPrices.max() ?? 0
        currentMin = currentPrices.min() ?? 0
    }
    func getFavImage() -> Image {
        interactor.isFav() ? Image.starFill : Image.star
    }

    func hintText() -> String {
        if interactor.getStockCount() > 0 {
            return String(interactor.getStockCount())
        } else {
            return Strings.amount
        }
    }

    func makeFavButton() -> some View {
        Button {
            self.interactor.addFavStock()
        } label: {
            self.getFavImage()
                .foregroundColor(Color.theme.accentcolor)
                .font(.system(size: 25))
        }
        .buttonStyle(BorderlessButtonStyle())
    }

    func addPortfolio(amount: Double?) {
        guard let amount = amount else {
            return
        }
        interactor.addPortfolio(amount: amount, currentprice: self.lastPrice)
    }
    func getGraphData() -> [CGFloat] {
        interactor.makeGraphData(values: currentPrices)
    }

    func onAppear() {
        interactor.getStock()
    }
}
