//
//  ContentView.swift
//  Fetch-App
//
//  Created by Ignacio Juarez on 7/22/24.
//

import SwiftUI

// TODO:
// - favorites
// - cache

// DONE:
// - Async Genetic Type URL Data Fetcher Class
// - Display a List of Desserts (SwiftUI)
// - Meal Detail View as .sheet (SwiftUI)

// EXTRAS:
// - Images load as extension of Meal Model. And use /preview if available, or fallback on normal image (when needed)
// - Categories ScrollView with selection
// - Custom Search bar for Meals
// - Custom Hex Color Extension
// - Ingredient Images and Quantity
// - LazyLoading


struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        ScrollView {
            VStack {
                header
                customSearchBar
                categoryScrollView
                
                HStack {
                    Text("Recepies")
                        .font(.title3.bold())
                    Spacer()
                }
                .padding(.horizontal)
                
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
            Task {
                await viewModel.loadCategories()
                await viewModel.loadMeals()
            }
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
                .cornerRadius(18)
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
    
    private var categoryScrollView: some View {
        Group {
            HStack {
                Text("Categories")
                    .font(.title3.bold())
                Spacer()
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(viewModel.categories, id: \.id) { category in
                        VStack {
                            AsyncImage(url: URL(string: category.strCategoryThumb)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 55)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            Text(category.strCategory)
                                .font(.caption.bold())
                                .foregroundStyle(viewModel.selectedCategory == category ? Color.white : Color.black.opacity(0.8))
                        }
                        .frame(width: 80, height: 80)
                        .background(viewModel.selectedCategory == category ? Color.init(hex: "F8A91B") : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .onTapGesture {
                            viewModel.selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ViewModel())
}
