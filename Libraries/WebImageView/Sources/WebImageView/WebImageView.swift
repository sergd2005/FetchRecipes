// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

enum ImageDownloaderError: Error {
    case badHttpResponse
}

actor ImageDownloader {
    func downloadImage(from url: URL?) async throws -> UIImage? {
        guard let url = url else { return nil }
        let (imageData, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else { throw ImageDownloaderError.badHttpResponse }
        return UIImage(data: imageData)
    }
}

final class ViewModel: ObservableObject {
    @Published var image: UIImage?
}

public struct WebImageView<Content: View, PlaceHolder: View>: View {
    private let downloader = ImageDownloader()
    private let url: URL?
    
    @ObservedObject private var viewModel = ViewModel()
    
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
        Task { @MainActor in
            viewModel.image = try await downloader.downloadImage(from: url)
        }
    }
}
