//
//  Constants.swift
//  Hardik's Task
//
//  Created by Hardik D on 23/04/25.
//

// MARK: - APIConstants
struct Constants {
    static let baseURL = "https://api.unsplash.com/search/photos"
    static let apiKey = "-nXquZuX_wXU6AUzZvdNbJkW5az23vG02KwWVIVkE38"
}

// MARK: - APIParameterKey

enum APIParameterKey: String {
    case page
    case perPage = "per_page"
    case query
    case clientID = "client_id"
}

// MARK: - APIError Enum

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case unknown
}
