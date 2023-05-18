//
//  RecipeDetailsSwiftUIView.swift
//  SwiftUIAPIRecipes
//
//  Created by Jon Salkin on 5/17/23.
//

import SwiftUI
import UIKit
import WebKit

struct RecipeDetailsResponse: Decodable {
    let meals: [RecipeDetails]
}

struct RecipeDetailsSwiftUIView: View {
    let recipeID: String
    @State private var recipeDetails: RecipeDetails?

    var body: some View {
            VStack {
                if let recipeDetails = recipeDetails {
                    RecipeDetailsView(recipeDetails: recipeDetails)
                } else {
                    ProgressView()
                        .onAppear {
                            fetchRecipeDetails()
                        }
                }
            }
        }

    private func fetchRecipeDetails() {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(recipeID)") else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(RecipeDetailsResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.recipeDetails = response.meals.first
                    }
                } catch {
                    print("Error decoding recipe details: \(error)")
                }
            }
        }
        task.resume()
    }
}

struct RecipeDetailsView: View {
    let recipeDetails: RecipeDetails?
    
    var body: some View {
        ScrollView {
            VStack {
                if let recipeDetails = recipeDetails {
                    AsyncImage(url: URL(string: recipeDetails.strMealThumb)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        @unknown default:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width, height: 300)
                    .clipped()
                    
                    Text(recipeDetails.strMeal)
                        .font(.title)
                        .padding(.vertical)
                    
                    Text("Category: \(recipeDetails.strCategory)")
                        .font(.subheadline)
                        .padding(.bottom, 4)
                    
                    Text("Area: \(recipeDetails.strArea)")
                        .font(.subheadline)
                        .padding(.bottom, 4)
                    
                    Text("Instructions:")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    Text(recipeDetails.strInstructions)
                        .font(.body)
                        .lineLimit(nil)
                        .padding(.bottom)
                    
                    if let videoId = extractYouTubeVideoId(from: recipeDetails.strYoutube),
                       let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(videoId)") {
                        WebView(url: youtubeURL)
                            .frame(height: 300) // Adjust the height of the WebView
                    }
                } else {
                    ProgressView()
                }
            }
            .padding()
        }
    }
}

private func extractYouTubeVideoId(from url: String) -> String? {
        guard let youtubeURL = URL(string: url) else {
            return nil
        }
        
        if let videoId = youtubeURL.queryParameters["v"] {
            return videoId
        } else if youtubeURL.pathComponents.count > 1 {
            return youtubeURL.pathComponents[1]
        }
        
        return nil
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

extension URL {
    var queryParameters: [String: String] {
        var parameters = [String: String]()
        
        if let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
           let queryItems = components.queryItems {
            for item in queryItems {
                parameters[item.name] = item.value
            }
        }
        
        return parameters
    }
}
