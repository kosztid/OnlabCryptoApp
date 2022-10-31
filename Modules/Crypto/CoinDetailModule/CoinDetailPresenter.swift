import Combine
import Foundation
import SwiftUI

class CoinDetailPresenter: ObservableObject {
    private let interactor: CoinDetailInteractor
    private let router = CoinDetailRouter()
    private var cancellables = Set<AnyCancellable>()

    let coin: CoinModel

    @Published var signedin = false

    init(interactor: CoinDetailInteractor) {
        self.interactor = interactor
        self.coin = interactor.getCoin() /* 1 */

        interactor.getSignInStatus()
            .assign(to: \.signedin, on: self)
            .store(in: &cancellables)
    }

    func getGraphValues() -> [CGFloat] {
        interactor.getValues()
    }

    func addHolding(_ count: Double) {
        interactor.addHolding(count: count)
    }

    func hintText() -> String {
        if interactor.getCoinCount() > 0 {
            return String(interactor.getCoinCount())
        } else {
            return "Mennyiség"
        }
    }

    func makeFavButton() -> some View {
        Button {
            self.interactor.addFavCoin()
        } label: {
            Label("", systemImage: interactor.isFav() ? "star.fill" : "star")
                .foregroundColor(Color.theme.accentcolor)
                .font(.system(size: 25))
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}
