//
//  FavoritedAPODsView.swift
//  Daily APOD Wallpaper
//
//  Created by Egemen Günel on 24/11/2023.
//

import SwiftUI
import PhotosUI

struct FavoritedAPODsView: View {
    @ObservedObject private var favoritesManager = FavoritesManager.shared
    @StateObject private var viewModel = APODViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(favoritesManager.getFavorites()) { apod in
                    NavigationLink {
                        DetailAPODView(apod: apod)
                    } label: {
                        APODRowView(apod: apod)
                    }
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    FavoritedAPODsView()
        .environmentObject(APODViewModel())
}

