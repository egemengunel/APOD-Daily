//
//  APODViewModel.swift
//  Daily APOD Wallpaper
//
//  Created by Egemen Günel on 22/11/2023.
//

import Foundation

class APODViewModel: ObservableObject {
    @Published var apod: APOD?
    @Published var isLoading = false
    private let apiKey = "***REMOVED***"
    private let favoritesManager = FavoritesManager()
    
    func fetchAPOD() {
        isLoading = true
        let urlString = "https://api.nasa.gov/planetary/apod?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let data = data {
                    let decoder = JSONDecoder()
                    if let decodedResponse = try? decoder.decode(APOD.self, from: data) {
                        self?.apod = decodedResponse
                    }
                }
            }
        }.resume()
    }
    func addFavorite() {
        guard var currentApod = apod else { return }
                currentApod.isFavorite = true // Set the favorite flag
                apod = currentApod // Assign the updated APOD back to @Published property
                favoritesManager.saveFavorite(apod: currentApod) // Save to Favorites
    }
    func removeFavorite() {
            guard var currentApod = apod else { return }
            currentApod.isFavorite = false // Unset the favorite flag
            apod = currentApod // Assign the updated APOD back to @Published property
            favoritesManager.removeFavorite(apod: currentApod) // Remove from Favorites
        }
    func loadFavorites() {
           let favorites = favoritesManager.loadFavorites()
           // Do something with the loaded favorites, e.g., check if the current APOD is favorited
           if let currentApod = apod, favorites.contains(currentApod) {
               self.apod?.isFavorite = true
        }
    }
    func toggleFavoriteStatus() {
            guard let currentApod = apod else { return }
            apod?.isFavorite.toggle() // Toggle the isFavorite property

            if currentApod.isFavorite {
                favoritesManager.saveFavorite(apod: currentApod)
            } else {
                favoritesManager.removeFavorite(apod: currentApod)
            }
        }
}

