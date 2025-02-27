//
//  MockRecipesFeedBusinessLogic.swift
//  RecipesFeed
//
//  Created by Sergii D on 2/27/25.
//
import Foundation

actor MockRecipesFeedBusinessLogic: RecipesFeedBusinessLogicProvidable {
    var feedToReturn: [Recipe]?
    var error: Error?
    
    init(feedToReturn: [Recipe]? = nil, error: Error? = nil) {
        self.feedToReturn = feedToReturn
        self.error = error
    }
    
    func loadFeed() async throws -> [Recipe] {
        if let feedToReturn {
            return feedToReturn
        }
        if let error {
            throw error
        }
        return []
    }
}
