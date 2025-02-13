//
//  RecipesFeedViewModel.swift
//  FetchRecipes
//
//  Created by Sergii D on 2/13/25.
//
import Foundation

public class RecipesFeedViewModel: ObservableObject {
    @Published var recipes: [Recipe]
    
    public init(recipes: [Recipe]) {
        self.recipes = recipes
    }
}
