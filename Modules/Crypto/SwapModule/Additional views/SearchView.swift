import SwiftUI

struct SearchView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var searchText = ""
    @State var searching = false
    var coinname: String = "coin1"
    @ObservedObject var presenter: SwapPresenter

    var body: some View {
        ZStack {
            Color.theme.backgroundcolor
            VStack(alignment: .leading) {
                searchBarBlock
                List {
                    if coinname == "coin1" {
                        ForEach(presenter.coins.filter { coin -> Bool in
                            // swiftlint:disable:next line_length
                            presenter.ownedcoins.contains { $0.coinid == coin.id } && (coin.name.hasPrefix(searchText) || coin.symbol.hasPrefix(searchText.lowercased()) || (searchText.isEmpty))
                        }) { coin in
                            ZStack {
                                Button(Strings.empty) {
                                    presenter.setCoin1(coin1: coin.id)
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                                SearchListItem(coin: coin)
                            }
                        }
                        .listRowSeparatorTint(Color.theme.backgroundsecondary)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    } else {
                        ForEach(presenter.coins.filter { coin -> Bool in
                            coin.name.hasPrefix(searchText) || coin.symbol.hasPrefix(searchText.lowercased()) || (searchText.isEmpty)
                        }) { coin in
                            ZStack {
                                Button(Strings.empty) {
                                    presenter.setCoin2(coin2: coin.id)
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                                SearchListItem(coin: coin)
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
struct SearchBar: View {
    @Binding var searchText: String
    @Binding var searching: Bool

    var body: some View {
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

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
