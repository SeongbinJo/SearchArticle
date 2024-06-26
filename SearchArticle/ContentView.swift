//
//  ContentView.swift
//  SearchArticle
//
//  Created by 조성빈 on 6/21/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = NewsViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                Section(content: {
                    TextField("검색", text: $viewModel.keyword)
                }, footer: {})
                Section(content: {
                    ForEach(viewModel.newsItems, id: \.id) { news in
                        NavigationLink(destination: DetailArticleView(article: news)) {
                            Text(news.title)
                        }
                    }
                })
            }
        }
    }
}

#Preview {
    ContentView()
}
