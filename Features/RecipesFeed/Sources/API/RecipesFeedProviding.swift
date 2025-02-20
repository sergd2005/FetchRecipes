//
//  RecipesFeedProviding.swift
//  RecipesFeed
//
//  Created by Sergii D on 2/19/25.
//
import Foundation

public protocol RecipesFeedProviding: Sendable {
    func fetchRecipesFeed(from url: URL) async throws -> Feed
}
