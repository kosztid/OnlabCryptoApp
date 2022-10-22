import SwiftUI

//struct SearchView: View {
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    @State var searchText = ""
//    @State var searching = false
//    // @Binding var searchText: String
//    // @Binding var searching: Bool
//    var coinname: String = "coin1"
//    var list: [CoinModel]
//
//    var body: some View {
//        ZStack {
//            Color.theme.backgroundcolor
//            VStack(alignment: .leading) {
//                searchBarBlock
//                List {
//                        ForEach(list) { coin in
//                            ZStack {
//                                Button("") {
//                                    print(coin.id)
//                                    self.presentationMode.wrappedValue.dismiss()
//                                }
//                                SearchListItem(coin: coin)
//                            }
//                        }
//                        .listRowSeparatorTint(Color.theme.backgroundsecondary)
//                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
//                }
//                .background(Color.theme.backgroundcolor)
//                .scrollContentBackground(.hidden)
//                .listStyle(PlainListStyle())
//            }
//        }.background(Color.theme.backgroundcolor)
//    }
//
//    var searchBarBlock: some View {
//        ZStack {
//            Rectangle()
//                .foregroundColor(Color("LightGray"))
//            HStack {
//                Image(systemName: "magnifyingglass")
//                TextField("Search ..", text: $searchText) { startedEditing in
//                    if startedEditing {
//                        withAnimation {
//                            searching = true
//                        }
//                    }
//                } onCommit: {
//                    withAnimation {
//                        searching = false
//                    }
//                }
//                .accessibilityIdentifier("SeachBarTextField")
//                .disableAutocorrection(true)
//            }
//            .foregroundColor(.gray)
//            .padding(.leading, 13)
//        }
//        .frame(height: 40)
//        .cornerRadius(13)
//        .padding()
//    }
//}

struct SearchView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var searchText = ""
    @State var searching = false
    // @Binding var searchText: String
    // @Binding var searching: Bool
    var coinname: String = "coin1"
    @ObservedObject var presenter: SwapPresenter

    var body: some View {
        ZStack {
            Color.theme.backgroundcolor
            VStack(alignment: .leading) {
                searchBarBlock
                List {
                    if coinname == "coin1" {
                        ForEach(presenter.coins.filter({ (coin) -> Bool in
                            // swiftlint:disable:next line_length
                            return presenter.ownedcoins.filter({ $0.coinid == coin.id }).isEmpty == false && (coin.name.hasPrefix(searchText) || coin.symbol.hasPrefix(searchText.lowercased()) || (searchText == ""))
                        })) { coin in
                            ZStack {
                                Button("") {
                                    presenter.setCoin1(coin1: coin.id)
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                                SearchListItem(coin: coin)
                            }
                        }
                        .listRowSeparatorTint(Color.theme.backgroundsecondary)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    } else {
                        ForEach(presenter.coins.filter({ (coin) -> Bool in
                            return coin.name.hasPrefix(searchText) || coin.symbol.hasPrefix(searchText.lowercased()) || (searchText == "")
                        })) { coin in
                            ZStack {
                                Button("") {
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
    }
}
struct SearchBar: View {

    @Binding var searchText: String
    @Binding var searching: Bool

    var body: some View {
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
    }
}

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}