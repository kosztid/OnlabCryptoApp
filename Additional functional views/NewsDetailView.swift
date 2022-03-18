//
//  NewsDetailView.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 18..
//

import SwiftUI

struct NewsDetailView: View {
    var article: Article
    var body: some View {
        ZStack{
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            VStack{
                HStack{
                    VStack{
                        Text(article.title ?? "Nincs cím")
                            .frame(alignment: .leading)
                            .font(.system(size: 20))
                        Text(article.author ?? "Nincs szerző")
                            .frame(alignment: .leading)
                            .font(.system(size: 16))
                    }
                }
                HStack{
                    
                }
            }
        }
            
    }
}
/*
struct NewsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NewsDetailView()
    }
}
*/
