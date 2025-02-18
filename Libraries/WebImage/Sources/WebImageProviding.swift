//
//  ImageDownloadProviding.swift
//  ImageDownloader
//
//  Created by Sergii D on 2/18/25.
//

import Foundation
import UIKit

public protocol WebImageProviding: Sendable {
    func downloadImage(from url: URL) async -> Task<UIImage, Error>
}
