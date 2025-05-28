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
    
    // Init to use for All Recipes
    init(recipeBaseURL: URL = Configurations.RECIPE_URL) {
        self.recipeBaseURL = recipeBaseURL
    }
    
    // Init to use for Malformed Recipes
//    init(recipeBaseURL: URL = Configurations.MALFORMED_URL) {
//        self.recipeBaseURL = recipeBaseURL
//    }
    
    // Init to use for Empty Recipes
//    init(recipeBaseURL: URL = Configurations.EMPTY_URL) {
//        self.recipeBaseURL = recipeBaseURL
//    }
    
    
    struct RecipesResponse: Codable {
        let recipes: [Recipe]
    }
    
    func fetchRecipes() async throws -> [Recipe] {
        
        // Making the network request
        let (data, response) = try await URLSession.shared.data(from: recipeBaseURL)
        
        // Checking if the network request is made successfully
//        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//            throw RecipeServiceErrors.networkError
//        }
        
        // Checking if the data response is empty
        guard !data.isEmpty else {
            throw RecipeServiceErrors.emptyData
        }
        
        // Decoding the fetched data
        do {
            let decoded = try JSONDecoder().decode(RecipesResponse.self, from: data)
            return decoded.recipes
        } catch {
            throw RecipeServiceErrors.malformedData
        }
    }
}
