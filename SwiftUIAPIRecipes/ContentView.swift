//
//  ContentView.swift
//  SwiftUIAPIRecipes
//
//  Created by Jon Salkin on 5/16/23.
//


import SwiftUI

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    @State private var selectedRecipe: Recipe?
    
    var body: some View {
        NavigationView {
            List(viewModel.recipes, id: \.idMeal) { recipe in
                NavigationLink(
                    destination: RecipeDetailsSwiftUIView(recipeID: recipe.idMeal),
                    tag: recipe,
                    selection: $selectedRecipe,
                    label: {
                        HStack {
                            URLImage(urlString: recipe.strMealThumb)
                            Text(recipe.strMeal)
                                .bold()
                        }
                        .padding(3)
                    }
                )
                .onTapGesture {
                    selectedRecipe = recipe
                    viewModel.fetchRecipeDetails(recipeID: recipe.idMeal)
                }
            }
            .navigationTitle("Recipes")
        }
        .onAppear {
            viewModel.fetch()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
