//
//  Meal.swift
//  Fetch-App
//
//  Created by Ignacio Juarez on 7/22/24.
//

import Foundation

/// Struc with properties of a meal recepie
struct Meal: Identifiable, Hashable, Codable {
    
    /// id using `idMeal`
    var id: String { idMeal }
    
    /// The unique API id for the meal
    let idMeal: String
    
    /// The name of the meal
    let strMeal: String
    
    /// URL string of the meal's thumbnail image. Optional  (not all meals have an image)
    let strMealThumb: String?
    
    /// Cooking instructions for the meal. Optional (not all meals have instructions)
    var strInstructions: String?
    
    /// A list of `Ingredient` needed for the meal
    var ingredients: [Ingredient] = []
    
    /// Computed property to check if meal details (like instructions) are loaded
    var isDetailsLoaded: Bool { strInstructions != nil }

    /// A nested structure defining an ingredient with its name and measurement
    struct Ingredient: Hashable, Codable {
        let name: String
        let measure: String
    }

    /// Enum with coding keys for encoding and decoding the struc from JSON
    enum CodingKeys: String, CodingKey {
        case idMeal, strMeal, strMealThumb, strInstructions
    }

    /// Custom init to decode a `Meal` from a decoder. Handles decoding of meal properties and dynamic parsing of ingredients.
    /// - Parameter decoder: The decoder to decode data from
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        idMeal = try container.decode(String.self, forKey: .idMeal)
        strMeal = try container.decode(String.self, forKey: .strMeal)
        strMealThumb = try container.decodeIfPresent(String.self, forKey: .strMealThumb)
        strInstructions = try container.decodeIfPresent(String.self, forKey: .strInstructions)
        ingredients = try Meal.parseIngredients(from: decoder)
    }

    /// Static function to parse ingredients from a decoder. Handles up to 20 ingredients
    /// - Parameter decoder: Decoder to extract ingredient data from
    /// - Returns: An array of `Ingredient` structs.
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
