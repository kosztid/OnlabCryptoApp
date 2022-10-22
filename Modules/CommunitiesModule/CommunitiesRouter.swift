import Foundation
import SwiftUI

class CommunitiesRouter {
    func gotoChat(model: DataModel, community: CommunityModel) -> some View {
        let presenter = MessagerPresenter(interactor: MessagerInteractor(model: model), community: community)
        return MessagerView(presenter: presenter)
    }

    func makeCommunityAdderView(model: DataModel) -> some View {
        return CommunityAdderView(presenter: CommunityAdderPresenter(interactor: CommunityAdderInteractor(model: model)))
    }

    func makeAccountView() -> some View {
        return AccountView(presenter: AccountPresenter(interactor: AccountInteractor()))
    }
    
    func makeLoginView() -> some View {
        let presenter = LoginScreenPresenter(interactor: LoginScreenInteractor())
        return LoginScreenView(presenter: presenter)
    }
}
