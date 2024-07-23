//
//  ContentView.swift
//  Fetch-App
//
//  Created by Ignacio Juarez on 7/22/24.
//

import SwiftUI

// TODO:
// - LazyLoading
// - favorites
// - animations
// - better design
// - images

// DONE:
// - async fetching
// - search

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.filteredMeals, id: \.idMeal) { meal in
                NavigationLink(destination: MealDetailView(mealID: meal.idMeal)) {
                    Text(meal.strMeal)
                }
                
            }
            .navigationTitle("Desserts")
            .searchable(text: $viewModel.searchText, prompt: "Search desserts")
            .onAppear {
                Task { await viewModel.loadMeals() }
            }
        }
    }
}


#Preview {
    ContentView()
        .environmentObject(ViewModel())
}
