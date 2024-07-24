//
//  MealImageLoader.swift
//  Fetch-App
//
//  Created by Ignacio Juarez on 7/23/24.
//

import SwiftUI

extension Meal {
    
    @ViewBuilder
    func getPreviewImage() -> some View {
        if let imageUrl = self.strMealThumb, let previewUrl = URL(string: imageUrl + "/preview") {
            AsyncImage(url: previewUrl) { phase in
                switch phase {
                case .success(let image):
                    image.resizable()
                case .failure(_):
                    getFullImage() // Fallback to full image if preview fails
                case .empty:
                    ProgressView()
                @unknown default:
                    getFullImage() // Fallback for unknown cases
                }
            }
            .aspectRatio(contentMode: .fill)
        } else {
            fallbackImage()
        }
    }
    
    @ViewBuilder
    func getFullImage() -> some View {
        if let imageUrl = self.strMealThumb, let originalUrl = URL(string: imageUrl) {
            AsyncImage(url: originalUrl) { phase in
                switch phase {
                case .success(let image):
                    image.resizable()
                case .failure(_):
                    fallbackImage() // Show default image if full image also fails
                case .empty:
                    ProgressView()
                @unknown default:
                    fallbackImage()
                }
            }
            .aspectRatio(contentMode: .fill)
        } else {
            fallbackImage()
        }
    }
    
    @ViewBuilder
    private func fallbackImage() -> some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFit()
    }
}
