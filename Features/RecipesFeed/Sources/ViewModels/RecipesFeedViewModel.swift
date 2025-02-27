//
//  RecipesFeedViewModel.swift
//  FetchRecipes
//
//  Created by Sergii D on 2/13/25.
//
import Foundation

@MainActor
final class RecipesFeedViewModel: ObservableObject {
    enum State {
        case none
        case loading
        case error(Error)
        case feedLoaded([Recipe])
    }
    
    private let businessLogic: any RecipesFeedBusinessLogicProvidable
    
    @Published var state: State = .none
    
    init(businessLogic: any RecipesFeedBusinessLogicProvidable = RecipesFeedBusinessLogic()) {
        self.businessLogic = businessLogic
    }
    
    func fetchRecipes() {
        Task {
            do {
                state = .loading
                state = .feedLoaded(try await businessLogic.loadFeed())
            } catch(let error) {
                state = .error(error)
            }
        }
    }
}
