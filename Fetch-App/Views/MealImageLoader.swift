//
//  MealImageLoader.swift
//  Fetch-App
//
//  Created by Ignacio Juarez on 7/23/24.
//

import SwiftUI

/// Extension of `Meal` Model to handle image fetching and display logic using SwiftUI views
extension Meal {
    
    /// SwiftUI view for the preview image of a meal
    /// Attempts to load a `/preview` image and falls back to the full image or a placeholder
    /// - Returns: SwiftUI view with preview image of the meal
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
                    ProgressView() // Display progress indicator while image is loading
                @unknown default:
                    getFullImage() // Fallback for unknown cases
                }
            }
            .aspectRatio(contentMode: .fill)
        } else {
            fallbackImage()
        }
    }
    
    /// SwiftUI view for the `full res` image of a meal. It falls back to a placeholder image if the image fails to load
    /// - Returns: A SwiftUI view that displays the full image of the meal
    @ViewBuilder
    func getFullImage() -> some View {
        if let imageUrl = self.strMealThumb, let originalUrl = URL(string: imageUrl) {
            AsyncImage(url: originalUrl) { phase in
                switch phase {
                case .success(let image):
                    image.resizable()
                case .failure(_):
                    fallbackImage() // Fallback to full image if preview fails
                case .empty:
                    ProgressView() // Display progress indicator while image is loading
                @unknown default:
                    fallbackImage() // Fallback for future cases not covered by current implementation
                }
            }
            .aspectRatio(contentMode: .fill)
        } else {
            fallbackImage() // Display a fallback image if URL is not valid
        }
    }
    
    /// SwiftUI view that serves as a fallback when meal images fail to load or URLs are invalid
    /// - Returns: SwiftUI view with a system image as the fallback.
    @ViewBuilder
    private func fallbackImage() -> some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFit()
    }
}
