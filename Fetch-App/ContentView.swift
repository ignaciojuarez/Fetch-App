//
//  ContentView.swift
//  Fetch-App
//
//  Created by Ignacio Juarez on 7/22/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        ScrollView {
            VStack {
                headerView
                customSearchBar
                categoryScrollView
                recepiesView
            }
            .padding()
        }
        .sheet(item: $viewModel.selectedMeal) { _ in
            MealDetailView()
        }
        .onAppear {
            Task {
                await viewModel.loadCategories()
                await viewModel.setDefaultCategory()
            }
        }
        .background(Color.init(hex: "F0F0F0"))
    }
    
    private var headerView: some View {
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
                        CategoryItemView(category: category, selectedCategory: $viewModel.selectedCategory)
                            .onTapGesture {
                                viewModel.selectedCategory = category
                                Task {
                                    await viewModel.loadMeals(category: category.strCategory)
                                }
                            }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
    }
    
    private var recepiesView: some View {
        Group {
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
    }
}

#Preview {
    ContentView()
        .environmentObject(ViewModel())
}
