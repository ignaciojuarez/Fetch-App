//
//  MealDetailsView.swift
//  Fetch-App
//
//  Created by Ignacio Juarez on 7/22/24.
//

import SwiftUI

struct MealDetailView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        ScrollView(.vertical) {
            if let meal = viewModel.selectedMeal, meal.isDetailsLoaded {
                Text(meal.strMeal)
                    .font(.title)
                    .padding()
                
                HStack {
                    Text("Instructions")
                        .font(.title3.bold())
                        .padding(.horizontal)
                        .padding(.top)
                    Spacer()
                }
                
                Text(meal.strInstructions ?? "No instructions available.")
                    .padding()
                    .foregroundStyle(.opacity(0.8))
                
                HStack {
                    Text("Ingredients")
                        .font(.title3.bold())
                        .padding(.horizontal)
                    Spacer()
                }
                
                List(meal.ingredients ?? [], id: \.self) { ingredient in
                    Text(ingredient)
                }
            } else {
                ProgressView()
            }
        }
        .padding()
        .onAppear {
            if let mealID = viewModel.selectedMeal?.idMeal, !viewModel.selectedMeal!.isDetailsLoaded {
                Task { await viewModel.loadMealDetails(id: mealID) }
            }
        }
    }
}
