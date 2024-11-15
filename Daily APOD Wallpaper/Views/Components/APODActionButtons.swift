import SwiftUI
import PhotosUI

struct APODActionButtons: View {
    let apod: APOD
    @ObservedObject var viewModel: APODViewModel
    @ObservedObject private var favoritesManager = FavoritesManager.shared
    @Binding var showingSaveAlert: Bool
    @Binding var saveError: NSError?
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                viewModel.apod = apod
                viewModel.toggleFavoriteStatus()
            }) {
                Image(systemName: favoritesManager.isFavorite(apod: apod) ? "heart.fill" : "heart")
                    .font(.title2)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(Circle())
                    .foregroundColor(favoritesManager.isFavorite(apod: apod) ? .red : .blue)
            }
            
            Spacer()
            
            Button(action: {
                saveImageToPhotos(url: apod.hdurl)
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
    }
    
    private func saveImageToPhotos(url: String) {
        Task {
            guard let imageUrl = URL(string: url) else {
                await MainActor.run {
                    self.saveError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
                    self.showingSaveAlert = true
                }
                return
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: imageUrl)
                guard let image = UIImage(data: data) else {
                    await MainActor.run {
                        self.saveError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "The image data could not be loaded."])
                        self.showingSaveAlert = true
                    }
                    return
                }
                
                try await PHPhotoLibrary.shared().performChanges {
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }
                
                await MainActor.run {
                    self.saveError = nil
                    self.showingSaveAlert = true
                }
            } catch {
                await MainActor.run {
                    self.saveError = error as NSError
                    self.showingSaveAlert = true
                }
            }
        }
    }
}