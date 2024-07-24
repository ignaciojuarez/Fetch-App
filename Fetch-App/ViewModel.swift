//
//  ViewModel.swift
//  Fetch-App
//
//  Created by Ignacio Juarez on 7/22/24.
//

import Foundation

class ViewModel: ObservableObject {
    
    @Published var meals: [Meal] = []
    @Published var selectedMeal: Meal?
    @Published var categories: [Category] = []
    @Published var selectedCategory: Category?
    private let dataFetcher = DataFetcherService<[String: [Meal]]>()
    
    // MARK: SEARCH
    @Published var searchText = ""
    var filteredMeals: [Meal] {
        if searchText.isEmpty { return meals }
        else { return meals.filter { $0.strMeal.lowercased().contains(searchText.lowercased()) } }
     }
    
    // MARK: URL-FETCH FUNC()
    
    func loadMeals() async {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else { return }
        do {
            let result = try await dataFetcher.fetchData(from: url)
            DispatchQueue.main.async {
                self.meals = result["meals"] ?? []
            }
        } catch {
            DispatchQueue.main.async {
                print("Error loading meals: \(error)")
            }
        }
    }

    func loadMealDetails(id: String) async {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(id)") else { return }
        do {
            let result = try await dataFetcher.fetchData(from: url)
            if let detailedMeal = result["meals"]?.first {
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

    // Helper struct to decode the JSON response
    struct CategoryResponse: Codable {
        let categories: [Category]
    }
}
