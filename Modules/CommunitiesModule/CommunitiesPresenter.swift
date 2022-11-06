import Combine
import Foundation
import SwiftUI

class CommunitiesPresenter: ObservableObject {
    private let router = CommunitiesRouter()
    private let interactor: CommunitiesInteractor

    private var cancellables = Set<AnyCancellable>()

    @Published var communities: [CommunityModel] = []
    @Published var subLogs: [UserLog] = []
    @Published var signedin = false
    @Published var viewType = CommunityTabViews.communities

    init(interactor: CommunitiesInteractor) {
        self.interactor = interactor
        interactor.getCommunities()
            .assign(to: \.communities, on: self)
            .store(in: &cancellables)

        interactor.getSignInStatus()
            .assign(to: \.signedin, on: self)
            .store(in: &cancellables)

        interactor.getSubLogs()
            .assign(to: \.subLogs, on: self)
            .store(in: &cancellables)
    }

    func linkBuilder<Content: View>(
        for community: CommunityModel,
        @ViewBuilder content: () -> Content) -> some View {
            NavigationLink(destination: router.gotoChat(interactor: interactor.makeMessagerInteractor(), community: community)) {
            }
            .buttonStyle(PlainButtonStyle())
            .opacity(0)
        }
    func addCommunity(_ name: String) {
        interactor.addCommunity(name)
    }

    func navigateToSubs() -> some View {
        NavigationLink { router.makeSubsView(interactor.getUsersList(), interactor.getSubsList(), interactor.subscribe) } label: {
            Image.plus}
    }
    func reload() {
        interactor.reload()
    }
    func makeButtonForLogin() -> some View {
        NavigationLink(Strings.account, destination: router.makeLoginView())
    }
    func makeButtonForAccount() -> some View {
        NavigationLink(Strings.account, destination: router.makeAccountView())
    }
}
