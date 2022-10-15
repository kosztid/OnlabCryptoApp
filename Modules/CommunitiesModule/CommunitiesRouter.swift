import Foundation
import SwiftUI

class CommunitiesRouter {
    func gotoChat(model: DataModel, community: MessageGroupModel) -> some View {
        let presenter = MessagerPresenter(interactor: MessagerInteractor(model: model), community: community)
        return MessagerView(presenter: presenter)
    }

    func makeCommunityAdderView(model: DataModel) -> some View {
        return CommunityAdderView(presenter: CommunityAdderPresenter(interactor: CommunityAdderInteractor(model: model)))
    }

    func makeAccountView(model: DataModel) -> some View {
        return AccountView(presenter: AccountPresenter(interactor: AccountInteractor(model: model)))
    }
    
    func makeLoginView(model: DataModel) -> some View {
        let presenter = LoginScreenPresenter(interactor: LoginScreenInteractor(model: model))
        return LoginScreenView(presenter: presenter)
    }
}
