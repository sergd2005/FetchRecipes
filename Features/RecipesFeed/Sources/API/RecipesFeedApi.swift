//
//  RecipesFeedApi.swift
//  RecipesFeed
//
//  Created by Sergii D on 2/19/25.
//

import Foundation
import Network

public enum RecipesFeedApiError: Error {
    case badHttpResponse
    case badJSONData
}

public final class RecipesFeedApi {
    let networkProvider: any NetworkProviding
    
    public init(networkProvider: any NetworkProviding = URLSessionProvider()) {
        self.networkProvider = networkProvider
    }
}

// MARK: RecipesFeedProviding
extension RecipesFeedApi: RecipesFeedProviding {
    public func fetchRecipesFeed(from url: URL) async throws -> Feed {
        let (jsonData, response) = try await networkProvider.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else { throw RecipesFeedApiError.badHttpResponse }
        do {
            return try JSONDecoder().decode(Feed.self, from: jsonData)
        } catch {
            throw RecipesFeedApiError.badJSONData
        }
    }
}
