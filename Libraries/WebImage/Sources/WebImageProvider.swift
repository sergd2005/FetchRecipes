// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import UIKit
import Network

public enum WebImageProvidingError: Error {
    case badHttpResponse
    case badImageData
}

public actor WebImageProvider: WebImageProviding {
    let networkProvider: any NetworkProviding
    
    var tasks = [URL: Task<UIImage, Error>]()
    
    public init(networkProvider: any NetworkProviding = URLSessionProvider()) {
        self.networkProvider = networkProvider
    }
    
    public func downloadImage(from url: URL) async -> Task<UIImage, Error> {
        guard tasks[url] == nil else { return tasks[url]! }
        let task = Task {
            defer {
                tasks[url] = nil
            }
            let (imageData, response) = try await networkProvider.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else { throw WebImageProvidingError.badHttpResponse }
            guard let image = UIImage(data: imageData) else { throw WebImageProvidingError.badImageData }
            return image
        }
        tasks[url] = task
        return task
    }
}
