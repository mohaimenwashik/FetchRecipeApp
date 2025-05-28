//
//  CachingServiceTests.swift
//  FetchRecipeAppTests
//
//  Created by Mohaimen Washik on 5/28/25.
//

import XCTest
@testable import FetchRecipeApp

final class CachingServiceTests: XCTestCase {
    var cacheService: RecipeCachingService!
    let testRecipes = [
        Recipe(id: "1", name: "Test Recipe", cuisine: "Test", photoURLSmall: nil, photoURLLarge: nil, sourceURL: nil, youtubeURL: nil)
    ]
    
    override func setUp() {
        super.setUp()
        cacheService = RecipeCachingService.shared
        cacheService.clear()
    }
    
    override func tearDown() {
        cacheService.clear()
        super.tearDown()
    }
    
    func testSaveAndLoadValidCache() throws {
        try cacheService.save(testRecipes)
        let loaded = cacheService.loadIfValid(within: 30)
        XCTAssertNotNil(loaded)
        XCTAssertEqual(loaded?.count, 1)
        XCTAssertEqual(loaded?.first?.name, "Test Recipe")
    }
    
    func testExpiredCacheReturnsNil() throws {
        try cacheService.save(testRecipes)
        
        // Simulating the expiration by modifying the timestamp
        let wrapper = CachedRecipesWrapper(timestamp: Date(timeIntervalSinceNow: -400), recipes: testRecipes)
        let data = try JSONEncoder().encode(wrapper)
        try data.write(to: cacheService.cacheFilePath)
        
        let loaded = cacheService.loadIfValid(within: 5)
        XCTAssertNil(loaded)
    }
    
    func testClearCacheRemovesData() throws {
        try cacheService.save(testRecipes)
        cacheService.clear()
        let loaded = cacheService.loadIfValid(within: 30)
        XCTAssertNil(loaded)
    }
    
    func testImageCacheStorageAndRetrieval() async throws {
        let imageService = ImageCachingService.shared
        let uuid = UUID().uuidString
        let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")!
        let size: ImageSize = .small
        
        // Force downloading and caching
        let image = try await imageService.loadImage(from: url, uuid: uuid, size: size, forceRefresh: true)
        XCTAssertNotNil(image)
        
        // Trying to load from memory/disk
        let cachedImage = try await imageService.loadImage(from: url, uuid: uuid, size: size)
        XCTAssertNotNil(cachedImage)
    }
}
