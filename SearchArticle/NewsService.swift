//
//  NewsService.swift
//  SearchArticle
//
//  Created by 조성빈 on 6/21/24.
//

import Foundation
import Combine

class NewsService {
    private let id: String
    private let secret: String
    
    init() {
        guard let id = Bundle.main.client_Id else {
            print("API ID 가져오기 실패")
            fatalError("Client_ID, Secret Error")
        }
        
        guard let secret = Bundle.main.client_Secret else {
            print("API Secret 가져오기 실패")
            fatalError("Client_ID, Secret Error")
        }
        self.id = id
        self.secret = secret
    }
    
    func searchNews(keyword: String) -> AnyPublisher<[NewsItem], Error> {
        var urlComponents = URLComponents(string: "https://openapi.naver.com/v1/search/news.json")!
        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: keyword),
            URLQueryItem(name: "display", value: "5")
        ]
        
        var request = URLRequest(url: urlComponents.url!)
        request.addValue(self.id, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(self.secret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        let dataTaskPublisher = URLSession.shared.dataTaskPublisher(for: request)
        
        return dataTaskPublisher
            .map(\.data)
            .tryMap { data -> NewsResponse in
                let decoder = JSONDecoder()
                
                if let jsonString = String(data: data, encoding: .utf8) {
                                    print("서버 답 : \(jsonString)")
                                }
                
                do {
                    return try decoder.decode(NewsResponse.self, from: data)
                } catch {
                    print("Decoding Error : \(error)")
                    throw NewsApiError.decodingError(error)
                }
            }
            .map(\.items)
            .eraseToAnyPublisher()
    }
    
}
