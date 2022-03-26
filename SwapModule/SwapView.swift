//
//  SwapView.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 25..
//

import SwiftUI



struct SwapView: View {
    @ObservedObject var presenter: SwapPresenter
    var body: some View {
        
        presenter.makeButtonForSelector()
        Text(presenter.selected(coin: presenter.coin1))
    }
        /*
        NavigationView {
                    VStack(alignment: .leading) {
                        SearchBar(searchText: $searchText, searching: $searching)
                        List {
                            ForEach(presenter.coins.filter({ (coin) -> Bool in
                                return coin.name.hasPrefix(searchText) || coin.id.hasPrefix(searchText) || searchText == ""
                            })) { coin in
                                Text(coin.name)
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
    }*/
        /* VStack{
            HStack{
                VStack{
                    Text("Coin to sell")
                }
                VStack{
                    Text("Coin to buy")
                    Text("Selector")
                }
            }
        ZStack{
            Color.theme.backgroundcolor
            HStack{
                VStack{
                    Text("Egyik coin")
                    presenter.makeButtonForSelector()
                    
                }
                VStack{
                    Text("Másik coin")
                    
                    
                }
            }
            
        }
           
            Picker("Flavor", selection: $coin) {
                ForEach(presenter.coins) { coin in
                    Text(coin.name)
                }
            } */
}
/*
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
struct SearchBar: UIViewRepresentable {

    @Binding var text: String
    var placeholder: String

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator

        searchBar.placeholder = placeholder
        searchBar.autocapitalizationType = .none
        searchBar.searchBarStyle = .minimal
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }

    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }
}

struct SwapView_Previews: PreviewProvider {
    static var previews: some View {
        SwapView(presenter: SwapPresenter(interactor: SwapInteractor(model: DataModel())))
    }
}*/
 */
