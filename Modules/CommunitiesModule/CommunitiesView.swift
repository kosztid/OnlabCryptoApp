import SwiftUI

struct CommunitiesView: View {
    @ObservedObject var presenter: CommunitiesPresenter
    var body: some View {
        ZStack {
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            List {
                ForEach(presenter.communities){ community in
                    ZStack {
                        Color.theme.backgroundcolor
                            .ignoresSafeArea()
                        CommunitiesListItem(community: community)
                            .frame(height: 60)
                            .cornerRadius(10)
                            .padding(5)
                        self.presenter.linkBuilder(for: community){
                            EmptyView()
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .navigationBarItems(trailing: Button("Add Community") {
                alertWithTf(title: "Új csoport létrehozása", message: "Kérem adja meg csoport nevét", hintText: "Név", primaryTitle: "Hozzáadás", secondaryTitle: "Vissza") { text in
                    presenter.addCommunity(text)
                } secondaryAction: {
                    print("cancelled")
                }
            })
            .listStyle(PlainListStyle())
        }
    }
}

struct CommunitiesView_Previews: PreviewProvider {
    static var previews: some View {
        let model = DataModel()
        let interactor = CommunitiesInteractor(model: model)
        let presenter = CommunitiesPresenter(interactor: interactor)
        CommunitiesView(presenter: presenter)
            .environmentObject(DataModel())
    }
}
