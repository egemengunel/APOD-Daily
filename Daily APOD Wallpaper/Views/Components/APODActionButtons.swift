import SwiftUI
import PhotosUI

struct APODActionButtons: View {
    let apod: APOD
    @ObservedObject var viewModel: APODViewModel
    @ObservedObject private var favoritesManager = FavoritesManager.shared
    @Binding var showingSaveAlert: Bool
    @Binding var saveError: NSError?
    @State private var isSaving = false
    
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
                Task { @MainActor in
                    isSaving = true
                    await saveImageToPhotos(url: apod.hdurl)
                }
            }) {
                if isSaving {
                    ProgressView()
                        .frame(width: 20, height: 20)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                } else {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title2)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                        .foregroundColor(.blue)
                }
            }
            .disabled(isSaving)
            Spacer()
        }
        .padding()
    }
    
    private func saveImageToPhotos(url: String) async {
        guard let imageUrl = URL(string: url) else {
            self.saveError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            self.showingSaveAlert = true
            self.isSaving = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: imageUrl)
            guard let image = UIImage(data: data) else {
                self.saveError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "The image data could not be loaded."])
                self.showingSaveAlert = true
                self.isSaving = false
                return
            }
            
            try await PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }
            
            self.saveError = nil
            self.showingSaveAlert = true
            self.isSaving = false
        } catch {
            self.saveError = error as NSError
            self.showingSaveAlert = true
            self.isSaving = false
        }
    }
}
