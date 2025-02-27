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
    
    // MARK: change urls to test scenarios
    /// all recipes: https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json
    /// malformed: https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json
    /// empty data: https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json
    /// 
    private let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
    
    let networkProvider: any NetworkProviding
    
    public init(networkProvider: any NetworkProviding = URLSessionProvider()) {
        self.networkProvider = networkProvider
    }
}

// MARK: RecipesFeedProviding
extension RecipesFeedApi: RecipesFeedProviding {
    public func fetchRecipesFeed() async throws -> Feed {
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
