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
    let strMealThumb: String?
    var strInstructions: String?
    var ingredients: [String]?
    var isDetailsLoaded: Bool { strInstructions != nil }
}
