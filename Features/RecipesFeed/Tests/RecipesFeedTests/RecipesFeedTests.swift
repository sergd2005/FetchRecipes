import Testing
@testable import RecipesFeed

@MainActor
class Tests {
    let viewModel = RecipesFeedViewModel()
    let mockBusinessLogic = MockRecipesFeedBusinessLogic()
    
    @Test func loadFeed() async throws {
        let mockedRecipes = [Recipe(cuisine: "", name: "Mocked", photoURLLarge: "", photoURLSmall: "", sourceURL: "", uuid: "", youtubeURL: "")]
        await mockBusinessLogic.setFeed(mockedRecipes)
        
        viewModel.businessLogic = mockBusinessLogic
        
        var states = [RecipesFeedViewModel.State]()
        let expectedValues: [RecipesFeedViewModel.State] = [.none, .loading, .feedLoaded(mockedRecipes)]
        let cancellable = viewModel.$state.sink {
            states.append($0)
        }
        await viewModel.fetchRecipes()
        #expect(expectedValues == states)
    }
    
    @Test func loadWithError() async throws {
        await mockBusinessLogic.setFeed(error: RecipesFeedApiError.badHttpResponse)
        
        viewModel.businessLogic = mockBusinessLogic
        
        var states = [RecipesFeedViewModel.State]()
        let expectedValues: [RecipesFeedViewModel.State] = [.none, .loading, .feedError(RecipesFeedApiError.badHttpResponse)]
        let cancellable = viewModel.$state.sink {
            states.append($0)
        }
        await viewModel.fetchRecipes()
        #expect(expectedValues == states)
    }
}
