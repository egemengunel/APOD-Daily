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
        currentApod.isFavorite.toggle()
        apod = currentApod // Update published property to refresh the view
        
        if currentApod.isFavorite {
            favoritesManager.saveFavorite(apod: currentApod)
        } else {
            favoritesManager.removeFavorite(apod: currentApod)
        }
    }
}


