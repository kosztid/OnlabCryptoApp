import SwiftUI

struct StockSearchView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var searchText = ""
    @State var searching = false
    var buyOrSell: BuyOrSell = .toSell
    @ObservedObject var presenter: StockSwapPresenter

    var body: some View {
        ZStack {
            Color.theme.backgroundcolor
            VStack(alignment: .leading) {
                searchBarBlock
                List {
                    if buyOrSell == .toSell {
                        ForEach(presenter.stocks.filter { stock -> Bool in
                            // swiftlint:disable:next line_length
                            presenter.ownedStocks.contains { $0.stockSymbol == stock.symbol } && (stock.symbol.lowercased().contains(searchText.lowercased()) || (searchText.isEmpty))
                        }) { stock in
                            ZStack {
                                Button(Strings.empty) {
                                    presenter.setStock1(stock: stock.symbol)
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                                StockSearchListItem(stock: stock)
                            }
                        }.listRowSeparatorTint(Color.theme.backgroundsecondary)
                            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    } else {
                        ForEach(presenter.stocks.filter { stock -> Bool in
                            stock.symbol.lowercased().contains(searchText.lowercased()) || (searchText.isEmpty)
                        }) { stock in
                            ZStack {
                                Button(Strings.empty) {
                                    presenter.setStock2(stock: stock.symbol)
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                                    StockSearchListItem(stock: stock)
                            }
                        }.listRowSeparatorTint(Color.theme.backgroundsecondary)
                            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                }
                .background(Color.theme.backgroundcolor)
                .scrollContentBackground(.hidden)
                .listStyle(PlainListStyle())
            }
        }.background(Color.theme.backgroundcolor)
    }

    var searchBarBlock: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color(UIColor.systemGray5))
            HStack {
                Image.magnifyglass
                TextField(Strings.search, text: $searchText) { startedEditing in
                    if startedEditing {
                        withAnimation {
                            searching = true
                        }
                    }
                } onCommit: {
                    withAnimation {
                        searching = false
                    }
                }
                .accessibilityIdentifier("SeachBarTextField")
                .disableAutocorrection(true)
            }
            .foregroundColor(.gray)
            .padding(.leading, 13)
        }
        .frame(height: 40)
        .cornerRadius(13)
        .padding()
    }
}

enum BuyOrSell {
    case toBuy
    case toSell
}
