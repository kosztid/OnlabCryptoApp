import Foundation

class MessageGroupMembersPresenter: ObservableObject {
    private let interactor: MessageGroupMembersInteractor
    @Published var community: CommunityModel

    init(interactor: MessageGroupMembersInteractor, community: CommunityModel) {
        self.interactor = interactor
        self.community = community
    }
}
