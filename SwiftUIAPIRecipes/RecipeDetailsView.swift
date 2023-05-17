//
//  RecipeDetailsView.swift
//  SwiftUIAPIRecipes
//
//  Created by Jon Salkin on 5/17/23.
//

import Foundation
import SwiftUI

struct RecipeDetailsView: View {
    let recipe: Recipe
    @State private var recipeDetails: RecipeDetails?
    
    var body: some View {
        VStack {
            Text(recipeDetails.strMeal)
                .font(.title)
                .bold()
            
            Text("Category: \(recipeDetails.strCategory)")
                .font(.subheadline)
            
            Text("Area: \(recipeDetails.strArea)")
                .font(.subheadline)
            
            Text("Instructions:")
                .font(.headline)
            
            Text(recipeDetails.strInstructions)
            
            Text("Recipe Details for ID: \(recipeDetails.idMeal)")
            // Display more recipe details as needed
            
            // Image view for strMealThumb
            if let imageUrl = URL(string: recipeDetails.strMealThumb),
               let imageData = try? Data(contentsOf: imageUrl),
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
            }
            
            // Text view for strTags
            if let tags = recipeDetails.strTags {
                Text("Tags: \(tags)")
                    .padding()
            }
            
            // Link view for strYoutube
            if let youtubeUrl = URL(string: recipeDetails.strYoutube) {
                Text("Watch Video")
                    .foregroundColor(.blue)
                    .underline()
                    .onTapGesture {
                        UIApplication.shared.open(youtubeUrl)
                    }
                    .padding()
            }
            
            
            
            Spacer()
        }
        VStack{
            // Text views for strIngredient1 and strIngredient2
            Text("Ingredient 1: \(recipeDetails.strIngredient1)")
            Text("Ingredient 2: \(recipeDetails.strIngredient2)")
        }
        .padding()
        .onAppear {
            fetchRecipeDetails()
        }
    }
    
    private func fetchRecipeDetails() {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(recipeDetails.idMeal)") else {
                    return
                }

                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else {
                        return
                    }

                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(RecipeDetailsResponse.self, from: data)
                        let recipeDetails = response.meals.first

                        // Update the view with the fetched recipe details
                        // ...

                    } catch {
                        print("Error decoding recipe details: \(error)")
                    }
                }.resume()
            }
    
    
}
        


    

