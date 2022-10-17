import SwiftUI

struct CoinDetailView: View {
    @State var showalert = false
    @StateObject var presenter: CoinDetailPresenter

    var body: some View {
        ZStack {
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    HStack {
                        priceBlock

                        Spacer()

                        presenter.makeFavButton()
                            .disabled(!presenter.signedin)
                    }
                    .frame(alignment: .trailing)
                    ChartView(values: presenter.getGraphValues())
                        .foregroundColor((presenter.getcoin().priceChangePercentage24H ?? 0) >= 0 ? Color.theme.greengraph : Color.theme.redgraph)
                    marketCap

                    dailyHighLow

                    allTimeHighLow

                    supplyBlock
                    Spacer()
                }
                .padding(10)
            }
            .navigationBarItems(trailing: Button("Add") {
                // swiftlint:disable:next line_length
                alertWithTfNumpad(title: presenter.getcoin().symbol.uppercased(), message: "Adja meg a mennyiséget", hintText: presenter.hintText(), primaryTitle: "Változtatás", secTitle: "Vissza") { text in
                    print("added \(text)")
                } secondaryAction: {
                    print("cancelled")
                }
            })
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("\(presenter.getcoin().name)  (\(presenter.getcoin().symbol.uppercased()))")
        }
    }

    var priceBlock: some View {
        VStack {
            Text("\(presenter.getcoin().currentPrice.formatcurrency6digits())")
                .font(.system(size: 35))
                .foregroundColor(Color.theme.accentcolor)
                .frame(alignment: .trailing)
            HStack {
                Text("\(presenter.getcoin().priceChangePercentage24H?.formatpercent() ?? "0%" )")

                Text("(\(presenter.getcoin().priceChange24H?.formatcurrency4digits() ?? "0" ))")
            }.foregroundColor((presenter.getcoin().priceChangePercentage24H ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
        }
    }
    var marketCap: some View {
        HStack {
            Text("MarketCap: ")
                .foregroundColor(Color.theme.accentcolorsecondary)
            Spacer()
            Text("\(presenter.getcoin().marketCap?.formatcurrency0digits() ?? "0")")
        }
        .font(.system(size: 18))
        .padding(5)
        .foregroundColor(Color.theme.accentcolor)
    }

    var dailyHighLow: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("24H High")
                    .font(.system(size: 18))
                    .foregroundColor(Color.theme.accentcolorsecondary)
                HStack {
                    Text("\(presenter.getcoin().high24H?.formatcurrency6digits() ?? "0")")
                        .foregroundColor(Color.theme.accentcolor)
                        .font(.system(size: 18))
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("24H Low")
                    .font(.system(size: 18))
                    .foregroundColor(Color.theme.accentcolorsecondary)
                HStack {
                    Text("\(presenter.getcoin().low24H?.formatcurrency6digits() ?? "0")")
                        .foregroundColor(Color.theme.accentcolor)
                        .font(.system(size: 18))
                }
            }
        }
        .padding(5)
    }

    var allTimeHighLow: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("All-Time High")
                    .font(.system(size: 18))
                    .foregroundColor(Color.theme.accentcolorsecondary)
                    .frame(alignment: .leading)
                HStack {
                    Text("\(presenter.getcoin().ath?.formatcurrency6digits() ?? "0")")
                        .foregroundColor(Color.theme.accentcolor)
                        .font(.system(size: 18))
                    Text("\(presenter.getcoin().athChangePercentage?.formatpercent() ?? "0%")")
                        .foregroundColor(Color.theme.red)
                        .font(.system(size: 14))
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("All-Time Low")
                    .font(.system(size: 18))
                    .foregroundColor(Color.theme.accentcolorsecondary)
                HStack {
                    Text("\(presenter.getcoin().atl?.formatcurrency6digits() ?? "0")")
                        .foregroundColor(Color.theme.accentcolor)
                        .font(.system(size: 18))
                    Text("\(presenter.getcoin().atlChangePercentage?.formatpercent() ?? "0%")")
                        .foregroundColor(Color.theme.greengraph)
                        .font(.system(size: 14))
                }
            }
        }
        .padding(5)
    }
    var supplyBlock: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text("Available Supply")
                        .font(.system(size: 18))
                        .foregroundColor(Color.theme.accentcolorsecondary)
                    Spacer()
                    Text("Total Supply")
                        .font(.system(size: 18))
                        .foregroundColor(Color.theme.accentcolorsecondary)
                }
                HStack {
                    Text("\(presenter.getcoin().circulatingSupply?.formatintstring() ?? "0")")
                        .foregroundColor(Color.theme.accentcolor)
                        .font(.system(size: 18))
                    Spacer()
                    Text("/")
                    Spacer()
                    Text("\(presenter.getcoin().totalSupply?.formatintstring() ?? "0")")
                        .foregroundColor(Color.theme.accentcolor)
                        .font(.system(size: 18))
                }
            }
        }
        .padding(5)
    }
}
