//
//  RecipesFeedViewModel.swift
//  FetchRecipes
//
//  Created by Sergii D on 2/13/25.
//
import Foundation

@MainActor
final class RecipesFeedViewModel: ObservableObject {
    enum State: Equatable {
        static func == (lhs: RecipesFeedViewModel.State, rhs: RecipesFeedViewModel.State) -> Bool {
            switch (lhs, rhs) {
            case (.none, .none),
                (.loading, loading):
                return true
            case (.feedLoaded(let lhsFeed), .feedLoaded(let rhsFeed)):
                return lhsFeed == rhsFeed
            case (.feedError(let lhsError), .feedError(let rhsError)):
                return lhsError == rhsError
            default:
                return false
            }
        }
        
        case none
        case loading
        case feedError(RecipesFeedApiError)
        case undefinedError(Error)
        case feedLoaded([Recipe])
    }
    
    var businessLogic: any RecipesFeedBusinessLogicProvidable
    
    @Published var state: State = .none
    
    init(businessLogic: any RecipesFeedBusinessLogicProvidable = RecipesFeedBusinessLogic()) {
        self.businessLogic = businessLogic
    }
    
    func fetchRecipes() async {
        do {
            state = .loading
            state = .feedLoaded(try await businessLogic.loadFeed())
        } catch let error as RecipesFeedApiError {
            state = .feedError(error)
        } catch(let error) {
            state = .undefinedError(error)
        }
    }
}
