//
//  Recipe.swift
//  FetchRecipeApp
//
//  Created by Mohaimen Washik on 5/27/25.
//
//  This is the model that would be used to decode the JSON data received from the
//  API request and used to display the information to the users
//

import Foundation

struct Recipe: Identifiable, Codable {
    let id: String
    let name: String
    let cuisine: String
    let photoURLSmall: String?
    let photoURLLarge: String?
    let sourceURL: String?
    let youtubeURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case cuisine
        case photoURLSmall = "photo_url_small"
        case photoURLLarge = "photo_url_large"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
}
