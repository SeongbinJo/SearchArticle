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
