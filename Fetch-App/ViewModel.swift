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
    private let dataFetcher = DataFetcherService<[String: [Meal]]>()
    
    // MARK: SEARCH
    @Published var searchText = ""
    var filteredMeals: [Meal] {
         if searchText.isEmpty {
             return meals
         } else {
             return meals.filter { $0.strMeal.lowercased().contains(searchText.lowercased()) }
         }
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
}
