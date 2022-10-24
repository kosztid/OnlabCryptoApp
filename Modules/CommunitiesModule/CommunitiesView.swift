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
        ZStack {
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            List {
                ForEach(presenter.subLogs) { log in
                    Text(log.actionType)
                }
            }
            .background(Color.theme.backgroundcolor)
            .scrollContentBackground(.hidden)
        }
        .navigationBarItems(trailing: presenter.navigateToSubs())
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
        .navigationBarItems(trailing: Button("Add Community") {
            alertWithTf(title: "Új csoport létrehozása", message: "Kérem adja meg csoport nevét", hintText: "Név", primaryTitle: "Hozzáadás", secondaryTitle: "Vissza") { text in
                presenter.addCommunity(text)
            } secondaryAction: {
                print("cancelled")
            }
        })
        .listStyle(PlainListStyle())
    }

    var topBarMenu: some View {
        HStack {
            Button {
                presenter.viewType = .subs
            } label: {
                Text("Subs")
                    .frame(height: 30)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.4)
                    .font(.system(size: 20))
                    .foregroundColor(presenter.viewType == .subs ? Color.theme.backgroundsecondary : Color.theme.accentcolor)
                    .background(presenter.viewType == .subs ? Color.theme.accentcolor :  Color.theme.backgroundsecondary)
                    .cornerRadius(10)
            }
            Button {
                presenter.viewType = .communities
            } label: {
                Text("Communities")
                    .frame(height: 30)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.4)
                    .font(.system(size: 20))
                    .foregroundColor(presenter.viewType == .communities ? Color.theme.backgroundsecondary : Color.theme.accentcolor)
                    .background(presenter.viewType == .communities ? Color.theme.accentcolor :  Color.theme.backgroundsecondary)
                    .cornerRadius(10)
            }
        }
    }
}

struct CommunitiesView_Previews: PreviewProvider {
    static var previews: some View {
        let interactor = CommunitiesInteractor()
        let presenter = CommunitiesPresenter(interactor: interactor)
        CommunitiesView(presenter: presenter)
            .environmentObject(DataModel())
    }
}
