//
//  ContentView.swift
//  SwiftUIAPIRecipes
//
//  Created by Jon Salkin on 5/16/23.
//


import SwiftUI

struct URLImage: View {
    let urlString: String
    
    @State var data: Data?
    
    var body: some View {
        if let data = data, let uiimage = UIImage(data: data) {
            Image(uiImage: uiimage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 130, height: 70)
                .background(Color.gray)
        }
        else {
            Image(systemName: "photo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 130, height: 70)
                .background(Color.gray)
                .onAppear {
                    if let url = URL(string: urlString) {
                        fetchData(from: url)
                    }
                }
        }
    }
    
    private func fetchData(from url: URL) {
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            self.data = data
        }
        task.resume()
    }
    
}

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    @State private var selectedRecipe: Recipe?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.recipes, id: \.idMeal) { recipe in
                    HStack {
                        URLImage(urlString: recipe.strMealThumb)
                        
                        Text(recipe.strMeal)
                            .bold()
                    }
                    .padding(3)
                }
            }
            .navigationTitle("Recipes")
            .onAppear {
                viewModel.fetch()
            }
            
            .sheet(item: $selectedRecipe) { recipe in
                RecipeDetailView(recipe: recipe)
            }
            
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
    
    struct RecipeDetailView: View {
        let recipe: Recipe
        
        var body: some View {
            VStack {
                URLImage(urlString: recipe.strMealThumb)
                
                Text(recipe.strMeal)
                    .font(.title)
                    .bold()
                    .padding()
                
                // Fetch recipe details using the recipe ID
                RecipeDetailsView(recipeID: recipe.idMeal)
            }
        }
    }
    
    
    struct RecipeDetailsView: View {
        let recipeID: String
        @State private var recipeDetails: RecipeDetails?
        
        var body: some View {
            VStack {
                if let recipeDetails = recipeDetails {
                    Text(recipeDetails.strInstructions)
                        .padding()
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
            

        }
        
    }
    
}


//
////MARK: - Test Images
//struct URLImageTestView: View {
//    let testImageURL = "https://www.themealdb.com//images//media//meals//adxcbq1619787919.jpg" // Replace with an actual test image URL
//
//    var body: some View {
//        URLImage(urlString: testImageURL)
//            .frame(width: 200, height: 200)
//    }
//}
//
//struct URLImageTestView_Previews: PreviewProvider {
//    static var previews: some View {
//        URLImageTestView()
//    }
//}
