import Foundation

enum APIError: Error {
	case invalidResponse
	case decodingFailed
}

final class WallpaperAPI {
	private let session: URLSession
	private let json: JSONStructure

	init(session: URLSession = .shared, json: JSONStructure = .default) {
		self.session = session
		self.json = json
	}

	func fetchAll() async throws -> (categories: [Category], wallpapers: [Wallpaper]) {
		let (data, response) = try await session.data(from: AppConfig.wallpaperJSONURL)
		guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
			throw APIError.invalidResponse
		}

		let raw = try JSONSerialization.jsonObject(with: data, options: [])
		guard let dict = raw as? [String: Any],
				let rawCategories = dict[json.category.arrayName] as? [Any],
				let rawWallpapers = dict[json.wallpaper.arrayName] as? [Any] else {
			throw APIError.decodingFailed
		}

		let categories: [Category] = rawCategories.compactMap { item in
			guard let map = item as? [String: Any], let name = map[json.category.name] as? String else { return nil }
			return Category(name: name)
		}

		let wallpapers: [Wallpaper] = rawWallpapers.compactMap { item in
			guard let map = item as? [String: Any],
					let name = map[json.wallpaper.name] as? String,
					let author = map[json.wallpaper.author] as? String,
					let urlString = map[json.wallpaper.url] as? String,
					let url = URL(string: urlString) else { return nil }

			let thumbURL: URL
			if let thumbKey = json.wallpaper.thumbUrl,
					let thumb = (map[thumbKey] as? String) ?? urlString,
					let t = URL(string: thumb) {
				thumbURL = t
			} else {
				thumbURL = url
			}

			let category = (map[json.wallpaper.category] as? String) ?? "Unknown"
			return Wallpaper(name: name, author: author, url: url, thumbURL: thumbURL, category: category)
		}

		return (categories, wallpapers)
	}
}