import Foundation

struct AppConfig {
	static let wallpaperJSONURL: URL = URL(string: "https://raw.githubusercontent.com/sumitkolhe/Resources/master/wallpaper.json")!
}

struct JSONStructure {
	struct CategoryKeys {
		let arrayName: String
		let name: String
	}

	struct WallpaperKeys {
		let arrayName: String
		let name: String
		let author: String
		let url: String
		let thumbUrl: String?
		let category: String
	}

	let category: CategoryKeys
	let wallpaper: WallpaperKeys

	static let `default` = JSONStructure(
		category: .init(arrayName: "Categories", name: "name"),
		wallpaper: .init(
			arrayName: "Wallpapers",
			name: "name",
			author: "author",
			url: "url",
			thumbUrl: "thumbUrl",
			category: "category"
		)
	)
}