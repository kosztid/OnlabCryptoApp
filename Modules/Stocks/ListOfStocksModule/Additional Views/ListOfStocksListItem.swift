import SwiftUI

struct ListOfStocksListItem: View {
    var stock: StockListItem
    var body: some View {
        HStack {
            Text(stock.symbol)
                .foregroundColor(Color.theme.accentcolor)
                .font(.system(size: 20))
            Spacer()
            Text(stock.pctchange)
                .font(.system(size: 12))
                .foregroundColor(stock.pctchange.contains("-") ? Color.theme.red : Color.theme.green)
            VStack(alignment: .trailing) {
                Text(stock.lastsale)
                    .foregroundColor(Color.theme.accentcolor)
                    .font(.system(size: 16))
                Text("$\(stock.marketCap)")
                    .foregroundColor(Color.theme.accentcolorsecondary)
                    .font(.system(size: 10))
            }
            .frame(width: UIScreen.main.bounds.width / 3, alignment: .trailing)
        }
        .padding(5)
        .padding(.leading, 10)
        .frame(height: 40)
    }
}
