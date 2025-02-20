//
//  ContentView.swift
//  FetchRecipes
//
//  Created by Sergii D on 2/13/25.
//

import SwiftUI
import WebImage

public struct RecipesFeedView: View {
    @ObservedObject private var viewModel: RecipesFeedViewModel
    let webImageProvider: any WebImageProviding
    let recipesFeedApi: any RecipesFeedProviding
    
    public init(viewModel: RecipesFeedViewModel = RecipesFeedViewModel(), recipesFeedApi: any RecipesFeedProviding = RecipesFeedApi(), webImageProvider: any WebImageProviding = WebImageProvider()) {
        self.viewModel = viewModel
        self.webImageProvider = webImageProvider
        self.recipesFeedApi = recipesFeedApi
    }
    
    public var body: some View {
        VStack {
            if let recipes = viewModel.recipes {
                if recipes.isEmpty {
                    Text("No recipes are available!")
                    Button("Reload") {
                        Task {
                            await loadFeed(from: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!)
                        }
                    }
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(recipes) {
                                RecipeView(recipe: $0, webImageProvider: webImageProvider)
                            }
                            Spacer()
                        }
                    }
                    .refreshable {
                        await loadFeed()
                    }
                }
            }
        }
        .padding()
        .task {
            await loadFeed()
        }
    }
    
    func loadFeed(from url: URL? = nil) async {
        do {
            // MARK: change urls to test scenarios
            /// all recipes: https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json
            /// malformed: https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json
            /// empty data: https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json
            let feed = try await recipesFeedApi.fetchRecipesFeed(from: url ?? URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!)
            viewModel.recipes = feed.recipes
        } catch(let error) {
            print(error)
        }
    }
}

#Preview {
    RecipesFeedView(viewModel: RecipesFeedViewModel(recipes: [
        Recipe(cuisine: "Malaysian",
               name: "Apam Balik",
               photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
               photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
               sourceURL: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
               uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
               youtubeURL: "https://www.youtube.com/watch?v=6R8ffRRJcrg"),
        Recipe(cuisine: "British",
               name: "Apple & Blackberry Crumble",
               photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
               photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
               sourceURL: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
               uuid: "599344f4-3c5c-4cca-b914-2210e3b3312f",
               youtubeURL: "https://www.youtube.com/watch?v=rp8Slv4INLk")
    ]))
}

#Preview("Empty Recipes List") {
    RecipesFeedView(viewModel: RecipesFeedViewModel(recipes: []))
}

