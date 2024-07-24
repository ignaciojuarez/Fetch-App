//
//  CategoryItemView.swift
//  Fetch-App
//
//  Created by Ignacio Juarez on 7/24/24.
//

import SwiftUI

struct CategoryItemView: View {
    var category: Category
    @Binding var selectedCategory: Category?
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: category.strCategoryThumb)) { image in
                image.resizable().scaledToFit()
            }
            placeholder: {
                ProgressView()
            }
            .frame(width: 55)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            Text(category.strCategory)
                .font(.caption.bold())
                .foregroundStyle(selectedCategory == category ? .white : Color.black.opacity(0.8))
        }
        .frame(width: 80, height: 80)
        .background(selectedCategory == category ? Color.init(hex: "F8A91B") : Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
