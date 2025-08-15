import Foundation
import Combine

@MainActor
final class WallpapersViewModel: ObservableObject {
	@Published private(set) var categories: [Category] = []
	@Published private(set) var wallpapers: [Wallpaper] = []
	@Published var query: String = ""
	@Published var isLoading: Bool = false
	@Published var error: String?

	private let api: WallpaperAPI

	init(api: WallpaperAPI = WallpaperAPI()) {
		self.api = api
	}

	func load() async {
		isLoading = true
		defer { isLoading = false }
		do {
			let result = try await api.fetchAll()
			self.categories = result.categories
			self.wallpapers = result.wallpapers
			self.error = nil
		} catch {
			self.error = "Unable to fetch data from server"
		}
	}

	var filteredWallpapers: [Wallpaper] {
		let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
		guard !q.isEmpty else { return wallpapers }
		return wallpapers.filter { $0.name.localizedCaseInsensitiveContains(q) || $0.author.localizedCaseInsensitiveContains(q) }
	}
}