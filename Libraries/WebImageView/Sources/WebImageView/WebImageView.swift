// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

enum ImageDownloaderError: Error {
    case badHttpResponse
    case badImageData
}

actor ImageDownloader {
    static let shared = ImageDownloader()
    
    var tasks = [URL: Task<Void, Never>]()
    
    private init() {}
    
    func downloadImage(from url: URL, for delegate: ImageDownloaderDelegate) async {
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

final class ViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var error: Error?
}

protocol ImageDownloaderDelegate {
    func imageDownloadComplete(result: Result<UIImage, Error>) async
}

public struct WebImageView<Content: View, PlaceHolder: View>: View {
    private let url: URL?
    
    @ObservedObject var viewModel = ViewModel()
    
    @ViewBuilder
    private let content: (Image) -> Content
    @ViewBuilder
    private let placeHolder: () -> PlaceHolder

    public init(url: URL? = nil, @ViewBuilder content: @escaping (Image) -> Content, placeHolder: @escaping () -> PlaceHolder) {
        self.url = url
        self.content = content
        self.placeHolder = placeHolder
    }
    
    public var body: some View {
        if let image = viewModel.image {
            content(Image(uiImage: image))
        } else {
            placeHolder()
                .task {
                    guard let url else { return }
                    await ImageDownloader.shared.downloadImage(from: url, for: self)
                }
        }
    }
}

// MARK: ImageDownloaderDelegate
extension WebImageView: ImageDownloaderDelegate {
    func imageDownloadComplete(result: Result<UIImage, any Error>) async {
        switch result {
        case .success(let image):
            viewModel.image = image
        case .failure(let error):
            viewModel.error = error
        }
    }
}
