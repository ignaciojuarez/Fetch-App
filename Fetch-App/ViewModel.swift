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
    
    // MARK: LOADING FUNCTIONS()
    
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
            DispatchQueue.main.async {
                self.selectedMeal = result["meals"]?.first
            }
        } catch {
            DispatchQueue.main.async {
                print("Error loading meal details: \(error)")
            }
        }
    }
}
