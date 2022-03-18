//
//  NewsView.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 18..
//

import SwiftUI

struct NewsView: View {
    @ObservedObject var presenter: NewsPresenter
    var body: some View {
        ZStack{
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            
            List{
                ForEach(presenter.news.articles!, id:\.self){ article in
                    ZStack{
                        Color.theme.backgroundcolor
                                .ignoresSafeArea()
                            
                        NewsListItem(presenter: presenter, article: article)
                            .frame(height: 60)
                        self.presenter.linkBuilder(for: article){
                            EmptyView()
                        }.buttonStyle(PlainButtonStyle())
                    }
                    
                }
                .listRowSeparatorTint(Color.theme.backgroundsecondary)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .listStyle(PlainListStyle())
        }
        
    }
}
/*
struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}
*/
