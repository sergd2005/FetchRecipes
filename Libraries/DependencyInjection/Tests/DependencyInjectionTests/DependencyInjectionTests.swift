import Testing
@testable import DependencyInjection

extension InjectedValues {
    var networkProvider: any NetworkProviding {
        get { Self.self[NetworkProviderKey.self] }
        set { Self.self[NetworkProviderKey.self] = newValue }
    }
}

private struct NetworkProviderKey: InjectionKey {
    nonisolated(unsafe) static var currentValue: any NetworkProviding = NetworkProvider()
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
    @Injected(\.networkProvider) var networkProvider: any NetworkProviding
    
    func performDataRequest() {
        networkProvider.requestData()
    }
}

@Test func injection() async throws {
    var dataController = DataController()
    #expect(dataController.networkProvider as! NetworkProvider == InjectedValues.current.networkProvider as! NetworkProvider)

    let mockedNetworkProvider = MockedNetworkProvider()
    InjectedValues[\.networkProvider] = mockedNetworkProvider
    #expect(dataController.networkProvider as! MockedNetworkProvider == mockedNetworkProvider)
    
    let networkProvider = NetworkProvider()
    dataController.networkProvider = networkProvider
    #expect(dataController.networkProvider as! NetworkProvider == networkProvider)
}
