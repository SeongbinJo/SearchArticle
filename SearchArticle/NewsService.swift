//
//  NewsService.swift
//  SearchArticle
//
//  Created by 조성빈 on 6/21/24.
//

import Foundation
import Combine

class NewsService {
    
    func searchNews(keyword: String) -> AnyPublisher<[NewsItem], Error> {
        guard let id = Bundle.main.client_Id else {
            print("API ID 가져오기 실패")
            return Fail(error: ApiAcountError.failedId).eraseToAnyPublisher()
        }
        
        guard let secret = Bundle.main.client_Secret else {
            print("API Secret 가져오기 실패")
            return Fail(error: ApiAcountError.failedSecret).eraseToAnyPublisher()
        }
        
        var urlComponents = URLComponents(string: "https://openapi.naver.com/v1/search/news.json")!
        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: keyword),
            URLQueryItem(name: "display", value: "5")
        ]
        
        var request = URLRequest(url: urlComponents.url!)
        request.addValue(id, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(secret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        let dataTaskPublisher = URLSession.shared.dataTaskPublisher(for: request)
        
        return dataTaskPublisher
            .map(\.data)
            .tryMap { data -> News in
                let decoder = JSONDecoder()
                do {
                    return try decoder.decode(News.self, from: data)
                } catch {
                    throw NewsApiError.decodingError(error)
                }
            }
            .map(\.newsItem)
            .eraseToAnyPublisher()
    }
    
}
