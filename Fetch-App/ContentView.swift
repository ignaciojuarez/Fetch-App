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
// - Async Genetic Type URL Data Fetcher Class
// - Display a List of Desserts (SwiftUI)
// - Meal Detail View as .sheet (SwiftUI)

// EXTRAS:
// - Meal Images using /preview
// - Custom Search bar for  Meals
// - Custom Hex Color Extension


struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        ScrollView {
            VStack {
                header
                customSearchBar
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(viewModel.filteredMeals, id: \.idMeal) { meal in
                        Button {
                            viewModel.selectedMeal = meal
                        } label: {
                            MealPreviewView(meal: meal)
                        }
                    }
                }
            }
            .padding()
        }
        .sheet(item: $viewModel.selectedMeal) { _ in
            MealDetailView()
        }
        .onAppear {
            Task { await viewModel.loadMeals() }
        }
        .background(Color.init(hex: "F0F0F0"))
    }
    
    private var header: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Hello, Fetch")
                    .font(.callout.bold())
                    .foregroundStyle(.opacity(0.5))
                
                Text("What would you like to cook today?")
                    .font(.title2.bold())
            }
            Spacer()
            VStack() {
                Image("icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 38, height: 38)
                    .cornerRadius(100)
            }
        }
        .padding(.horizontal)
    }

    private var customSearchBar: some View {
        HStack {
            TextField("Search desserts", text: $viewModel.searchText)
                .padding(12)
                .padding(.horizontal, 30)
                .background(Color(.white))
                .cornerRadius(20)
                .overlay {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 14)
                        
                        if !viewModel.searchText.isEmpty {
                            Button {
                                viewModel.searchText = ""
                            } label: {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(Color.init(hex: "777777"))
                                    .padding(.trailing, 14)
                            }
                        }
                    }
                }
        }
        .padding()
    }
}
#Preview {
    ContentView()
        .environmentObject(ViewModel())
}
