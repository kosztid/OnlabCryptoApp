import Foundation
import SwiftUI

class StockSwapRouter {
    func makeSelectorView(presenter: StockSwapPresenter, buyorsell: BuyOrSell) -> some View {
        StockSearchView(buyOrSell: buyorsell, presenter: presenter)
    }
}
