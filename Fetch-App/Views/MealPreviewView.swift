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
            mealImageView(meal: meal)
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
    
    @ViewBuilder
    private func mealImageView(meal: Meal) -> some View {
        Group {
            if let imageUrl = meal.strMealThumb, let url = URL(string: imageUrl + "/preview") {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image.resizable()
                    } else if phase.error != nil {
                        Image(systemName: "photo")
                            //.resizable()
                    } else {
                        ProgressView()
                    }
                }
                .aspectRatio(contentMode: .fill)
            } else {
                Image(systemName: "photo")
                    //.resizable()
                    //.scaledToFit()
            }
        }
        .frame(width: 150, height: 120)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 5)
        .foregroundColor(.gray)
    }
}
