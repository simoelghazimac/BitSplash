import SwiftUI
import UIKit

struct WallpaperDetailView: View {
	let wallpaper: Wallpaper
	@State private var isSaving = false
	@State private var showShare = false

	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 16) {
				AsyncImage(url: wallpaper.url) { img in
					img.resizable().aspectRatio(contentMode: .fit)
				} placeholder: {
					Rectangle().fill(Color(.secondarySystemFill)).frame(height: 240)
				}
				HStack(spacing: 12) {
					Button(action: saveImage) {
						Label("Save to Device", systemImage: "square.and.arrow.down")
					}
					Button(action: { showShare = true }) {
						Label("Share", systemImage: "square.and.arrow.up")
					}
				}
				.buttonStyle(.borderedProminent)
				Text("Name: \(wallpaper.name)")
				Text("Author: \(wallpaper.author)")
				Text("Category: \(wallpaper.category)")
				Spacer(minLength: 20)
			}
			.padding()
		}
		.navigationBarTitleDisplayMode(.inline)
		.sheet(isPresented: $showShare) {
			ShareSheet(activityItems: [wallpaper.url])
		}
	}

	private func saveImage() {
		isSaving = true
		Task {
			defer { isSaving = false }
			do {
				let (data, _) = try await URLSession.shared.data(from: wallpaper.url)
				try await PhotosSaver.saveImageDataToPhotos(data)
			} catch {
				// no-op in this lightweight sample
			}
		}
	}
}

struct ShareSheet: UIViewControllerRepresentable {
	let activityItems: [Any]
	func makeUIViewController(context: Context) -> UIActivityViewController {
		UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
	}
	func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}