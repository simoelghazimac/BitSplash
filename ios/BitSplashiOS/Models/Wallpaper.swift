import Foundation

struct Wallpaper: Identifiable, Equatable, Codable {
	let id: UUID
	let name: String
	let author: String
	let url: URL
	let thumbURL: URL
	let category: String
	let addedOn: String?
	var color: Int?
	var mimeType: String?
	var size: Int?
	var isFavorite: Bool = false
	var width: Int?
	var height: Int?

	init(id: UUID = UUID(), name: String, author: String, url: URL, thumbURL: URL, category: String, addedOn: String? = nil) {
		self.id = id
		self.name = name
		self.author = author
		self.url = url
		self.thumbURL = thumbURL
		self.category = category
		self.addedOn = addedOn
	}
}