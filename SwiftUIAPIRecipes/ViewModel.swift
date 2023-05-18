//
//  ViewModel.swift
//  SwiftUIAPIRecipes
//
//  Created by Jon Salkin on 5/16/23.
//

import Foundation
import SwiftUI

struct Recipe: Hashable, Codable, Identifiable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    
    var id: String { idMeal }
}

struct RecipeListResponse: Codable {
    let meals: [Recipe]
}

struct RecipeDetailsResponseVM: Codable {
    let meals: [RecipeDetails]
}

class ViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var recipeDetails: RecipeDetails?
    
    func fetch() {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(RecipeListResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.recipes = response.meals
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    func fetchRecipeDetails(recipeID: String) {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(recipeID)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {[weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(RecipeDetailsResponseVM.self, from: data)
                    if let recipeDetails = response.meals.first {
                        DispatchQueue.main.async {
                            self?.recipeDetails = recipeDetails
                        }
                    }
                } catch {
                    print("Error decoding recipe details: \(error)")
                }
            }
            
            task.resume()
        }
}

