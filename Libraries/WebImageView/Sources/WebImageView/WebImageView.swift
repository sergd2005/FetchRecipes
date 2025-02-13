// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

enum ImageDownloaderError: Error {
    case badHttpResponse
}

actor ImageDownloader {
    func downloadImage<Content: View, PlaceHolder: View>(for webImageView: WebImageView<Content, PlaceHolder>) async throws {
        guard let url = webImageView.url else { return }
        let (imageData, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else { throw ImageDownloaderError.badHttpResponse }
        Task { @MainActor in
            webImageView.viewModel.image = UIImage(data: imageData)
        }
    }
}

final class ViewModel: ObservableObject {
    @Published var image: UIImage?
}

public struct WebImageView<Content: View, PlaceHolder: View>: View {
    private let downloader = ImageDownloader()
    var url: URL?
    
    @ObservedObject var viewModel = ViewModel()
    
    @ViewBuilder
    private let content: (Image) -> Content
    @ViewBuilder
    private let placeHolder: () -> PlaceHolder

    public init(url: URL? = nil, @ViewBuilder content: @escaping (Image) -> Content, placeHolder: @escaping () -> PlaceHolder) {
        self.url = url
        self.content = content
        self.placeHolder = placeHolder
        downloadImage()
    }
    
    public var body: some View {
        if let image = viewModel.image {
            content(Image(uiImage: image))
        } else {
            placeHolder()
        }
    }
    
    private func downloadImage() {
        guard let url = url else { return }
        Task {
            try await downloader.downloadImage(for: self)
        }
    }
}
