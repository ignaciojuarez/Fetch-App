//
//  MealDetailsView.swift
//  Fetch-App
//
//  Created by Ignacio Juarez on 7/22/24.
//

import SwiftUI

struct MealDetailView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var showFullInstructions = false

    var body: some View {
        ScrollView(.vertical) {
            VStack {
                if let meal = viewModel.selectedMeal, meal.isDetailsLoaded {
                    
                    meal.getFullImage()
                    
                    HStack {
                        Text(meal.strMeal)
                            .font(.title.bold())
                            .padding()
                        Spacer()
                    }
                    
                    instructionsView(meal: meal)
                    IngredientsView(meal: meal)
                    
                } else {
                    ProgressView()
                }
            }
            .padding()
        }
        .onAppear {
            if let mealID = viewModel.selectedMeal?.idMeal, !viewModel.selectedMeal!.isDetailsLoaded {
                Task { await viewModel.loadMealDetails(id: mealID) }
            }
        }
    }
    
    // MARK: - Instructions View
    private func instructionsView(meal: Meal) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Instructions")
                    .font(.title3.bold())
                    .padding(.horizontal)
                    .padding(.top)
                Spacer()
            }

            if showFullInstructions {
                Text(meal.strInstructions ?? "No instructions available.")
                    .lineLimit(nil)
                    .padding()
                Button("Show Less") {
                    withAnimation {
                        showFullInstructions.toggle()
                    }
                }
                .padding(.horizontal)
            } else {
                Text(meal.strInstructions ?? "No instructions available.")
                    .lineLimit(9)
                    .padding()
                Button("Show More") {
                    withAnimation {
                        showFullInstructions.toggle()
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct IngredientsView: View {
    var meal: Meal

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Ingredients")
                    .font(.title3.bold())
                    .padding()

                Spacer()
            }

            ForEach(meal.ingredients, id: \.self) { ingredient in
                HStack {
                    ingredientImageView(for: ingredient.name)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())

                    VStack(alignment: .leading) {
                        Text(ingredient.name)
                        Text(ingredient.measure)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 6)
                .padding(.horizontal)
            }
        }
    }

    @ViewBuilder
    private func ingredientImageView(for ingredient: String) -> some View {
        let formattedName = ingredient.replacingOccurrences(of: " ", with: "-")
        let urlString = "https://www.themealdb.com/images/ingredients/\(formattedName)-Small.png"
        if let url = URL(string: urlString) {
            AsyncImage(url: url) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
        } else {
            Image(systemName: "photo.on.rectangle")
                .resizable()
        }
    }
}

