//
//  FavoritedAPODsView.swift
//  Daily APOD Wallpaper
//
//  Created by Egemen Günel on 24/11/2023.
//

import SwiftUI

struct FavoritedAPODsView: View {
    @State private var favoritedApods: [APOD] = []
    private let favoritesManager = FavoritesManager()

    var body: some View {
        List(favoritedApods, id: \.id) { apod in
            VStack(alignment: .leading) {
                Text(apod.title)
                //more details could be added here
            }
        }
        .onAppear {
            favoritedApods = favoritesManager.loadFavorites()
        }
    }
}
