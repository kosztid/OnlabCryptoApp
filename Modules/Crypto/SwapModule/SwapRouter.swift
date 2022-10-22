import Foundation
import SwiftUI

class SwapRouter {
    func makeSelectorView(presenter: SwapPresenter, coin: String) -> some View {
        SearchView(coinname: coin, presenter: presenter)
    }
//    func makeSelectorView(list: [CoinModel], coin: String) -> some View {
//        SearchView(coinname: coin, list: list)
//    }
}
