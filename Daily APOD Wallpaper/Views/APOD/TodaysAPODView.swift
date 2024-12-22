//
//  CurrentAPODView.swift
//  Daily APOD Wallpaper
//
//  Created by Egemen Günel on 24/11/2023.
//

import SwiftUI
import PhotosUI

struct TodaysAPODView: View {
    @StateObject var viewModel = APODViewModel()
    @State private var showingSaveAlert = false
    @State private var saveError: NSError?

    var body: some View {
        ScrollView {
            VStack {
                if let apod = viewModel.apod, let imageUrl = URL(string: apod.url) {
                    // APOD Image
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

                    // APOD Title
                    Text(apod.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding([.top, .horizontal])

                    // APOD Explanation
                    Text(apod.explanation)
                        .font(.body)
                        .padding(.horizontal)

                    // Replace the existing buttons with APODActionButtons
                    APODActionButtons(
                        apod: apod,
                        viewModel: viewModel,
                        showingSaveAlert: $showingSaveAlert,
                        saveError: $saveError
                    )
                } else if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text("No APOD available.")
                        .padding()
                }
            }
        }
        .alert(isPresented: $showingSaveAlert) {
            Alert(
                title: Text("Save Image"),
                message: Text(saveError == nil ? "The image has been saved to your Photos." : saveError!.localizedDescription),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear {
            viewModel.fetchTodaysAPOD()
        }
    }
}
