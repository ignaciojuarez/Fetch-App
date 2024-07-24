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
                    
                    Text(meal.strMeal)
                        .font(.title)
                        .padding()
                    
                    instructionsView(meal: meal)
                    ingredientsView(meal: meal)
                    
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
    @ViewBuilder
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

    // MARK: - Ingredients View
    @ViewBuilder
    private func ingredientsView(meal: Meal) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Ingredients")
                    .font(.title3.bold())
                    .padding(.horizontal)
                    .padding(.top)
                
                Spacer()
            }
            
            ForEach(meal.ingredients, id: \.self) { ingredient in
                Text("\(ingredient.name): \(ingredient.measure)")
                    .padding(.horizontal)
                    .padding(.bottom, 2)
            }
        }
    }
}
