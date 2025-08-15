import SwiftUI

struct ContentView: View {
	@StateObject private var viewModel = WallpapersViewModel()
	@State private var selectedCategory: Category?

	var body: some View {
		NavigationView {
			VStack(spacing: 0) {
				searchBar
				categoryScroll
				wallpaperGrid
			}
			.navigationTitle("BitSplash")
		}
		.task { await viewModel.load() }
	}

	private var searchBar: some View {
		HStack {
			Image(systemName: "magnifyingglass")
			TextField("Search", text: $viewModel.query)
		}
		.padding(12)
		.background(Color(.secondarySystemBackground))
		.cornerRadius(10)
		.padding()
	}

	private var categoryScroll: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 8) {
				ForEach(viewModel.categories) { cat in
					Button(action: { selectedCategory = cat }) {
						Text(cat.name)
							.font(.subheadline)
							.padding(.vertical, 6)
							.padding(.horizontal, 12)
							.background((selectedCategory?.id == cat.id) ? Color.accentColor.opacity(0.2) : Color(.secondarySystemBackground))
							.cornerRadius(8)
					}
				}
			}
			.padding(.horizontal)
		}
	}

	private var wallpaperGrid: some View {
		let items = Array(repeating: GridItem(.flexible(), spacing: 12), count: 2)
		return ScrollView {
			LazyVGrid(columns: items, spacing: 12) {
				ForEach(filteredByCategory(viewModel.filteredWallpapers)) { wp in
					NavigationLink(destination: WallpaperDetailView(wallpaper: wp)) {
						WallpaperCell(wallpaper: wp)
					}
				}
			}
			.padding()
		}
	}

	private func filteredByCategory(_ list: [Wallpaper]) -> [Wallpaper] {
		guard let cat = selectedCategory else { return list }
		return list.filter { $0.category == cat.name }
	}
}

struct WallpaperCell: View {
	let wallpaper: Wallpaper
	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			AsyncImage(url: wallpaper.thumbURL) { img in
				img.resizable()
					.aspectRatio(contentMode: .fill)
			} placeholder: {
				Rectangle().fill(Color(.secondarySystemFill))
			}
			.frame(height: 140)
			.clipped()
			Text(wallpaper.name).font(.subheadline).fontWeight(.semibold).lineLimit(1)
			Text(wallpaper.author).font(.caption).foregroundColor(.secondary).lineLimit(1)
		}
		.background(Color(.systemBackground))
		.cornerRadius(12)
		.shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
	}
}