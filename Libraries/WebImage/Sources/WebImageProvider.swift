// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import UIKit
import Network
import Storage

public enum WebImageProvidingError: Error {
    case badHttpResponse
    case badImageData
}

public actor WebImageProvider: WebImageProviding {
    let networkProvider: any NetworkProviding
    let storage: any StorageProviding
    
    var tasks = [URL: Task<UIImage, Error>]()
    
    public init(networkProvider: any NetworkProviding = URLSessionProvider(), storage: any StorageProviding = FileSystemStorage()) {
        self.networkProvider = networkProvider
        self.storage = storage
    }
    
    public func downloadImage(from url: URL) async -> Task<UIImage, Error> {
        guard tasks[url] == nil else { return tasks[url]! }
        let task = Task {
            defer {
                tasks[url] = nil
            }
            // TODO: get key from URL
            if let storedImageData = await storage.readData(with: url.cacheKey ?? url.path) {
                guard let image = UIImage(data: storedImageData) else { throw WebImageProvidingError.badImageData }
                return image
            } else {
                let (imageData, response) =  try await networkProvider.data(from: url)
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else { throw WebImageProvidingError.badHttpResponse }
                guard let image = UIImage(data: imageData) else { throw WebImageProvidingError.badImageData }
                // TODO: store in separate task, update tests to handle that case
                try await storage.save(data: imageData, with: url.cacheKey ?? url.path)
                return image
            }
        }
        tasks[url] = task
        return task
    }
}

extension URL {
    var cacheKey: String? {
        // TODO: handle different urls here
        return pathComponents[pathComponents.count - 2]
    }
}
