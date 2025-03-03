//
//  RecipeView.swift
//  FetchRecipes
//
//  Created by Sergii D on 2/13/25.
//

import SwiftUI
import WebImage
import WebImageView

public struct RecipeView: View {
    private let recipe: Recipe
    let webImageProvider: any WebImageProviding
    
    init(recipe: Recipe, webImageProvider: any WebImageProviding = WebImageProvider()) {
        self.recipe = recipe
        self.webImageProvider = webImageProvider
    }
    
    public var body: some View {
        VStack {
            WebImageView(url: URL(string: recipe.photoURLLarge),
                         cacheKey: { $0.pathComponents[$0.pathComponents.count - 2] },
                         webImageProvider: webImageProvider) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(15)
            } placeHolder: {
                ProgressView()
            }
            .padding()
            Text("Name: " + recipe.name)
            Text("Cuisine: " + recipe.cuisine)
                .padding(.bottom)
        }
        .background(.gray.opacity(0.1))
        .cornerRadius(15)
    }
}

#Preview {
    RecipeView(recipe: Recipe(cuisine: "Malaysian",
                              name: "Apam Balik",
                              photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                              photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                              sourceURL: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                              uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                              youtubeURL: "https://www.youtube.com/watch?v=6R8ffRRJcrg"))
}
