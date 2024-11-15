//
//  ContentView.swift
//  Daily APOD Wallpaper
//
//  Created by Egemen Günel on 22/11/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = APODViewModel()
    @State private var selectedTab = 0

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack {
                    switch selectedTab {
                    case 0:
                        CurrentAPODView()
                    case 1:
                        FavoritedAPODsView()
                    case 2:
                        PreviousAPODsView()
                    default:
                        CurrentAPODView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                HStack {
                    Spacer(minLength: geometry.size.width * 0.1)
                    BottomBarItem(
                        iconName: "photo.on.rectangle.angled",
                        title: "Today",
                        isSelected: selectedTab == 0,
                        action: { selectedTab = 0 }
                    )
                    Spacer()
                    BottomBarItem(
                        iconName: "heart.fill",
                        title: "Favorites",
                        isSelected: selectedTab == 1,
                        action: { selectedTab = 1 }
                    )
                    Spacer()
                    BottomBarItem(
                        iconName: "clock.arrow.circlepath",
                        title: "Previous",
                        isSelected: selectedTab == 2,
                        action: { selectedTab = 2 }
                    )
                    Spacer(minLength: geometry.size.width * 0.1)
                }
                .padding(.vertical, 8)
                .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.bottom))
            }
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    ContentView()
}



