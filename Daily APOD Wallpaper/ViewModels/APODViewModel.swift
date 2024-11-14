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
    private let apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
    private let favoritesManager = FavoritesManager.shared
    
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
                        var fetchedApod = decodedResponse
                        // Check if fetched APOD is in favorites, then set isFavorite accordingly
                        fetchedApod.isFavorite = self?.favoritesManager.isFavorite(apod: fetchedApod) ?? false
                        self?.apod = fetchedApod
                    }
                }
            }
        }.resume()
    }
    
    func toggleFavoriteStatus() {
        guard var currentApod = apod else { return }
        let newFavoriteStatus = !favoritesManager.isFavorite(apod: currentApod)
        currentApod.isFavorite = newFavoriteStatus
        
        if newFavoriteStatus {
            favoritesManager.saveFavorite(apod: currentApod)
        } else {
            favoritesManager.removeFavorite(apod: currentApod)
        }
        
        apod = currentApod
    }
}


