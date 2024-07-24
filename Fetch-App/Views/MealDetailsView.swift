//
//  MealDetailsView.swift
//  Fetch-App
//
//  Created by Ignacio Juarez on 7/22/24.
//

import SwiftUI

/// A view displaying  detailed information about a selected meal
/// meal's image, name, ingredients, and cooking instructions
struct MealDetailView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var showFullInstructions = false

    var body: some View {
        ScrollView(.vertical) {
            VStack {
                if let meal = viewModel.selectedMeal, meal.isDetailsLoaded {
                    
                    meal.getFullImage()
                        .padding()
                    
                    HStack {
                        Text(meal.strMeal)
                            .font(.title.bold())
                        Spacer()
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    
                    instructionsView(meal: meal)
                    IngredientsView(meal: meal)
                    
                } else {
                    ProgressView()
                }
            }
            .padding()
        }
        .onAppear {
            // Load meal details
            if let mealID = viewModel.selectedMeal?.idMeal, !viewModel.selectedMeal!.isDetailsLoaded {
                Task { await viewModel.loadMealDetails(id: mealID) }
            }
        }
    }
    
    /// View for displaying the cooking instructions of the meal
    /// Has a button to show more or less of the instructions
    private func instructionsView(meal: Meal) -> some View {
        VStack(alignment: .leading) {
            if showFullInstructions {
                Text(meal.strInstructions ?? "No instructions available.")
                    .lineLimit(nil)
                Button("Show Less") {
                    withAnimation { showFullInstructions.toggle() }
                }
            } else {
                Text(meal.strInstructions ?? "No instructions available.")
                    .lineLimit(9)
                Button("Show More") {
                    withAnimation { showFullInstructions.toggle() }
                }
            }
        }
        .padding()
    }
}

/// Ingredients section of the meal details view
/// Displays each ingredient as an image alongside its name and quantity
struct IngredientsView: View {
    var meal: Meal

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Ingredients")
                    .font(.title3.bold())
                Spacer()
            }
            .padding(.vertical)

            ForEach(meal.ingredients, id: \.self) { ingredient in
                HStack {
                    ingredientImageView(for: ingredient.name)
                        .frame(width: 50, height: 50)

                    VStack(alignment: .leading) {
                        Text(ingredient.name)
                        Text(ingredient.measure)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 6)
            }
        }
        .padding()
    }

    /// Fetches and displays an image for the given ingredient
    /// Falls back to a generic placeholder if the image cannot be loaded
    @ViewBuilder
    private func ingredientImageView(for ingredient: String) -> some View {
        let formattedName = ingredient.replacingOccurrences(of: " ", with: "-")
        let urlString = "https://www.themealdb.com/images/ingredients/\(formattedName)-Small.png"
        if let url = URL(string: urlString) {
            AsyncImage(url: url) { image in
                image.resizable()
            } placeholder: {
                Image(systemName: "photo.on.rectangle")
            }
        } else {
            Image(systemName: "photo.on.rectangle")
        }
    }
}

