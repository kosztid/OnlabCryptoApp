import Foundation

class CommunityAdderPresenter: ObservableObject {
    private let interactor: CommunityAdderInteractor

    init(interactor: CommunityAdderInteractor) {
        self.interactor = interactor
    }

    func addCommunity(name: String) {
        interactor.addCommunity(name: name)
    }
}
