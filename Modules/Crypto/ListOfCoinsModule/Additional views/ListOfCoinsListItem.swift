import SwiftUI

struct ListOfCoinsListItem: View {
    @ObservedObject var presenter: ListOfCoinsPresenter
    var coin: CoinModel
    var body: some View {
        ZStack {
            Color.theme.backgroundcolor
                .ignoresSafeArea()

            HStack {
                Text("\(coin.rank)")
                    .font(.system(size: 15))
                    .foregroundColor(Color.theme.accentcolor)
                    .frame(minWidth: 25)
                    .frame(alignment: .trailing)

                coinImage

                Text(coin.symbol.uppercased())
                    .foregroundColor(Color.theme.accentcolor)
                    .font(.system(size: 20))
                Spacer()
                Text(coin.priceChangePercentage24H?.formatpercent() ?? "0%")
                    .foregroundColor((coin.priceChangePercentage24H ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
                    .font(.system(size: 12))
                priceStack
                .frame(width: UIScreen.main.bounds.width / 4, alignment: .trailing)
            }
            .padding(.all, 5)
        }
    }

    var coinImage: some View {
        CachedAsyncImage(url: URL(string: coin.image)) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            Circle()
                .frame(width: 30, height: 30)
        }
        .frame(width: 30, height: 30)
        .cornerRadius(20)
    }
    var priceStack: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.formatcurrency6digits())
                .foregroundColor(Color.theme.accentcolor)
                .font(.system(size: 16))
                .frame(alignment: .leading)
            Text(coin.marketCap?.formatcurrency0digits() ?? "$0.00")
                .foregroundColor(Color.theme.accentcolorsecondary)
                .font(.system(size: 10))
                .frame(alignment: .leading)
        }
    }
}

struct ListOfCoinsListItem_Previews: PreviewProvider {
    static var previews: some View {
        // swiftlint:disable:next line_length
        ListOfCoinsListItem(presenter: ListOfCoinsPresenter(interactor: ListOfCoinsInteractor()), coin: CoinModel(id: Strings.test, symbol: Strings.test, name: Strings.test, image: Strings.test, currentPrice: 10, marketCap: 10, marketCapRank: 279, fullyDilutedValuation: 10, totalVolume: 10, high24H: 10, low24H: 10, priceChange24H: 10, priceChangePercentage24H: 10, marketCapChange24H: 10, marketCapChangePercentage24H: 10, circulatingSupply: 10, totalSupply: 10, maxSupply: 10, ath: 10, athChangePercentage: 10, athDate: Strings.test, atl: 10, atlChangePercentage: 10, atlDate: Strings.test, lastUpdated: Strings.test, sparklineIn7D: SparklineIn7D(price: []), priceChangePercentage24HInCurrency: 10))
            .preferredColorScheme(.dark)
    }
}
