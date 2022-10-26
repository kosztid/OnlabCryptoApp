import SwiftUI

struct PortfolioAdderView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var presenter: PortfolioAdderPresenter
    @State var coincount : Double
    var body: some View {
        ZStack {
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            VStack {
                HStack {
                    Text("The selected coin is:")
                        .foregroundColor(Color.theme.accentcolor)
                    Text(presenter.coindata().name)
                        .font(.system(size: 20))
                        .foregroundColor(Color.theme.accentcolor)
                    TextField("Number to add", value: $coincount, format: .number)
                        .padding(.horizontal)
                        .frame(height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 20))
                        .foregroundColor(Color.theme.accentcolor)
                        .background(Color.theme.backgroundcolor)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.theme.accentcolorsecondary, lineWidth: 2))
                        .cornerRadius(10)
                        .disableAutocorrection(true)
                        .accessibilityIdentifier("PortfolioadderTextField")
                }

                Button {
                    if coincount > 0 {
                        presenter.addCoin(count: self.coincount)
                        self.presentationMode.wrappedValue.dismiss()
                    }

                } label: {
                    Text("Add")
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 20))
                        .foregroundColor(Color.theme.accentcolor)
                        .background(Color.theme.backgroundsecondary)
                        .cornerRadius(10)
                }
                .accessibilityIdentifier("PortfolioadderButton")
            }
        }.padding(10)
            .background(Color.theme.backgroundcolor)
    }
}
// swiftlint:disable next line_length
struct PortfolioAdderView_Previews: PreviewProvider {
    static var previews: some View {
        let interactor = PortfolioAdderInteractor(coin: CoinModel(id: "teszt", symbol: "teszt", name: "teszt", image: "teszt", currentPrice: 10, marketCap: 10, marketCapRank: 10, fullyDilutedValuation: 10, totalVolume: 10, high24H: 10, low24H: 10, priceChange24H: 10, priceChangePercentage24H: 10, marketCapChange24H: 10, marketCapChangePercentage24H: 10, circulatingSupply: 10, totalSupply: 10, maxSupply: 10, ath: 10, athChangePercentage: 10, athDate: "teszt", atl: 10, atlChangePercentage: 10, atlDate: "teszt", lastUpdated: "teszt", sparklineIn7D: SparklineIn7D(price: []), priceChangePercentage24HInCurrency: 10))
        let presenter = PortfolioAdderPresenter(interactor: interactor)
        PortfolioAdderView(presenter: presenter, coincount: 10)
    }
}
