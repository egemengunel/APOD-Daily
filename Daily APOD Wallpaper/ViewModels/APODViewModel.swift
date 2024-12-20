//
//  APODViewModel.swift
//  Daily APOD Wallpaper
//
//  Created by Egemen Günel on 22/11/2023.
//

import Foundation
import Combine

@MainActor
class APODViewModel: ObservableObject {
    @Published var apod: APOD?
    @Published var isLoading = false
    @Published var error: Error?
    
    private let networkService = NetworkService.shared
    private let favoritesManager = FavoritesManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Observe favorites changes
        favoritesManager.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    func fetchTodaysAPOD() {
        Task {
            isLoading = true
            do {
                var fetchedApod = try await networkService.fetchAPOD()
                // Check if fetched APOD is in favorites
                fetchedApod.isFavorite = favoritesManager.isFavorite(apod: fetchedApod)
                apod = fetchedApod
            } catch {
                self.error = error
            }
            isLoading = false
        }
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
    
    func isFavorite(apod: APOD) -> Bool {
        favoritesManager.isFavorite(apod: apod)
    }
}


