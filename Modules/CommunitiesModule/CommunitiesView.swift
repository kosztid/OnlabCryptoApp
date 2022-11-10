import SwiftUI

struct CommunitiesView: View {
    @ObservedObject var presenter: CommunitiesPresenter
    var list = ["favremove", "favadd", "portfolio"]
    var body: some View {
        VStack {
            topBarMenu

            if presenter.viewType == .communities {
                communitiesList
            } else {
                subsList
            }
        }
        .onAppear(perform: presenter.reload)
        .background(Color.theme.backgroundcolor)
    }

    var subsList: some View {
        List {
            ForEach(presenter.subLogs) { log in
                ZStack {
                    Color.theme.backgroundcolor
                        .ignoresSafeArea()
                    SubscriptionLogListItem(log)
                        .cornerRadius(10)
                        .padding(5)
                }
            }
            .listRowSeparator(.hidden)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .background(Color.theme.backgroundcolor)
        .scrollContentBackground(.hidden)
        .navigationBarItems(trailing: presenter.navigateToSubs().accessibilityIdentifier("AddSubscriptionButton"))
        .listStyle(PlainListStyle())
    }

    var communitiesList: some View {
        List {
            ForEach(presenter.communities) { community in
                ZStack {
                    Color.theme.backgroundcolor
                        .ignoresSafeArea()
                    CommunitiesListItem(community: community)
                        .frame(height: 60)
                        .cornerRadius(10)
                        .padding(5)
                    self.presenter.linkBuilder(for: community) {
                        EmptyView()
                    }.buttonStyle(PlainButtonStyle())
                }
            }
            .listRowSeparator(.hidden)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .background(Color.theme.backgroundcolor)
        .scrollContentBackground(.hidden)
        .navigationBarItems(trailing: Button(Strings.addCommunity) {
            // swiftlint:disable:next line_length
            alertWithTf(title: Strings.newGroupMake, message: Strings.putGroupName, hintText: Strings.name, primaryTitle: Strings.add, secondaryTitle: Strings.back) { text in
                presenter.addCommunity(text)
            } secondaryAction: {
                print("cancelled")
            }
        }
            .accessibilityIdentifier("AddCommunityButton")
            .buttonStyle(UnifiedBorderedButtonStyle())
        )
        .listStyle(PlainListStyle())
    }

    var topBarMenu: some View {
        HStack {
            Button {
                presenter.viewType = .subs
            } label: {
                Text(Strings.subscriptions)
            }
            .buttonStyle(UnifiedSelectorBorderedButtonStyle(isSelected: presenter.viewType == .subs, buttonCount: 2, height: 30, fontSize: 20))
            .accessibilityIdentifier("SubscriptionsButton")
            Button {
                presenter.viewType = .communities
            } label: {
                Text(Strings.communities)
            }
            .buttonStyle(UnifiedSelectorBorderedButtonStyle(isSelected: presenter.viewType == .communities, buttonCount: 2, height: 30, fontSize: 20))
        }
    }
}

struct CommunitiesView_Previews: PreviewProvider {
    static var previews: some View {
        let interactor = CommunitiesInteractor()
        let presenter = CommunitiesPresenter(interactor: interactor)
        CommunitiesView(presenter: presenter)
    }
}
