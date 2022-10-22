import Foundation
import SwiftUI
import Combine

class CoinDetailPresenter: ObservableObject {
    @State var showalert: Bool = false
    private let interactor: CoinDetailInteractor
    @Published var favcoins: [CryptoServerModel] = []
    private let router = CoinDetailRouter()

    @Published var signedin = false
    private var cancellables = Set<AnyCancellable>()

    init(interactor: CoinDetailInteractor) {
        self.interactor = interactor

        interactor.getSignInStatus()
            .assign(to: \.signedin, on: self)
            .store(in: &cancellables)

        interactor.getFavs()
            .assign(to: \.favcoins, on: self)
            .store(in: &cancellables)
    }

    func getGraphValues() -> [CGFloat] {
        return interactor.getvalues()
    }
    func getcoin() -> CoinModel {
        return interactor.getcoin()
    }
    func addHolding(_ count: Double) {
        interactor.addHolding(count: count)
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
    func hintText() -> String {
        if interactor.getCoinCount() > 0 {
            return String(interactor.getCoinCount())
        } else {
            return "Mennyiség"
        }
    }
}
