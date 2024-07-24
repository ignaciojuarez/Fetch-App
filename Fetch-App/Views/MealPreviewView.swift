//
//  MealPreview.swift
//  Fetch-App
//
//  Created by Ignacio Juarez on 7/23/24.
//

import SwiftUI

struct MealPreviewView: View {
    var meal: Meal
    
    var body: some View {
        VStack(spacing: 5) {
            meal.getPreviewImage()
                .frame(width: 150, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 18))
            
            HStack {
                Text(meal.strMeal)
                    .foregroundColor(.black)
                    .font(.subheadline)
                    .lineLimit(1)
                    .bold()
                Spacer()
            }
        }
        .frame(width: 150, height: 150)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
