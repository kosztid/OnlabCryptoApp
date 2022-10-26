import SwiftUI

struct ListOfCoinsView: View {
    @StateObject var presenter: ListOfCoinsPresenter
    var body: some View {
        List {
            ForEach(presenter.coins) { coin in
                ZStack {
                    Color.theme.backgroundcolor
                        .ignoresSafeArea()
                    ListOfCoinsListItem(presenter: presenter, coin: coin)
                        .frame(height: 40)
                    self.presenter.linkBuilder(for: coin) {
                        EmptyView()
                    }.buttonStyle(PlainButtonStyle())
                }
            }
            .listRowSeparatorTint(Color.theme.backgroundsecondary)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .background(Color.theme.backgroundcolor)
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                presenter.makeButtonForViewchange()
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                if presenter.signedin {
                    presenter.makeButtonForAccount()
                        .accessibilityIdentifier("PortfolioAccountButton")
                } else {
                    presenter.makeButtonForLogin()
                        .accessibilityIdentifier("PortfolioLoginButton")
                }
            }
        }
        .onAppear(perform: presenter.reloadData)
        .listStyle(PlainListStyle())
    }
}

struct ListOfCoinsView_Previews: PreviewProvider {
    static var previews: some View {
        let interactor = ListOfCoinsInteractor()
        let presenter = ListOfCoinsPresenter(interactor: interactor)
        ListOfCoinsView(presenter: presenter)
    }
}
