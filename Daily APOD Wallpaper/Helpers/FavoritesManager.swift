//
//  FavoritesManager.swift
//  Daily APOD Wallpaper
//
//  Created by Egemen Günel on 24/11/2023.
//

import Foundation

class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()
    @Published private var favoritedApods: [APOD] = []
    private let favoritesKey = "Favorites"
    
    init() {
        loadFavorites()
    }
    
    func saveFavorite(apod: APOD) {
        if !favoritedApods.contains(where: { $0.id == apod.id }) {
            favoritedApods.append(apod)
            save(favorites: favoritedApods)
        }
    }
    
    func removeFavorite(apod: APOD) {
        favoritedApods.removeAll { $0.id == apod.id }
        save(favorites: favoritedApods)
    }
    
    func loadFavorites() {
        if let favoritesData = UserDefaults.standard.data(forKey: favoritesKey),
           let favorites = try? JSONDecoder().decode([APOD].self, from: favoritesData) {
            self.favoritedApods = favorites
        }
    }
    
    func getFavorites() -> [APOD] {
        return favoritedApods
    }
    
    private func save(favorites: [APOD]) {
        if let favoritesData = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(favoritesData, forKey: favoritesKey)
        }
    }
    
    func isFavorite(apod: APOD) -> Bool {
        return favoritedApods.contains(where: { $0.id == apod.id })
    }
}



