//
//  ContentView.swift
//  Daily APOD Wallpaper
//
//  Created by Egemen Günel on 22/11/2023.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    var body: some View {
        TabView {
            CurrentAPODView()
                .tabItem {
                    Label("Today", systemImage: "photo.on.rectangle.angled")
                }

            FavoritedAPODsView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
