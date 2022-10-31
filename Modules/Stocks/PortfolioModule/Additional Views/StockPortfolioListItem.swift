import SwiftUI

struct StockPortfolioListItem: View {
    var stock: StockServerModel
    var stockData: StockListItem
    var count: Double

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
                .padding(.trailing, 5)
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(stock.count.format2digits())")
                            .foregroundColor(Color.theme.accentcolor)
                        Text(stock.stockSymbol)
                            .foregroundColor(Color.theme.accentcolorsecondary)
                    }
                    .font(.system(size: 16))
                    Spacer()
                    Text("(\((count * (Double(stockData.lastsale.dropFirst()) ?? 1)).formatcurrency0digits()))")
                        .font(.system(size: 14))
                }
                .foregroundColor(Color.theme.accentcolor)
                .frame(width: UIScreen.main.bounds.width / 2.5, alignment: .trailing)
            }
            .padding(.horizontal, 10.0)
        }
    }
}
