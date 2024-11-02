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
        VStack {
            if let apod = viewModel.apod, let imageUrl = URL(string: apod.url) {
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                             .aspectRatio(contentMode: .fit)
                    case .failure:
                        Text("Failed to load image.")
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: .infinity)
                
                Text(apod.title)
                    .font(.title)
                    .padding()

                ScrollView {
                    Text(apod.explanation)
                        .padding()
                }

                HStack {
                    Button(action: {
                            viewModel.toggleFavoriteStatus()
                        }) {
                            
                            Image(systemName: viewModel.apod?.isFavorite == true ? "heart.fill" : "heart")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                    
                    Button("Save to Photos") {
                        saveImageToPhotos(url: apod.hdurl)
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                }
            } else if viewModel.isLoading {
                ProgressView()
            }

            Spacer()
        }
        .navigationTitle("APOD")
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

struct CurrentAPODView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentAPODView()
    }
}
