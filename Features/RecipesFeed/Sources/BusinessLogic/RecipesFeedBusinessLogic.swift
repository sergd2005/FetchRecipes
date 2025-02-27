//
//  RecipesFeedBusinessLogic.swift
//  RecipesFeed
//
//  Created by Sergii D on 2/27/25.
//
import Foundation

protocol RecipesFeedBusinessLogicProvidable: Sendable {
    func loadFeed() async throws -> [Recipe]
}

actor RecipesFeedBusinessLogic {
    private let recipesFeedApi: any RecipesFeedProviding
    
    init(recipesFeedApi: any RecipesFeedProviding = RecipesFeedApi()) {
        self.recipesFeedApi = recipesFeedApi
    }
}

extension RecipesFeedBusinessLogic: RecipesFeedBusinessLogicProvidable {
    func loadFeed() async throws -> [Recipe] {
        try await recipesFeedApi.fetchRecipesFeed().recipes
    }
}
