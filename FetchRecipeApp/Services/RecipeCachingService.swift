//
//  RecipeCachingService.swift
//  FetchRecipeApp
//
//  Created by Mohaimen Washik on 5/27/25.
//

import Foundation

final class RecipeCachingService {
    static let shared = RecipeCachingService()
    private let fileManager = FileManager.default
    private let cacheFileName = "cachedRecipes.json"

    private var cacheFilePath: URL {
        fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(cacheFileName)
    }

    // Save the entire array in one file with timestamp
    func save(_ recipes: [Recipe]) throws {
        let wrapper = CachedRecipesWrapper(timestamp: Date(), recipes: recipes)
        let data = try JSONEncoder().encode(wrapper)
        try data.write(to: cacheFilePath, options: .atomic)
    }

    // Load if fresh
    func loadIfValid(within minutes: Int) -> [Recipe]? {
        guard let data = try? Data(contentsOf: cacheFilePath),
              let wrapper = try? JSONDecoder().decode(CachedRecipesWrapper.self, from: data) else {
            return nil
        }

        let elapsed = Date().timeIntervalSince(wrapper.timestamp)
        guard elapsed <= Double(minutes * 60) else {
            print("Cache expired. Elapsed: \(elapsed / 60) mins")
            return nil
        }

        return wrapper.recipes
    }

    func clear() {
        if fileManager.fileExists(atPath: cacheFilePath.path) {
            try? fileManager.removeItem(at: cacheFilePath)
            print("Recipe cache cleared.")
        }
    }
}

// Wrapper to include timestamp
struct CachedRecipesWrapper: Codable {
    let timestamp: Date
    let recipes: [Recipe]
}
