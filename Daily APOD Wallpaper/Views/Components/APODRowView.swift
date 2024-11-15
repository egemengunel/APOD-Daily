import SwiftUI

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