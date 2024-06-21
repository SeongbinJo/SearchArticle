//
//  News.swift
//  SearchArticle
//
//  Created by 조성빈 on 6/21/24.
//

import Foundation

enum ApiAcountError: Error {
    case failedId
    case failedSecret
}

enum NewsApiError: LocalizedError {
    case invalidResponse
    case invalidRequestError(String)
    case transportError(Error)
    case validationError(String)
    case decodingError(Error)
    case serverError(statusCode: Int, reason: String? = nil, retryAfter: String? = nil)
    
    var errorDescription: String? {
        switch self {
        case .invalidRequestError(let message):
            return "Invalid request: \(message)"
        case .transportError(let error):
            return "Transport error: \(error)"
        case .invalidResponse:
            return "Invalid response"
        case .validationError(let reason):
            return "Validation error: \(reason)"
        case .decodingError:
            return "The server returned data in an unexpected format. Try updating the app."
        case .serverError(let statusCode, let reason, let retryAfter):
            return "Server error with code \(statusCode), reason: \(reason ?? "no reason"), retryAfter: \(retryAfter ?? "no retry after provided.")"
        }
    }
}

struct NewsItem: Codable, Identifiable {
    let id = UUID()
    let title: String
    let link: String
    let originallink: String
    let description: String
    let pubDate: String

    enum CodingKeys: String, CodingKey {
        case title, link, originallink, description, pubDate
    }
}

struct NewsResponse: Codable {
    let items: [NewsItem]
}
