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
    
    public init(viewModel: RecipesFeedViewModel = RecipesFeedViewModel(recipes: []), webImageProvider: any WebImageProviding = WebImageProvider()) {
        self.viewModel = viewModel
        self.webImageProvider = webImageProvider
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.recipes) {
                    RecipeView(recipe: $0, webImageProvider: webImageProvider)
                }
                Spacer()
            }
        }
        .padding()
        .task {
            do {
                // TODO: handle mailformed and empty response.
                let (jsonData, response) = try await URLSession.shared.data(from: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!)
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else { return }
                let recipes = try JSONDecoder().decode(Feed.self, from: jsonData)
                self.viewModel.recipes = recipes.recipes
            } catch(let error) {
                print(error)
            }
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
