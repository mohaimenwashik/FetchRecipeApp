//
//  FetchRecipeAppTests.swift
//  FetchRecipeAppTests
//
//  Created by Mohaimen Washik on 5/27/25.
//

import XCTest
@testable import FetchRecipeApp

final class FetchRecipeAppTests: XCTestCase {
    
    // Testing the decoder struct
    func testRecipeDecoding() throws {
        let json = """
        {
            "cuisine": "Malaysian",
            "name": "Apam Balik",
            "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
            "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
            "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
            "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
            "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
        }
        """.data(using: .utf8)!
        
        let recipe = try JSONDecoder().decode(Recipe.self, from: json)
        XCTAssertEqual(recipe.name, "Apam Balik")
        XCTAssertEqual(recipe.cuisine, "Malaysian")
        XCTAssertEqual(recipe.id, "0c6ca6e7-e32a-4053-b824-1dbf749910d8")
    }
}
