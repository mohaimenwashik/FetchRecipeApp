//
//  Configurations.swift
//  FetchRecipeApp
//
//  Created by Mohaimen Washik on 5/27/25.
//
//  This environment file is used to test the different types of API calls to test
//  how the UI handels the data in case of different kinds of API responses
//

import Foundation

enum Configurations {
    private static let infoDictionary: [String: Any] = {
        guard let dictionary = Bundle.main.infoDictionary else {
            fatalError("plist file not found")
        }
        return dictionary
    }()
    
    static let RECIPE_URL: URL = {
        guard let urlString = Configurations.infoDictionary["RecipeURL"] as? String else {
            let errorMessage = "RECIPE_URL not found in plist file"
            fatalError(errorMessage)
        }
        
        guard let baseURL = URL(string: urlString) else {
            let errorMessage = "RECIPE_URL is not a valid URL"
            fatalError(errorMessage)
        }
        
        return baseURL
    }()
    
    static let MALFORMED_URL: URL = {
        guard let urlString = Configurations.infoDictionary["MarformedURL"] as? String else {
            let errorMessage = "MALFORMED_URL not found in plist file"
            fatalError(errorMessage)
        }
        
        guard let baseURL = URL(string: urlString) else {
            let errorMessage = "MALFORMED_URL is not a valid URL"
            fatalError(errorMessage)
        }
        
        return baseURL
    }()
    
    static let EMPTY_URL: URL = {
        guard let urlString = Configurations.infoDictionary["EmptyURL"] as? String else {
            let errorMessage = "EMPTY_URL not found in plist file"
            fatalError(errorMessage)
        }
        
        guard let baseURL = URL(string: urlString) else {
            let errorMessage = "EMPTY_URL is not a valid URL"
            fatalError(errorMessage)
        }
        
        return baseURL
    }()
    
}
