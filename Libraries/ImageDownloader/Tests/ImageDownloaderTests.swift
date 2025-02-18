import Testing
import Foundation
import Dependency
import UIKit

@testable import ImageDownloader
@testable import NetworkProvider

final class MockNetworkProvider : NetworkProviding {
    func data(from url: URL, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        (Data(), URLResponse())
    }
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await data(from: url, delegate: nil)
    }
}

struct ImageDownloaderTests {
    @Dependency(\.imageDownloader) var imageDownloader: any ImageDownloadProviding
    
    @Test func download() async throws {
        NetworkDependencyProvider.dependency = MockNetworkProvider()
        await imageDownloader.downloadImage(from: URL(string:"https://first.com")!, for: self)
    }
}

extension ImageDownloaderTests: ImageDownloadProvidingDelegate {
    func imageDownloadComplete(result: Result<UIImage, any Error>) async {
        
    }
}
