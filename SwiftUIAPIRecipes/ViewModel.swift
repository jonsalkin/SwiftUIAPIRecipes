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
    
    var id: String { idMeal } // Use idMeal as the identifier
}

class ViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    
    func fetch() {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {[weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            //Convert to JSON
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let meals = json?["meals"] as? [[String: Any]] {
                    let recipes = meals.compactMap { (mealDict: [String: Any]) -> Recipe? in
                        guard let idMeal = mealDict["idMeal"] as? String,
                              let strMeal = mealDict["strMeal"] as? String,
                              let strMealThumb = mealDict["strMealThumb"] as? String else {
                            return nil
                        }
                        
                        return Recipe(idMeal: idMeal, strMeal: strMeal, strMealThumb: strMealThumb)
                    }
                    
                    DispatchQueue.main.async {
                        self?.recipes = recipes
                    }
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
}


