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

struct APODRowView: View {
    let apod: APOD
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(apod.title)
                .font(.headline)
            Text(apod.explanation)
                .font(.subheadline)
                .lineLimit(2)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct DetailAPODView: View {
    let apod: APOD
    @ObservedObject private var favoritesManager = FavoritesManager.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let imageUrl = URL(string: apod.hdurl) {
                    AsyncImage(url: imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        case .failure:
                            Image(systemName: "photo.fill")
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(apod.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(apod.date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(apod.explanation)
                        .font(.body)
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

