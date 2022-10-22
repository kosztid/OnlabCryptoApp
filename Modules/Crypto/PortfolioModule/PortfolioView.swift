import SwiftUI

struct PortfolioView: View {
    @StateObject var presenter: PortfolioPresenter

    var body: some View {
        ZStack {
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            VStack {
                presenter.makeFolioData(selected: presenter.selection)
                    .padding(5)
                buttonList
                presenter.makeList(selected: presenter.selection)
                    .background(Color.theme.backgroundcolor)
                    .scrollContentBackground(.hidden)
                    .toolbar {
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
                    .listStyle(PlainListStyle())
            }
        }
        .onAppear(perform: presenter.reloadData)
        .onChange(of: presenter.favcoins.count) { _ in
            print("favcoins megvaltozott")
        }
    }

    var buttonList: some View {
        HStack {
            Spacer()
            presenter.makeButtonforPortfolioList()
            presenter.makeButtonforFavfolioList()
                .accessibilityIdentifier("FavfolioButton")
            presenter.makeButtonforWalletList()
                .accessibilityIdentifier("WalletButton")
            Spacer()
        }
        .padding(.horizontal, 5)
        .frame(height: 100, alignment: .leading)
    }
}
