//
//  RecipeViewModel.swift
//  FetchRecipeApp
//
//  Created by Mohaimen Washik on 5/27/25.
//

import Foundation
import SwiftUI

@MainActor
final class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    
    // For Sorting
    enum SortOrder: String, CaseIterable, Identifiable {
        case ascending = "A → Z"
        case descending = "Z → A"

        var id: Self { self }
    }
    
    @Published var sortOrder: SortOrder = .ascending

    private let service: RecipeApiService
    private var currentFetchTask: Task<Void, Never>?

    init(service: RecipeApiService = RecipeApiService()) {
        self.service = service
    }
    
    var filteredAndSortedRecipes: [Recipe] {
        let filtered = searchText.isEmpty
        ? recipes
        : recipes.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        
        switch sortOrder {
        case .ascending:
            return filtered.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .descending:
            return filtered.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedDescending }
        }
    }
    
    // Making sure any previous request is cancelled before making a new one
    func fetchRecipes(forceRefresh: Bool = false) {
        currentFetchTask?.cancel() // cancel any ongoing fetch
        currentFetchTask = Task {
            await self.fetch(forceRefresh: forceRefresh)
        }
    }
    
    // Calling the data
    private func fetch(forceRefresh: Bool) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await service.fetchRecipes(forceRefresh: forceRefresh)
            self.recipes = result
        } catch let error as RecipeServiceErrors {
            errorMessage = error.errorDescription
            recipes = []
        } catch is CancellationError {
            // Ignore cancelled task
        } catch {
            errorMessage = "An unknown error occurred."
            recipes = []
        }
        
        isLoading = false
    }

    // Caching images
    func loadImage(from url: URL, uuid: String, size: ImageSize, forceRefresh: Bool = false) async -> UIImage? {
        do {
            return try await ImageCachingService.shared.loadImage(from: url, uuid: uuid, size: size, forceRefresh: forceRefresh)
        } catch {
            print("Image loading failed for UUID \(uuid)-\(size.rawValue): \(error)")
            return nil
        }
    }
}

