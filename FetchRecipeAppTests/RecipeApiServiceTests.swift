//
//  RecipeApiServiceTests.swift
//  FetchRecipeAppTests
//
//  Created by Mohaimen Washik on 5/27/25.
//

import XCTest
@testable import FetchRecipeApp

final class RecipeApiServiceTests: XCTestCase {
    // Writing a mock JSON to disk and return file:// URL
    private func serveLocalJSONData(_ jsonData: Data) throws -> URL {
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent(UUID().uuidString + ".json")
        try jsonData.write(to: fileURL)
        return fileURL
    }
    
    // Test for successful parsing of valid JSON
    func testFetchRecipes_SuccessfullyParsesValidData() async throws {
        
        // Defining a mock valid JSON
        let validJSON = """
            {
                "recipes": [
                    {
                        "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                        "name": "Apam Balik",
                        "cuisine": "Malaysian",
                        "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                        "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                        "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                        "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
                    }
                ]
            }
            """.data(using: .utf8)!
        
        // Serving this JSON as a local file URL
        let mockURL = try serveLocalJSONData(validJSON)
        
        // Injecting it into the service
        let service = RecipeApiService(recipeBaseURL: mockURL)
        
        // Making the network call
        let recipes = try await service.fetchRecipes()
        
        // Asserting
        XCTAssertEqual(recipes.count, 1)
        XCTAssertEqual(recipes.first?.name, "Apam Balik")
        XCTAssertEqual(recipes.first?.cuisine, "Malaysian")
        XCTAssertEqual(recipes.first?.id, "0c6ca6e7-e32a-4053-b824-1dbf749910d8")
    }
    
    // Test for malformed JSON data error
    func testFetchRecipes_ThrowsMalformedDataError() async throws {
        let malformedJSON = """
            {
                "recipes": [
                    {
                        "cuisine": "British",
                        "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
                        "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
                        "source_url": "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
                        "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f",
                        "youtube_url": "https://www.youtube.com/watch?v=4vhcOwVBDO4"
                    }
                ]
            }
            """.data(using: .utf8)!
        
        let mockURL = try serveLocalJSONData(malformedJSON)
        let service = RecipeApiService(recipeBaseURL: mockURL)
        
        do {
            _ = try await service.fetchRecipes()
            XCTFail("Expected malformedData error not thrown")
        } catch let error as RecipeServiceErrors {
            XCTAssertEqual(error, .malformedData)
        }
    }
    
    // Test for empty data
    func testFetchRecipes_ThrowsEmptyDataError() async throws {
        let emptyData = Data()
        let mockURL = try serveLocalJSONData(emptyData)
        let service = RecipeApiService(recipeBaseURL: mockURL)
        
        do {
            _ = try await service.fetchRecipes()
            XCTFail("Expected emptyData error not thrown")
        } catch let error as RecipeServiceErrors {
            XCTAssertEqual(error, .emptyData)
        }
    }
}
