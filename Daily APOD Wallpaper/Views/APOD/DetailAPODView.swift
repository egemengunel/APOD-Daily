import SwiftUI
import PhotosUI

struct DetailAPODView: View {
    let apod: APOD
    @StateObject private var viewModel = APODViewModel()
    @State private var showingSaveAlert = false
    @State private var saveError: NSError?
    @State private var imageScale: CGFloat = 1.0
    @State private var lastImageScale: CGFloat = 1.0
    @State private var imageOffset: CGSize = .zero
    @State private var lastImageOffset: CGSize = .zero
    
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
                                .scaleEffect(imageScale)
                                .offset(imageOffset)
                                .gesture(
                                    MagnificationGesture()
                                        .onChanged { value in
                                            let delta = value / lastImageScale
                                            lastImageScale = value
                                            imageScale *= delta
                                        }
                                        .onEnded { _ in
                                            lastImageScale = 1.0
                                        }
                                )
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            imageOffset = CGSize(
                                                width: lastImageOffset.width + value.translation.width,
                                                height: lastImageOffset.height + value.translation.height
                                            )
                                        }
                                        .onEnded { _ in
                                            lastImageOffset = imageOffset
                                        }
                                )
                                .onTapGesture(count: 2) {
                                    withAnimation {
                                        imageScale = imageScale > 1 ? 1 : 2
                                        if imageScale == 1 {
                                            imageOffset = .zero
                                            lastImageOffset = .zero
                                        }
                                    }
                                }
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
                
                APODActionButtons(
                    apod: apod,
                    viewModel: viewModel,
                    showingSaveAlert: $showingSaveAlert,
                    saveError: $saveError
                )
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showingSaveAlert) {
            Alert(
                title: Text("Save Image"),
                message: Text(saveError == nil ? "The image has been saved to your Photos." : saveError!.localizedDescription),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
