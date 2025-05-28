//
//  RecipeDetailView.swift
//  FetchRecipeApp
//
//  Created by Mohaimen Washik on 5/27/25.
//

import SwiftUI
import WebKit

struct RecipeDetailView: View {
    let recipe: Recipe
    @EnvironmentObject var viewModel: RecipeViewModel
    @State private var image: UIImage?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                ScrollView {
                    VStack(spacing: 0) {
                        // Header image
                        Group {
                            if let image = image {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .opacity(0.7)
                            } else {
                                Color.gray.opacity(0.3)
                            }
                        }
                        .frame(width: geo.size.width, height: geo.size.height * 0.3)
                        .clipped()
                        
                        // Content starts exactly after the image
                        VStack(alignment: .leading, spacing: 12) {
                            
                            Text(recipe.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Text("Cuisine: \(recipe.cuisine)")
                                .font(.headline)
                            
                            // Link Previews for Youtube
                            if let url = URL(string: recipe.youtubeURL ?? "") {
                                Text("Watch on youtube:")
                                    .font(.headline)
                                
                                Link(destination: url) {
                                    Link(destination: url) {
                                        SourcePreview(url: url, geo: geo)
                                    }
                                }
                            }
                            
                            // Link Previews for Source Web
                            if let url = URL(string: recipe.sourceURL ?? "") {
                                Text("Get full details:")
                                    .font(.headline)
                                
                                Link(destination: url) {
                                    SourcePreview(url: url, geo: geo)
                                }
                            }
                        }
                        .frame(width: geo.size.width * 0.9, alignment: .leading)
                        .padding(.top)
                        
                    }
                }
                .ignoresSafeArea(.container, edges: .top)
                
                // Custom Back Button
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrowshape.backward.circle.fill")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(Color.black)
                        .background(Circle().fill(Color.white))
                }
                .padding()
                
            }
        }
        .navigationBarBackButtonHidden()
        .task {
            if let urlString = recipe.photoURLLarge,
               let url = URL(string: urlString) {
                self.image = await viewModel.loadImage(from: url, uuid: recipe.id, size: .large)
            }
        }
    }
}

// Helper View for the Previews
struct SourcePreview: View {
    @Environment(\.dismiss) var dismiss
    let url: URL
    let geo: GeometryProxy
    
    var body: some View {
        WebView(url: url)
            .frame(height: geo.size.height * 0.3)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            )
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

#Preview {
    RecipeDetailView(recipe:
                        Recipe(
                            id: "",
                            name: "Timbits",
                            cuisine: "Canadian",
                            photoURLSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7f6a259a-71df-42c2-b314-065e0c736c67/small.jpg",
                            photoURLLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/7f6a259a-71df-42c2-b314-065e0c736c67/large.jpg",
                            sourceURL: "http://www.geniuskitchen.com/recipe/drop-doughnuts-133877",
                            youtubeURL: "https://www.youtube.com/watch?v=fFLn1h80AGQ")
    )
    .environmentObject(RecipeViewModel())
}
