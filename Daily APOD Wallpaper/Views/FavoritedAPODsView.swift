//
//  FavoritedAPODsView.swift
//  Daily APOD Wallpaper
//
//  Created by Egemen Günel on 24/11/2023.
//

import SwiftUI

struct FavoritedAPODsView: View {
    @ObservedObject private var favoritesManager = FavoritesManager.shared

    var body: some View {
        List {
            ForEach(favoritesManager.getFavorites(), id: \.id) { apod in
                NavigationLink(destination: DetailView(apod: apod)) {
                    VStack(alignment: .leading) {
                        Text(apod.title)
                            .font(.headline)
                        Text(apod.explanation)
                            .font(.subheadline)
                            .lineLimit(3)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Favorites")
    }
}

struct DetailView: View {
    let apod: APOD
    
    var body: some View {
        ScrollView {
            VStack {
                if let imageUrl = URL(string: apod.url) {
                    AsyncImage(url: imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity)
                        case .failure:
                            Text("Failed to load image.")
                                .foregroundColor(.red)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                
                Text(apod.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()

                Text(apod.explanation)
                    .padding()
            }
            .navigationTitle("APOD Details")
        }
    }
}

