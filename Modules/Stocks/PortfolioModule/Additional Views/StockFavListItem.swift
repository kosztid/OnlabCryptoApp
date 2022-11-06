import SwiftUI

struct StockFavListItem: View {
    var stock: StockServerModel
    var stockData: StockListItem
    var setFav: (String) -> Void

    var body: some View {
        ZStack {
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            HStack {
                Text(stock.stockSymbol)
                    .foregroundColor(Color.theme.accentcolor)
                    .font(.system(size: 18))
                Spacer()

                VStack(alignment: .trailing) {
                    Text(stockData.lastsale)
                        .foregroundColor(Color.theme.accentcolor)
                        .font(.system(size: 16))
                    Text(stockData.pctchange)
                        .foregroundColor(stockData.pctchange.contains("-") ? Color.theme.red : Color.theme.green)
                        .font(.system(size: 12))
                }
                Button {
                    setFav(stock.stockSymbol)
                } label: {
                    Image.starFill
                        .foregroundColor(Color.theme.accentcolor)
                        .font(.system(size: 22))
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .padding(.horizontal, 10.0)
        }
    }
}
