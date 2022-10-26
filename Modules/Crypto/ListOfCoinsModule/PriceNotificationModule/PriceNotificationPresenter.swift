import Foundation
import Combine

class PriceNotificationPresenter: ObservableObject {
    private let interactor: PriceNotificationInteractor
    @Published var events: [ChangeDataModel] = []
    private var cancellables = Set<AnyCancellable>()

    init(interactor: PriceNotificationInteractor) {
        self.interactor = interactor

    }

    func currentPrice(coinid: String) -> Double {
//        return interactor.currentPrice(coinid: coinid)
        return 0.0
    }
    func coinname(coinid: String) -> String {
//        return interactor.coinname(coinid: coinid)
        return ""
    }

}
