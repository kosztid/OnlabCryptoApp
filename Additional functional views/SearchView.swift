//
//  SearchView.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 26..
//

import SwiftUI

struct SearchView: View {
    @State var searchText = ""
    @State var searching = false
    @ObservedObject var presenter: SwapPresenter
    var body: some View {
        NavigationView {
                    VStack(alignment: .leading) {
                        SearchBar(searchText: $searchText, searching: $searching)
                        List {
                            ForEach(presenter.coins.filter({ (coin) -> Bool in
                                return coin.name.hasPrefix(searchText) || coin.symbol.hasPrefix(searchText.lowercased()) || searchText == ""
                            })) { coin in
                                Button(coin.name){
                                    presenter.coin1 = coin.name
                                }
                            }
                        }
                            .listStyle(GroupedListStyle())
                            .navigationTitle("Select a coin")
                            .toolbar {
                                if searching {
                                    Button("Cancel") {
                                        searchText = ""
                                        withAnimation {
                                           searching = false
                                           UIApplication.shared.dismissKeyboard()
                                        }
                                    }
                                }
                            }
                            .gesture(DragGesture()
                                        .onChanged({ _ in
                                UIApplication.shared.dismissKeyboard()
                                        })
                            )
                    }
                }
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
/*
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
*/
