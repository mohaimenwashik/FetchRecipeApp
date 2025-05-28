//
//  RecipeServiceErrors.swift
//  FetchRecipeApp
//
//  Created by Mohaimen Washik on 5/27/25.
//

import Foundation

/// Enum to determine the types of errors to ease the understanding of each type of error
enum RecipeServiceErrors: Error {
    case invalidURL
    case networkError
    case malformedData
    case emptyData
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL endpoint is invalid"
        case .networkError:
            return "There was a problem connecting to the server"
        case .malformedData:
            return "The data appears to be corrupted"
        case .emptyData:
            return "No reciptes available"
        case .decodingError:
            return "Failed to decode the data"
        }
    }
    
}
