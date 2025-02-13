//
//  RecipesFeedViewModel.swift
//  FetchRecipes
//
//  Created by Sergii D on 2/13/25.
//
import Foundation

class RecipesFeedViewModel: ObservableObject {
    @Published var recipes: [Recipe]
    
    init(recipes: [Recipe]) {
        self.recipes = recipes
    }
}
