// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import ImageDownloader

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

// MARK: ImageDownloaderDelegate
extension WebImageView: ImageDownloaderDelegate {
    public func imageDownloadComplete(result: Result<UIImage, any Error>) async {
        switch result {
        case .success(let image):
            viewModel.image = image
        case .failure(let error):
            viewModel.error = error
        }
    }
}
