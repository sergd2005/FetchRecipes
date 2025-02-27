//
//  MockRecipesFeedBusinessLogic.swift
//  RecipesFeed
//
//  Created by Sergii D on 2/27/25.
//
import Foundation

actor MockRecipesFeedBusinessLogic: RecipesFeedBusinessLogicProvidable {
    private var feedToReturn: [Recipe]?
    private var error: Error?
    
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
    
    func setFeed(_ feed: [Recipe]? = nil, error: Error? = nil) {
        self.feedToReturn = feed
        self.error = error
    }
}
