import Testing
import Foundation
import UIKit
import Network

@testable import WebImage

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
    
    func setData(data: Data? = nil, urlResponse: URLResponse) async {
        if let data {
            dataToReturn = data
        }
        self.urlResponse = urlResponse
    }
}

actor WebImageProviderTests {
        
    let mockNetworkProvider = MockNetworkProvider()
    let webImageProvider: WebImageProvider
    
    init () {
        webImageProvider = WebImageProvider(networkProvider: mockNetworkProvider)
    }
    
    @Test func successfulDownload() async throws {
        let imageURL = URL(string:"https://first.com")!
        let testImageUrl = Bundle.module.url(forResource: "testImage", withExtension: "png")
        let testImageData = try Data(contentsOf: testImageUrl!)
 
        await mockNetworkProvider.setData(data: testImageData, urlResponse: HTTPURLResponse(url: imageURL, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        
        let result = await webImageProvider.downloadImage(from: imageURL).result
        
        var returnedError: WebImageProvidingError?
        var returnedImage: UIImage?
        
        switch result {
        case .success(let downloadedImage):
            returnedImage = downloadedImage
        case .failure(let error):
            returnedError = error as? WebImageProvidingError
        }
        
        #expect(returnedError == nil)
        #expect(returnedImage != nil)
        #expect(await mockNetworkProvider.requestedURL == imageURL)
    }
    
    @Test func wrongHTTPCode() async {
        let imageURL = URL(string:"https://first.com")!

        await mockNetworkProvider.setData(urlResponse: HTTPURLResponse(url: imageURL, statusCode: 404, httpVersion: nil, headerFields: nil)!)
        
        let result = await webImageProvider.downloadImage(from: imageURL).result
        
        var returnedError: WebImageProvidingError?
        var returnedImage: UIImage?
        
        switch result {
        case .success(let downloadedImage):
            returnedImage = downloadedImage
        case .failure(let error):
            returnedError = error as? WebImageProvidingError
        }
        
        #expect(returnedError == .badHttpResponse)
        #expect(returnedImage == nil)
        #expect(await mockNetworkProvider.requestedURL == imageURL)
    }
    
    @Test func wrongImageData() async {
        let imageURL = URL(string:"https://first.com")!
        
        await mockNetworkProvider.setData(data: Data(), urlResponse: HTTPURLResponse(url: imageURL, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        
        let result = await webImageProvider.downloadImage(from: imageURL).result
        
        var returnedError: WebImageProvidingError?
        var returnedImage: UIImage?
        
        switch result {
        case .success(let downloadedImage):
            returnedImage = downloadedImage
        case .failure(let error):
            returnedError = error as? WebImageProvidingError
        }
        
        #expect(returnedError == .badImageData)
        #expect(returnedImage == nil)
        #expect(await mockNetworkProvider.requestedURL == imageURL)
    }
    
}
