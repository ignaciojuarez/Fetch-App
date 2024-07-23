//
//  ViewModel.swift
//  Fetch-App
//
//  Created by Ignacio Juarez on 7/22/24.
//

import Foundation

class ViewModel: ObservableObject {
    
    @Published var meals: [Meal] = []
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

    func loadMealDetails(id: String) async -> Meal? {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(id)") else { return nil }
        do {
            let result = try await dataFetcher.fetchData(from: url)
            return result["meals"]?.first
        } catch {
            print("Error loading meal details: \(error)")
            return nil
        }
    }
}
