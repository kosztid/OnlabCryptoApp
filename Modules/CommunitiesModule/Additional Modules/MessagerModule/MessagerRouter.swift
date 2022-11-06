import Foundation
import SwiftUI
class MessagerRouter {
    func makeMembersView(community: CommunityModel) -> some View {
        let presenter = MessageGroupMembersPresenter(interactor: MessageGroupMembersInteractor(), community: community)
        return MessageGroupMembersView(presenter: presenter)
    }
}
