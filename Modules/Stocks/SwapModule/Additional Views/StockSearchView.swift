import SwiftUI

struct StockSearchView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var searchText = ""
    @State var searching = false
    // @Binding var searchText: String
    // @Binding var searching: Bool
    var buyOrSell: BuyOrSell = .toSell
    @ObservedObject var presenter: StockSwapPresenter

    var body: some View {
        ZStack {
            Color.theme.backgroundcolor
            VStack(alignment: .leading) {
                /*SearchBar(searchText: $searchText, searching: $searching)
                    .frame(height:40)
                    .accessibility(identifier: "SeachBar")
                */
                ZStack {
                    Rectangle()
                        .foregroundColor(Color("LightGray"))
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Search ..", text: $searchText) { startedEditing in
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
                List {
                    if buyOrSell == .toSell {
                        ForEach(presenter.stocks.filter({ (stock) -> Bool in
                            // swiftlint:disable:next line_length
                            return presenter.ownedStocks.filter({ $0.stockSymbol == stock.symbol }).isEmpty == false && stock.symbol.lowercased().contains(searchText.lowercased()) || (searchText == "")
                        })) { stock in
                            ZStack {
                                Button("") {
                                    presenter.setStock1(stock: stock.symbol)
                                    presenter.setBuyAmount()
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                                StockSearchListItem(stock: stock)
                            }
                        }.listRowSeparatorTint(Color.theme.backgroundsecondary)
                            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    } else {
                        ForEach(presenter.stocks.filter({ (stock) -> Bool in
                            return stock.symbol.lowercased().contains(searchText.lowercased()) || (searchText == "")
                        })) { stock in
                            ZStack {
                                Button("") {
                                    if buyOrSell == .toSell {
                                        presenter.setStock1(stock: stock.symbol)
                                        presenter.setBuyAmount()
                                    } else {
                                        presenter.setStock2(stock: stock.symbol)
                                        presenter.setSellAmount()
                                    }
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                                if buyOrSell == .toSell {
                                    if presenter.isOwned(stock: stock) {
                                        StockSearchListItem(stock: stock)
                                    }
                                } else {
                                    StockSearchListItem(stock: stock)
                                }
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
}

enum BuyOrSell {
    case toBuy
    case toSell
}
