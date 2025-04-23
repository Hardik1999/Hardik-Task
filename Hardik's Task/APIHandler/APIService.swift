//
//  APIService.swift
//  Hardik's Task
//
//  Created by Hardik D on 23/04/25.
//

import Foundation

// MARK: - APIService

final class APIService {
    private let session: URLSession
    private let query = "animal" // You can make this dynamic if needed

    init(session: URLSession = .shared) {
        self.session = session
    }

    // Function to fetch images
    func fetchImages(page: Int = 1, perPage: Int = 20) async throws -> [ImageDataModel] {
        guard let url = buildURL(page: page, perPage: perPage) else {
            throw APIError.invalidURL
        }

        do {
            // Perform network request
            let (data, response) = try await session.data(from: url)

            // Optional: Validate HTTP response status code
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                throw APIError.unknown
            }

            // Decode the response into ImageResponseModel
            do {
                let result = try JSONDecoder().decode(ImageResponseModel.self, from: data)
                return result.results
            } catch {
                throw APIError.decodingError(error)
            }

        } catch {
            throw APIError.networkError(error)
        }
    }

    // Helper function to build the URL
    private func buildURL(page: Int, perPage: Int) -> URL? {
        var components = URLComponents(string: Constants.baseURL)
        components?.queryItems = [
            URLQueryItem(name: APIParameterKey.clientID.rawValue, value: Constants.apiKey),
            URLQueryItem(name: APIParameterKey.query.rawValue, value: query),
            URLQueryItem(name: APIParameterKey.page.rawValue, value: "\(page)"),
            URLQueryItem(name: APIParameterKey.perPage.rawValue, value: "\(perPage)")
        ]
        return components?.url
    }
}
