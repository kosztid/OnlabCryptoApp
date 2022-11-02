import SwiftUI

struct PortfolioListItem: View {
    @ObservedObject var presenter: PortfolioPresenter
    var holding: Double
    var coin: CoinModel

    var body: some View {
        ZStack {
            Color.theme.backgroundcolor
                .ignoresSafeArea()

            HStack {
                HStack(alignment: .center) {
                    coinImage
                    Text(coin.symbol.uppercased())
                        .foregroundColor(Color.theme.accentcolor)
                        .font(.system(size: 18))
                    Spacer()
                    priceStack
                    .frame(alignment: .trailing)
                }
                .padding(.trailing, 10)
                .frame(alignment: .leading)
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(self.holding.format2digits())")
                            .foregroundColor(Color.theme.accentcolor)
                        Text(coin.symbol.uppercased())
                            .foregroundColor(Color.theme.accentcolorsecondary)
                    }
                    .font(.system(size: 16))
                    Spacer()
                    Text("(\((self.holding * coin.currentPrice).formatcurrency0digits()))")
                        .font(.system(size: 14))
                }
                .foregroundColor(Color.theme.accentcolor)
                .frame(width: UIScreen.main.bounds.width / 2.5, alignment: .trailing)
            }
            .padding(.horizontal, 10.0)
        }
    }

    var coinImage: some View {
        CachedAsyncImage(url: URL(string: coin.image)) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            Circle()
                .frame(width: 20, height: 20)
        }
        .frame(width: 20, height: 20)
        .cornerRadius(20)
    }
    var priceStack: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.formatcurrency6digits())
                .foregroundColor(Color.theme.accentcolor)
                .font(.system(size: 16))
                .frame(alignment: .leading)
            Text(coin.priceChangePercentage24H?.formatpercent() ?? "0%")
                .foregroundColor((coin.priceChangePercentage24H ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
                .font(.system(size: 12))
        }
    }
}
