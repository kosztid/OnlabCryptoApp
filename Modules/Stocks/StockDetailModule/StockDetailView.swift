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
                .padding(10)
            }
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
            Text("\(presenter.fullName)")
                .font(.system(size: 32))
                .foregroundColor(Color.theme.accentcolor)
                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
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
            Text("Last Day's volume:")
            Spacer()
            Text("\(presenter.lastVolume)")
        }.padding(5)
    }
    var marketcap: some View {
        HStack {
            Text("Current marketcap:")
            Spacer()
            Text("\(presenter.marketCap)")
        }.padding(5)
    }
    var chartsection: some View {
        VStack {
            Text("\(presenter.currentMax.formatcurrency4digits())")
                .font(.system(size: 16))
                .frame(width: UIScreen.main.bounds.width, alignment: .trailing)
            ChartView(values: presenter.getGraphData())
                .foregroundColor(presenter.graphColor)
            Text("\(presenter.currentMin.formatcurrency4digits())")
                .frame(width: UIScreen.main.bounds.width, alignment: .trailing)
                .font(.system(size: 16))
        }.padding(5)
    }

}
