import SwiftUI

struct ListOfStocksView: View {
    @ObservedObject var presenter: ListOfStocksPresenter
    var body: some View {
        List {
            ForEach(presenter.stocks) { stock in
                ZStack {
                    Color.theme.backgroundcolor
                        .ignoresSafeArea()
                    ListOfStocksListItem(stock: stock)
                        .frame(height: 40)
                    self.presenter.linkBuilder(for: stock) {
                        EmptyView()
                    }.buttonStyle(PlainButtonStyle())
                }
            }
            .listRowSeparatorTint(Color.theme.backgroundsecondary)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.theme.backgroundcolor)
        .scrollContentBackground(.hidden)
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
