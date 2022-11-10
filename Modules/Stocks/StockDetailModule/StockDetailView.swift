import SwiftUI

struct StockDetailView: View {
    @ObservedObject var presenter: StockDetailPresenter

    var body: some View {
        ZStack {
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    header
                    chartsection
                    dataSection
                        .padding([.trailing, .leading], 5)
                    Spacer()
                }
                .padding(20)
            }
            .navigationBarItems(trailing: Button(Strings.add) {
//                swiftlint:disable:next line_length
                alertWithTfNumpad(title: presenter.stock.ticker, message: Strings.putAmount, hintText: presenter.hintText(), primaryTitle: Strings.change, secTitle: Strings.back) { text in
                    presenter.addPortfolio(amount: Double(text))
                } secondaryAction: {
                    print("cancelled")
                }
            }.foregroundColor(Color.theme.accentcolor)
            )
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(presenter.stock.ticker)
            .onAppear(perform: presenter.onAppear)
            .onChange(of: presenter.stock.resultsCount) { _ in
                presenter.makeGraphData()
                presenter.refreshData()
            }
        }
    }

    var header: some View {
        VStack {
            HStack {
                Text("\(presenter.fullName)")
                    .font(.system(size: 32))
                    .foregroundColor(Color.theme.accentcolor)
                Spacer()
                presenter.makeFavButton()
                    .disabled(!presenter.signedin)
            }

            HStack {
                Text("\(presenter.lastPrice.formatcurrency4digits())")
                    .font(.system(size: 28))
                    .foregroundColor(Color.theme.accentcolor)
                Spacer()
                Text(presenter.changePct)
                    .font(.system(size: 24))
                    .foregroundColor(presenter.changePct.contains("-") ? Color.theme.red : Color.theme.green)
            }
            .padding(5)
        }
        .padding(5)
    }
    var dataSection: some View {
        VStack {
            volumeSection
            marketcap
        }
        .padding(.top, 10)
        .foregroundColor(Color.accentColor)
        .font(.system(size: 18))
    }
    var volumeSection: some View {
        HStack {
            Text(Strings.lastVolume)
                .foregroundColor(Color.theme.accentcolorsecondary)
            Spacer()
            Text("\(presenter.lastVolume)")
                .foregroundColor(Color.theme.accentcolor)
        }
        .padding(5)
    }
    var marketcap: some View {
        HStack {
            Text(Strings.marketCap)
                .foregroundColor(Color.theme.accentcolorsecondary)
            Spacer()
            Text("\(presenter.marketCap)")
                .foregroundColor(Color.theme.accentcolor)
        }
        .padding(5)
    }
    var chartsection: some View {
        VStack {
            Text("\(presenter.currentMax.formatcurrency4digits())")
                .foregroundColor(Color.theme.accentcolorsecondary)
                .font(.system(size: 16))
                .frame(width: UIScreen.main.bounds.width, alignment: .trailing)
            ChartView(values: presenter.getGraphData())
                .foregroundColor(presenter.graphColor)
            Text("\(presenter.currentMin.formatcurrency4digits())")
                .foregroundColor(Color.theme.accentcolorsecondary)
                .frame(width: UIScreen.main.bounds.width, alignment: .trailing)
                .font(.system(size: 16))
        }.padding(5)
    }
}
