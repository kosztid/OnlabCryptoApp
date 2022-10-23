import Foundation
import SwiftUI

class CommunitiesRouter {
    func gotoChat(interactor: MessagerInteractor, community: CommunityModel) -> some View {
        let presenter = MessagerPresenter(interactor: interactor, community: community)
        return MessagerView(presenter: presenter)
    }


    func makeAccountView() -> some View {
        return AccountView(presenter: AccountPresenter(interactor: AccountInteractor()))
    }

    func makeLoginView() -> some View {
        let presenter = LoginScreenPresenter(interactor: LoginScreenInteractor())
        return LoginScreenView(presenter: presenter)
    }
}
