//
//  ViewModel.swift
//  Fetch-App
//
//  Created by Ignacio Juarez on 7/22/24.
//

import Foundation

/// Manages  fetching and handling of meal and category data for the UI
class ViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Array of `Meal` objects that represents the meals fetched based `selectedCategory`
    @Published var meals: [Meal] = []
    @Published var selectedMeal: Meal?
    
    /// Array of`Category` objects representing available meal categories.
    @Published var categories: [Category] = []
    @Published var selectedCategory: Category?
    
    /// Service to fetch data from a network source
    private let dataFetcher = DataFetcherService<[String: [Meal]]>()
    
    // MARK: - Search Functionality
    
    /// The search text used to filter meals
    @Published var searchText = ""
    
    /// Filters meals based on the search text, returning only those that match the query
    var filteredMeals: [Meal] {
        if searchText.isEmpty { return meals }
        else { return meals.filter { $0.strMeal.lowercased().contains(searchText.lowercased()) } }
     }
    
    // MARK: - Init of App
    
    init() {
        Task { await loadCategories() }
    }
    
    func setDefaultCategory() async {
        if let dessertsCategory = categories.first(where: { $0.strCategory == "Dessert" }) {
            selectedCategory = dessertsCategory
            await loadMeals(category: dessertsCategory.strCategory)
        }
    }
    
    // MARK: - Networking Methods
        
    /// Fetches meals from the API based on category
    /// - Parameter category: The category for which to fetch meals.
    func loadMeals(category: String) async {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=\(category)") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let result = try decoder.decode([String: [Meal]].self, from: data)
            if let fetchedMeals = result["meals"] {
                DispatchQueue.main.async {
                    self.meals = fetchedMeals
                }
            }
        } catch {
            DispatchQueue.main.async {
                print("Error loading meals: \(error)")
            }
        }
    }

    /// Fetches meal details about a specific meal by its ID.
    /// - Parameter id: The ID of the meal to fetch detaileds
    func loadMealDetails(id: String) async {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(id)") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let result = try decoder.decode([String: [Meal]].self, from: data)
            if let detailedMeals = result["meals"], let detailedMeal = detailedMeals.first {
                DispatchQueue.main.async {
                    // Update the meal in the meals array
                    if let index = self.meals.firstIndex(where: { $0.idMeal == id }) {
                        self.meals[index] = detailedMeal
                    }
                    // Set selectedMeal to the updated meal
                    self.selectedMeal = self.meals.first { $0.idMeal == id }
                }
            }
        } catch {
            DispatchQueue.main.async {
                print("Error loading meal details: \(error)")
            }
        }
    }
    
    /// Loads all available categories from the API.
    func loadCategories() async {
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode([String: [Category]].self, from: data)
            if let categories = decodedData["categories"] {
                DispatchQueue.main.async {
                    self.categories = categories
                }
            }
        } catch {
            print("Error loading categories: \(error)")
        }
    }
}
