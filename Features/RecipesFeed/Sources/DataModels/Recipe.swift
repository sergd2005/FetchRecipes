//
//  Recipe.swift
//  FetchRecipes
//
//  Created by Sergii D on 2/13/25.
//

import Foundation

public struct Feed: Codable {
    let recipes: [Recipe]
}

public struct Recipe: Codable {
    let cuisine, name: String
    let photoURLLarge, photoURLSmall: String
    let sourceURL: String?
    let uuid: String
    let youtubeURL: String?

    enum CodingKeys: String, CodingKey {
        case cuisine, name
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case sourceURL = "source_url"
        case uuid
        case youtubeURL = "youtube_url"
    }
}

// MARK:
extension Recipe: Identifiable {
    public var id: String {
        uuid
    }
}
