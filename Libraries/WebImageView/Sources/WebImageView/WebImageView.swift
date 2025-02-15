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
    
    func downloadImage<Content: View, PlaceHolder: View>(from url: URL, for webImageView: WebImageView<Content, PlaceHolder>) async {
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
                Task { @MainActor in
                    webImageView.viewModel.image = image
                }
            } catch(let error) {
                Task { @MainActor in
                    webImageView.viewModel.error = error
                }
            }
        }
        tasks[url] = task
    }
}

final class ViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var error: Error?
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
