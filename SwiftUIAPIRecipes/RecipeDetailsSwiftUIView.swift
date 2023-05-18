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
                    
                    VStack(alignment: .leading) {
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
                            .fixedSize(horizontal: false, vertical: true) // Allow multiline text
                            .padding(.bottom)
                        
                        if let ingredients = recipeDetails.getIngredients(),
                           let measures = recipeDetails.getMeasures() {
                            Text("Ingredients:")
                                .font(.headline)
                                .padding(.bottom, 4)
                            
                            ForEach(Array(zip(ingredients, measures)), id: \.0) { ingredient, measure in
                                Text("\(measure) \(ingredient)")
                                    .font(.body)
                                    .padding(.bottom, 4)
                            }
                        }
                    }
                    .padding()
                    
                    if let url = URL(string: recipeDetails.strYoutube) {
                        WebView(url: url)
                            .frame(height: 350)
                            .padding(.horizontal)
                            .padding(.top, 2) // Adjust the top padding to reduce space
                    }
                }
                else {
                    ProgressView()
                }
            }
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


    extension RecipeDetails {
        func getIngredients() -> [String]? {
            let ingredients = [strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5, strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10, strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15, strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20]
            
            return ingredients.compactMap { $0 }
        }
        
        func getMeasures() -> [String]? {
            let measures = [strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5, strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10, strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15, strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20]
            
            return measures.compactMap { $0 }
        }
    }
