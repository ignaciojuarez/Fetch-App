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
// - cache

// DONE:
// - async fetching
// - search
// - images

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        NavigationView {
            List(viewModel.filteredMeals, id: \.idMeal) { meal in
                Button {
                    viewModel.selectedMeal = meal
                } label: {
                    HStack {
                        mealImageView(meal: meal)
                        Text(meal.strMeal)
                            .foregroundStyle(.black)
                    }
                }
            }
        }
        .navigationTitle("Desserts")
        .searchable(text: $viewModel.searchText, prompt: "Search desserts")
        .sheet(item: $viewModel.selectedMeal) { meal in
            MealDetailView()
        }
        .onAppear {
            Task { await viewModel.loadMeals() }
        }
    }
    
    @ViewBuilder
    private func mealImageView(meal: Meal) -> some View {
        Group {
            if let imageUrl = meal.strMealThumb, let url = URL(string: imageUrl + "/preview") {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
            }
        }
        .foregroundColor(.gray)
        .frame(width: 60, height: 60)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    ContentView()
        .environmentObject(ViewModel())
}
