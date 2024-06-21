//
//  DetailArticleView.swift
//  SearchArticle
//
//  Created by 조성빈 on 6/21/24.
//

import SwiftUI

struct DetailArticleView: View {
    var article: NewsItem
    
    var body: some View {
        Form {
            Section {
                Text(article.title)
            }
            Section(content: {
                Text(article.link)
                Text(article.originallink)
            }, footer: {
                
            })
            Section(content: {
                Text(article.description)
            }, footer: {
                Text(article.pubDate)
            })
        }
    }
}

#Preview {
    DetailArticleView(article: NewsItem(title: "테스트 제목입니다.", link: "Http~~", originallink: "Http~", description: "매그네~~~~틱!", pubDate: "오늘."))
}
