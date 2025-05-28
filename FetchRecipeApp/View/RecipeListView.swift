//
//  ContentView.swift
//  FetchRecipeApp
//
//  Created by Mohaimen Washik on 5/27/25.
//

import SwiftUI

import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeViewModel()
    
    var body: some View {
        NavigationView {
            VStack{
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 160)], alignment: .leading ,spacing: 16) {
                        if viewModel.isLoading {
                            ProgressView("Loading Recipes...")
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else if let error = viewModel.errorMessage {
                            VStack {
                                Text(error)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                Button("Retry") {
                                    viewModel.fetchRecipes(forceRefresh: true)
                                }
                                .padding()
                            }
                            .frame(maxWidth: .infinity)
                        } else if viewModel.recipes.isEmpty {
                            Text("No recipes found")
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity)
                        } else {
                            ForEach(viewModel.filteredAndSortedRecipes, id: \.id) { recipe in
                                NavigationLink(destination: RecipeDetailView(recipe: recipe).environmentObject(viewModel)) {
                                    RecipeCardView(recipe: recipe)
                                        .environmentObject(viewModel)
                                }
                                
                                Divider()
                            }
                        }
                    }
                    .padding()
                }
                .refreshable {
                    viewModel.fetchRecipes(forceRefresh: true)
                }
            }
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("Sort", selection: $viewModel.sortOrder) {
                            ForEach(RecipeViewModel.SortOrder.allCases) { order in
                                Text(order.rawValue).tag(order)
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down.circle.fill")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundStyle(Color.black)
                    }
                }
            }
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
        .onAppear {
            viewModel.fetchRecipes(forceRefresh: false)
        }
    }
}

#Preview {
    RecipeListView()
}
