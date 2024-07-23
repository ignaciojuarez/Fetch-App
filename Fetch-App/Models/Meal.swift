//
//  Meal.swift
//  Fetch-App
//
//  Created by Ignacio Juarez on 7/22/24.
//

import Foundation

struct Meal: Identifiable, Hashable, Codable {
    var id: String { idMeal }
    let idMeal: String
    let strMeal: String
    let strMealThumb: URL
    var strInstructions: String?
    var ingredients: [String]?
}
