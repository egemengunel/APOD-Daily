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
            VStack(spacing: 0) {
                //ContentArea
                ZStack {
                    switch selectedTab {
                    case 0:
                        NavigationView {
                            TodaysAPODView()
                                .navigationBarTitleDisplayMode(.inline)
                                .navigationTitle("Today's APOD")
                        }
                    case 1:
                        FavoritedAPODsView()
                    case 2:
                        PreviousAPODsView()
                    default:
                        NavigationView {
                            TodaysAPODView()
                                .navigationBarTitleDisplayMode(.inline)
                                .navigationTitle("Today's APOD")
                        }
                        
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                HStack(spacing: 70) {
                    //Bottom tab bar
                    BottomBarItem(
                        iconName: "photo.on.rectangle.angled",
                        title: "Today",
                        isSelected: selectedTab == 0,
                        action: { selectedTab = 0 }
                        
                    )
                    BottomBarItem(
                        iconName: "heart.fill",
                        title: "Favorites",
                        isSelected: selectedTab == 1,
                        action: { selectedTab = 1 }
                    )
                    BottomBarItem(
                        iconName: "clock.arrow.circlepath",
                        title: "Previous",
                        isSelected: selectedTab == 2,
                        action: { selectedTab = 2 }
                    )
                }
                .padding(.horizontal)
                .padding(.vertical)
                .background(Color(UIColor.systemBackground))
            }
        .environmentObject(viewModel)
    }
}
    #Preview {
        ContentView()
    }
    
    
 
