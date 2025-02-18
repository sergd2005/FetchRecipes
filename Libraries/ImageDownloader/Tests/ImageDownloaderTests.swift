import Testing
import Foundation
import Dependency
import UIKit

@testable import ImageDownloader
@testable import NetworkProvider

actor MockNetworkProvider : NetworkProviding {
    var dataToReturn = Data()
    var urlResponse = URLResponse()
    var requestedURL: URL?
    
    func data(from url: URL, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        requestedURL = url
        return (dataToReturn, urlResponse)
    }
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await data(from: url, delegate: nil)
    }
    
    func setData(data: Data, urlResponse: URLResponse) async {
        dataToReturn = data
        self.urlResponse = urlResponse
    }
}

actor ImageDownloaderTests {
    
    @Dependency(\.imageDownloader) var imageDownloader: any ImageDownloadProviding
    
    @Test func download() async throws {
        let imageURL = URL(string:"https://first.com")!
        let testImageUrl = Bundle.module.url(forResource: "testImage", withExtension: "png")
        let testImageData = try Data(contentsOf: testImageUrl!)
        
        let mockNetworkProvider = MockNetworkProvider()
        
        await mockNetworkProvider.setData(data: testImageData, urlResponse: HTTPURLResponse(url: imageURL, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        
        NetworkDependencyProvider.dependency = mockNetworkProvider
        
        let result = await imageDownloader.downloadImage(from: imageURL).result
        
        switch result {
        case .success(let downloadedImage):
            #expect(downloadedImage != nil)
        case .failure(let error):
            #expect(error == nil)
        }
        #expect(await mockNetworkProvider.requestedURL == imageURL)
    }
    
}
