// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import UIKit

public protocol ImageDownloaderDelegate {
    func imageDownloadComplete(result: Result<UIImage, Error>) async
}

public enum ImageDownloaderError: Error {
    case badHttpResponse
    case badImageData
}

public actor ImageDownloader {
    static public let shared = ImageDownloader()
    
    var tasks = [URL: Task<Void, Never>]()
    
    private init() {}
    
    public func downloadImage(from url: URL, for delegate: ImageDownloaderDelegate) async {
        guard tasks[url] == nil else { return }
        let task = Task {
            defer {
                tasks[url] = nil
            }
            do {
                let (imageData, response) = try await URLSession.shared.data(from: url)
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else { throw ImageDownloaderError.badHttpResponse }
                guard let image = UIImage(data: imageData) else { throw ImageDownloaderError.badImageData }
                await delegate.imageDownloadComplete(result: .success(image))
            } catch(let error) {
                await delegate.imageDownloadComplete(result: .failure(error))
            }
        }
        tasks[url] = task
    }
}
