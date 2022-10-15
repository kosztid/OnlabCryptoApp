import SwiftUI

struct StockSwapView: View {
    @ObservedObject var presenter: StockSwapPresenter
    @State private var showingAlert = false
    @FocusState private var keyboardIsFocused: Bool
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    var body: some View {
        ZStack {
            Color.theme.backgroundcolor

            VStack {
                HStack {
                    Spacer()
                    VStack {
                        Text("From")
                            .font(.system(size: 26))
                            .bold()
                        presenter.makeButtonForSelector(bos: .toSell)
                            .accessibilityIdentifier("StockSwapSellSelectorButton")
                        Text(presenter.selected(stockSymbol: presenter.stock1).symbol)
                                .font(.system(size: 20))
                        VStack {
                            Text("Owned:")
                            Text("\(presenter.ownedamount(stockSymbol: presenter.stock1)) \(presenter.selected(stockSymbol: presenter.stock1).symbol) ")
                        }.font(.system(size: 12))
                        TextField("Amount to sell", value: .init(
                            get: { self.presenter.stockstosell },
                            set: { self.presenter.setStockstosell(amount: Double($0)) }
                        ), formatter: formatter, onEditingChanged: { (changed) in
                            // presenter.self.coinstosell = self.coinstosell
                            if changed {
                                presenter.setBuyorSell(boolean: "sell")
                            } else {
                                presenter.setBuyAmount()
                            }
                        }).padding(.horizontal)
                            .frame(height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .font(.system(size: 20))
                            .foregroundColor(Color.theme.accentcolor)
                            .background(Color.theme.backgroundcolor)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.theme.accentcolorsecondary, lineWidth: 2))
                            .cornerRadius(10)
                            .disableAutocorrection(true)
                            .keyboardType(.numberPad)
                            .accessibilityIdentifier("StockSwapSellTextField")
                    }
                    .font(.system(size: 24))
                    .foregroundColor(Color.theme.accentcolor)
                    Spacer()
                    Image(systemName: "arrow.right")
                        .font(.system(size: 26))
                    Spacer()
                    VStack {
                        Text("To")
                            .font(.system(size: 26))
                            .bold()
                        presenter.makeButtonForSelector(bos: .toBuy)
                            .accessibilityIdentifier("StockSwapBuySelectorButton")
                            Text(presenter.selected(stockSymbol: presenter.stock2).symbol)
                                .font(.system(size: 20))
                        VStack {
                            Text("Owned:")
                            Text("\(presenter.ownedamount(stockSymbol: presenter.stock2)) \(presenter.selected(stockSymbol: presenter.stock2).symbol) ")
                        }.font(.system(size: 12))

                        TextField("Amount to buy", value: .init(
                            get: { self.presenter.stockstobuy },
                            set: { self.presenter.setStockstobuy(amount: Double($0)) }
                        ), formatter: formatter, onEditingChanged: { (changed) in
                            if changed {
                                presenter.setBuyorSell(boolean: "buy")
                            } else {
                                presenter.setSellAmount()
                            }
                        })
                            .padding(.horizontal)
                            .frame(height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .font(.system(size: 20))
                            .foregroundColor(Color.theme.accentcolor)
                            .background(Color.theme.backgroundcolor)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.theme.accentcolorsecondary, lineWidth: 2))
                            .cornerRadius(10)
                            .disableAutocorrection(true)
                            .keyboardType(.numberPad)
                            .accessibilityIdentifier("StockSwapBuyTextField")
                    }
                    .font(.system(size: 24))
                    .foregroundColor(Color.theme.accentcolor)
                    Spacer()
                }
                .padding(10)
                HStack(alignment: .center) {
                    presenter.makeButtonForSwap()
                        .accessibilityIdentifier("StockSwapButton")
                }
            }
            .focused($keyboardIsFocused)
        }
        .onDisappear {
            keyboardIsFocused = false
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Kész") {
                    keyboardIsFocused = false
                }
            }
        }
        .background(Color.theme.backgroundcolor)
    }
}
