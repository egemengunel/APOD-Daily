//
//  FavoritesManager.swift
//  Daily APOD Wallpaper
//
//  Created by Egemen Günel on 24/11/2023.
//

import Foundation

class FavoritesManager {
    static let shared = FavoritesManager()
    private let favoritesKey = "Favorites"
    
    func saveFavorite(apod: APOD) {
        var favorites = loadFavorites()
        if !favorites.contains(apod) {
            favorites.append(apod)
            save(favorites: favorites)
        }
    }
    
    func removeFavorite(apod: APOD) {
        var favorites = loadFavorites()
        favorites.removeAll { $0.id == apod.id }
        save(favorites: favorites)
    }
    
    func loadFavorites() -> [APOD] {
        if let favoritesData = UserDefaults.standard.data(forKey: favoritesKey),
           let favorites = try? JSONDecoder().decode([APOD].self, from: favoritesData) {
            return favorites
        }
        return []
    }
    
    private func save(favorites: [APOD]) {
        if let favoritesData = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(favoritesData, forKey: favoritesKey)
        }
    }
}

