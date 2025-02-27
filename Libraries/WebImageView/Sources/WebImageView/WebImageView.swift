// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import WebImage

final class ViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var error: Error?
}

public struct WebImageView<Content: View, PlaceHolder: View>: View {
    private let url: URL?
    private let webImageProvider: any WebImageProviding
    
    @ObservedObject var viewModel = ViewModel()
    
    @ViewBuilder
    private let content: (Image) -> Content
    @ViewBuilder
    private let placeHolder: () -> PlaceHolder

    public init(url: URL? = nil, webImageProvider: any WebImageProviding = WebImageProvider(), @ViewBuilder content: @escaping (Image) -> Content, placeHolder: @escaping () -> PlaceHolder) {
        self.url = url
        self.content = content
        self.placeHolder = placeHolder
        self.webImageProvider = webImageProvider
    }
    
    public var body: some View {
        if let image = viewModel.image {
            content(Image(uiImage: image))
        } else {
            placeHolder()
                .task {
                    guard let url else { return }
                    do {
                        viewModel.image = try await webImageProvider.downloadImage(from: url).value
                    } catch {
                        // TODO: handle error
                    }
                }
        }
    }
}

