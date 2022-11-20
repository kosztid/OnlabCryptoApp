import SwiftUI

struct CoinDetailView: View {
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
                        .foregroundColor((presenter.coin.priceChangePercentage24H ?? 0) >= 0 ? Color.theme.greengraph : Color.theme.redgraph)
                    marketCap

                    dailyHighLow

                    allTimeHighLow

                    supplyBlock
                    Spacer()
                }
                .padding(10)
            }
            .navigationBarItems(trailing: Button(Strings.add) {
                // swiftlint:disable:next line_length
                alertWithTfNumpad(title: presenter.coin.symbol.uppercased(), message: Strings.putAmount, hintText: presenter.hintText(), primaryTitle: Strings.change, secTitle: Strings.back) { text in
                    presenter.addHolding(Double(text) ?? 0)
                } secondaryAction: {
                    print("cancelled")
                }
            }
                .accessibilityIdentifier("AddButton"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("\(presenter.coin.name)  (\(presenter.coin.symbol.uppercased()))")
        }
    }

    var priceBlock: some View {
        VStack {
            Text("\(presenter.coin.currentPrice.formatcurrency6digits())")
                .font(.system(size: 35))
                .foregroundColor(Color.theme.accentcolor)
                .frame(alignment: .trailing)
            HStack {
                Text("\(presenter.coin.priceChangePercentage24H?.formatpercent() ?? "0%" )")

                Text("(\(presenter.coin.priceChange24H?.formatcurrency4digits() ?? "0" ))")
            }.foregroundColor((presenter.coin.priceChangePercentage24H ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
        }
    }
    var marketCap: some View {
        HStack {
            Text(Strings.marketCap)
                .foregroundColor(Color.theme.accentcolorsecondary)
            Spacer()
            Text("\(presenter.coin.marketCap?.formatcurrency0digits() ?? "0")")
        }
        .font(.system(size: 18))
        .padding(5)
        .foregroundColor(Color.theme.accentcolor)
    }

    var dailyHighLow: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(Strings.dailymax)
                    .font(.system(size: 18))
                    .foregroundColor(Color.theme.accentcolorsecondary)
                HStack {
                    Text("\(presenter.coin.high24H?.formatcurrency6digits() ?? "0")")
                        .foregroundColor(Color.theme.accentcolor)
                        .font(.system(size: 18))
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(Strings.dailylow)
                    .font(.system(size: 18))
                    .foregroundColor(Color.theme.accentcolorsecondary)
                HStack {
                    Text("\(presenter.coin.low24H?.formatcurrency6digits() ?? "0")")
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
                Text(Strings.ath)
                    .font(.system(size: 18))
                    .foregroundColor(Color.theme.accentcolorsecondary)
                    .frame(alignment: .leading)
                HStack {
                    Text("\(presenter.coin.ath?.formatcurrency6digits() ?? "0")")
                        .foregroundColor(Color.theme.accentcolor)
                        .font(.system(size: 18))
                    Text("\(presenter.coin.athChangePercentage?.formatpercent() ?? "0%")")
                        .foregroundColor(Color.theme.red)
                        .font(.system(size: 14))
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(Strings.atl)
                    .font(.system(size: 18))
                    .foregroundColor(Color.theme.accentcolorsecondary)
                HStack {
                    Text("\(presenter.coin.atl?.formatcurrency6digits() ?? "0")")
                        .foregroundColor(Color.theme.accentcolor)
                        .font(.system(size: 18))
                    Text("\(presenter.coin.atlChangePercentage?.formatpercent() ?? "0%")")
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
                    Text(Strings.availableSupply)
                        .font(.system(size: 18))
                        .foregroundColor(Color.theme.accentcolorsecondary)
                    Spacer()
                    Text(Strings.totalSupply)
                        .font(.system(size: 18))
                        .foregroundColor(Color.theme.accentcolorsecondary)
                }
                HStack {
                    Text("\(presenter.coin.circulatingSupply?.formatintstring() ?? "0")")
                        .foregroundColor(Color.theme.accentcolor)
                        .font(.system(size: 18))
                    Spacer()
                    Text("/")
                        .foregroundColor(Color.theme.accentcolor)
                    Spacer()
                    Text("\(presenter.coin.totalSupply?.formatintstring() ?? "0")")
                        .foregroundColor(Color.theme.accentcolor)
                        .font(.system(size: 18))
                }
            }
        }
        .padding(5)
    }
}
