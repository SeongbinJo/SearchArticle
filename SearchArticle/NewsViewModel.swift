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
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var searchNewsPublisher: AnyPublisher<[NewsItem], Never> = {
        $keyword
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { keyword in
                self.newsService.searchNews(keyword: keyword)
                    .catch { _ in
                        Just([])
                    }
            }
            .receive(on: DispatchQueue.main)
            .share()
            .eraseToAnyPublisher()
    }()
    
    init() {
        searchNewsPublisher
            .assign(to: \.newsItems, on: self)
            .store(in: &cancellables)

    }
}
