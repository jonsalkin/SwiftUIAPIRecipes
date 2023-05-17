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

struct RecipeDetailsView: View {
    let recipeID: String
    @State private var recipeDetails: RecipeDetails?
    
    var body: some View {
        VStack {
            if let recipeDetails = recipeDetails {
                RecipeDetailsSwiftUIView(recipeDetails: recipeDetails)
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

struct RecipeDetailsSwiftUIView: View {
    let recipeDetails: RecipeDetails?
    
    var body: some View {
        VStack {
            if let recipeDetails = recipeDetails {
                AsyncImage(url: URL(string: recipeDetails.strMealThumb )) { phase in
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
                
                Text("Category: \(recipeDetails.strCategory)")
                    .font(.subheadline)
                
                Text("Area: \(recipeDetails.strArea)")
                    .font(.subheadline)
                
                Text("Instructions:")
                    .font(.headline)
                
                Text(recipeDetails.strInstructions)
                    .font(.body)
                
                if let url = URL(string: recipeDetails.strYoutube) {
                    WebView(url: url)
                }
            } else {
                ProgressView()
            }
        }
        .padding()
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



//struct RecipeDetailsSwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecipeDetailsSwiftUIView(recipeDetails: recipeDetails)
//    }
//}
