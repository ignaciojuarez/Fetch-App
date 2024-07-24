//
//  Category.swift
//  Fetch-App
//
//  Created by Ignacio Juarez on 7/23/24.
//

import Foundation

struct Category: Identifiable, Codable, Hashable {
    var id: String { idCategory }
    let idCategory: String
    let strCategory: String
    let strCategoryThumb: String
    let strCategoryDescription: String
}
