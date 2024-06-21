//
//  NewsViewModel.swift
//  SearchArticle
//
//  Created by 조성빈 on 6/21/24.
//

import Foundation
import Combine

class NewsViewModel: ObservableObject {
    @Published var newsItems: [NewsItem] = []
    @Published var errorMessage: String = ""
    
    @Published var keyword: String = ""
    
    private var newsService = NewsService()
    
    private lazy var searchNewsPublisher: AnyPublisher<[NewsItem], Never> = {
        $keyword
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { keyword in
                self.newsService.searchNews(keyword: keyword)
                    .catch { _ in
                        Just([])
                    } // 에러를 처리하여 빈 배열을 반환
            }
            .receive(on: DispatchQueue.main)
            .share()
            .eraseToAnyPublisher()
    }()
    
    init() {
        searchNewsPublisher
            .print("\(self.newsItems)")
            .assign(to: &$newsItems)
    }
}
