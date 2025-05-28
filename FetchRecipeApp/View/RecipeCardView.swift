//
//  RecipeCardView.swift
//  FetchRecipeApp
//
//  Created by Mohaimen Washik on 5/27/25.
//
//  This represents the UI of each item shown on the list
//

import SwiftUI

struct RecipeCardView: View {
    let recipe: Recipe
    @State private var image: UIImage? = nil
    
    @EnvironmentObject var viewModel: RecipeViewModel

    var body: some View {
        HStack(spacing: 16) {
            // Image on the left
            Group {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    ProgressView()
                }
            }
            .frame(width: 80, height: 80)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .clipped()
            
            // Texts on the right
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
        .task {
            if let urlString = recipe.photoURLSmall,
               let url = URL(string: urlString) {
                self.image = await viewModel.loadImage(from: url, uuid: recipe.id, size: .small)
            }
        }
    }
}


#Preview {
    RecipeCardView(recipe:
                    Recipe(
                        id: "",
                        name: "Timbits",
                        cuisine: "Canadian",
                        photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7f6a259a-71df-42c2-b314-065e0c736c67/small.jpg",
                        photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7f6a259a-71df-42c2-b314-065e0c736c67/large.jpg",
                        sourceURL: "http://www.geniuskitchen.com/recipe/drop-doughnuts-133877",
                        youtubeURL: "https://www.youtube.com/watch?v=fFLn1h80AGQ")
    ).environmentObject(RecipeViewModel())
}
