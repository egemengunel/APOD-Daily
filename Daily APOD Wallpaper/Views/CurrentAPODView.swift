//
//  CurrentAPODView.swift
//  Daily APOD Wallpaper
//
//  Created by Egemen Günel on 24/11/2023.
//

import SwiftUI
import PhotosUI

struct CurrentAPODView: View {
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

                    // Favorite and Share Buttons
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.toggleFavoriteStatus()
                        }) {
                            Image(systemName: viewModel.apod?.isFavorite == true ? "heart.fill" : "heart")
                                .font(.title2)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .clipShape(Circle())
                                .foregroundColor(viewModel.apod?.isFavorite == true ? .red : .blue)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            if let currentApod = viewModel.apod {
                                saveImageToPhotos(url: currentApod.hdurl)
                            }
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title2)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .clipShape(Circle())
                                .foregroundColor(.blue)
                        }
                        Spacer()
                    }
                    .padding()
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
            viewModel.fetchAPOD()
        }
    }

    private func saveImageToPhotos(url: String) {
        guard let imageUrl = URL(string: url),
              let imageData = try? Data(contentsOf: imageUrl),
              let image = UIImage(data: imageData) else {
            self.saveError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "The image data could not be loaded."])
            self.showingSaveAlert = true
            return
        }

        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.saveError = nil
                } else {
                    self.saveError = error as NSError?
                }
                self.showingSaveAlert = true
            }
        }
    }
}
