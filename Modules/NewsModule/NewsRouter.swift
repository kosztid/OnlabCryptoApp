//
//  NewsRouter.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 03. 18..
//

import Foundation
import SwiftUI

class NewsRouter{
    func makeNewsDetailView(article: Article) -> some View{
        return NewsDetailView(article: article)
    }
}
