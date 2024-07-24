//
//  Category.swift
//  Fetch-App
//
//  Created by Ignacio Juarez on 7/23/24.
//

import Foundation

/// Represents a category of meals.
struct Category: Identifiable, Codable, Hashable {
    
    /// id using `idCategory`
    var id: String { idCategory }
    
    /// Unique API id for the category
    let idCategory: String
    
    /// Name of the category.
    let strCategory: String
    
    /// URL string of the category's thumbnail image
    let strCategoryThumb: String
    
    /// Description of category
    let strCategoryDescription: String
}
