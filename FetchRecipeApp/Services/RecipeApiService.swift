//
//  RecipeApiService.swift
//  FetchRecipeApp
//
//  Created by Mohaimen Washik on 5/27/25.
//
//  This is the service that makes the network request and fetches the data by
//  communicating with the server
//

import Foundation

/// The API calling service to fetch the recipe data
final class RecipeApiService {
    
    private let recipeBaseURL: URL
    private let cacheMinutes = 30
    
    // Init to use for All Recipes
//    init(recipeBaseURL: URL = Configurations.RECIPE_URL) {
//        self.recipeBaseURL = recipeBaseURL
//        RecipeCachingService.shared.clear()
//    }
    
    // Init to use for Malformed Recipes
    init(recipeBaseURL: URL = Configurations.MALFORMED_URL) {
        self.recipeBaseURL = recipeBaseURL
        RecipeCachingService.shared.clear()
    }
    
    // Init to use for Empty Recipes
//    init(recipeBaseURL: URL = Configurations.EMPTY_URL) {
//        self.recipeBaseURL = recipeBaseURL
//        RecipeCachingService.shared.clear()
//    }
    
    
    struct RecipesResponse: Codable {
        let recipes: [Recipe]
    }
    
    func fetchRecipes(forceRefresh: Bool = false) async throws -> [Recipe] {
        
        print("Network request is made for: \(recipeBaseURL)")
        
        // If not forcing a refresh, try loading from cache
        if !forceRefresh, let cachedRecipes = RecipeCachingService.shared.loadIfValid(within: cacheMinutes) {
            return cachedRecipes
        }
        
        // Else clear the cache before calling the network request
        RecipeCachingService.shared.clear()
        
        // Making the network request
        let (data, _ ) = try await URLSession.shared.data(from: recipeBaseURL)
        
        // Checking if the data response is empty
        guard !data.isEmpty else {
            throw RecipeServiceErrors.emptyData
        }
        
        // Decode data and save each recipe individually
        do {
            let decoded = try JSONDecoder().decode(RecipesResponse.self, from: data)
            try? RecipeCachingService.shared.save(decoded.recipes)
            return decoded.recipes
        } catch {
            throw RecipeServiceErrors.malformedData
        }
    }
}
