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
    
    init(viewModel: RecipesFeedViewModel, webImageProvider: any WebImageProviding = WebImageProvider()) {
        self.viewModel = viewModel
        self.webImageProvider = webImageProvider
    }
    
    public init() {
        self.init(viewModel: RecipesFeedViewModel(), webImageProvider: WebImageProvider())
    }
    
    public var body: some View {
        switch viewModel.state {
        case .none:
            VStack {
            }
            .task {
                loadFeed()
            }
        case .error(let error):
            Text("Error occured:\(error)")
        case .loading:
            ProgressView()
        case .feedLoaded(let recipes):
            VStack {
                if recipes.isEmpty {
                    Text("No recipes are available!")
                    Button("Reload") {
                        Task {
                            loadFeed()
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
                        loadFeed()
                    }
                }
            }
            .padding()
        }
    }
    
    func loadFeed() {
        viewModel.fetchRecipes()
    }
}

#Preview {
    RecipesFeedView(viewModel: RecipesFeedViewModel(businessLogic: MockRecipesFeedBusinessLogic(feedToReturn: [
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
    ])))
}

#Preview("Empty Recipes List") {
    RecipesFeedView(viewModel: RecipesFeedViewModel(businessLogic: MockRecipesFeedBusinessLogic(feedToReturn: [])))
}

