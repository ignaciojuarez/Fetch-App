//
//  MealDetailsView.swift
//  Fetch-App
//
//  Created by Ignacio Juarez on 7/22/24.
//

import SwiftUI

struct MealDetailView: View {
    var mealID: String
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            if let meal = viewModel.selectedMeal {
                Text(meal.strMeal)
                    .font(.title)
                Text("Instructions: \(meal.strInstructions ?? "No instructions available.")")
                    .padding()
                List(meal.ingredients ?? [], id: \.self) { ingredient in
                    Text(ingredient)
                }
            } else {
                Text("Loading meal details...")
                    .onAppear {
                        Task {
                            await viewModel.loadMealDetails(id: mealID)
                        }
                    }
            }
        }
        .navigationTitle("Meal Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
