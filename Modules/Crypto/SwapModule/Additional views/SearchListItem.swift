import SwiftUI

struct SearchListItem: View {
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

            VStack(alignment: .trailing) {
                Text(coin.currentPrice.formatcurrency6digits())
                    .foregroundColor(Color.theme.accentcolor)
                    .font(.system(size: 18))
                    .frame(alignment: .leading)
            }
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
}
/*
struct SearchListItem_Previews: PreviewProvider {
    static var previews: some View {
        SearchListItem(coin: CoinModel())
    }
}
*/
