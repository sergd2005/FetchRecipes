import Testing
@testable import DependencyInjection

extension Dependencies {
    var networkProvider: any NetworkProviding {
        get { Self[NetworkDependencyProvider.self] }
    }
}

private struct NetworkDependencyProvider: DependencyProviding {
    nonisolated(unsafe) static var dependency: any NetworkProviding = NetworkProvider()
}

protocol NetworkProviding {
    func requestData()
}

struct NetworkProvider: NetworkProviding, Equatable {
    func requestData() {
        print("Data requested using the `NetworkProvider`")
    }
}

struct MockedNetworkProvider: NetworkProviding, Equatable {
    func requestData() {
        print("Data requested using the `MockedNetworkProvider`")
    }
}

struct DataController {
    @Dependency(\.networkProvider) var networkProvider: any NetworkProviding
    
    func performDataRequest() {
        networkProvider.requestData()
    }
}

@Test func injection() async throws {
    let dataController = DataController()
    #expect(dataController.networkProvider as! NetworkProvider == Dependencies.dependecies.networkProvider as! NetworkProvider)

    let mockedNetworkProvider = MockedNetworkProvider()
    NetworkDependencyProvider.dependency = mockedNetworkProvider
    #expect(dataController.networkProvider as! MockedNetworkProvider == mockedNetworkProvider)
    
    let networkProvider = NetworkProvider()
    NetworkDependencyProvider.dependency = networkProvider
    #expect(dataController.networkProvider as! NetworkProvider == networkProvider)
}
