//
//  RecipeDetails.swift
//  SwiftUIAPIRecipes
//
//  Created by Jon Salkin on 5/17/23.
//

import Foundation

struct RecipeDetails: Codable {
    let idMeal: String
    let strMeal: String
    let strCategory: String
    let strArea: String
    let strInstructions: String
    // Add more properties as needed
    
    enum CodingKeys: String, CodingKey {
        case idMeal
        case strMeal
        case strCategory
        case strArea
        case strInstructions
        // Map the coding keys to match the API response
        
        // Add more coding keys as needed
    }
}
