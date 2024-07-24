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
    var ingredients: [Ingredient] = []
    var isDetailsLoaded: Bool { strInstructions != nil }

    struct Ingredient: Hashable, Codable {
        let name: String
        let measure: String
    }

    enum CodingKeys: String, CodingKey {
        case idMeal, strMeal, strMealThumb, strInstructions
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        idMeal = try container.decode(String.self, forKey: .idMeal)
        strMeal = try container.decode(String.self, forKey: .strMeal)
        strMealThumb = try container.decodeIfPresent(String.self, forKey: .strMealThumb)
        strInstructions = try container.decodeIfPresent(String.self, forKey: .strInstructions)
        ingredients = try Meal.parseIngredients(from: decoder)
    }

    private static func parseIngredients(from decoder: Decoder) throws -> [Ingredient] {
        let otherContainer = try decoder.singleValueContainer()
        let dictionary = try otherContainer.decode([String: String?].self)
        return (1...20).compactMap { index in
            guard let ingredientName = dictionary["strIngredient\(index)"] as? String,
                  let measure = dictionary["strMeasure\(index)"] as? String,
                  !ingredientName.isEmpty else {
                return nil
            }
            return Ingredient(name: ingredientName, measure: measure)
        }
    }
}
