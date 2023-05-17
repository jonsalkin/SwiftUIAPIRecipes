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
            Image(systemName: "video")
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
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





//MARK: - Test Images
struct URLImageTestView: View {
    let testImageURL = "https://www.themealdb.com//images//media//meals//adxcbq1619787919.jpg" // Replace with an actual test image URL

    var body: some View {
        URLImage(urlString: testImageURL)
            .frame(width: 200, height: 200)
    }
}

struct URLImageTestView_Previews: PreviewProvider {
    static var previews: some View {
        URLImageTestView()
    }
}
