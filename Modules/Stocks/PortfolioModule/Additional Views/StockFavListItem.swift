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
                        .foregroundColor( Int.random(in: 0...1) % 2 == 0 ? Color.theme.green : Color.theme.red)
                        .font(.system(size: 12))
                }
                Button() {
                    setFav(stock.stockSymbol)
                } label: {
                    Label("", systemImage: true ? "star.fill" : "star")
                        .foregroundColor(Color.theme.accentcolor)
                        .font(.system(size: 22))
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .padding(.horizontal, 10.0)
        }
    }
}
