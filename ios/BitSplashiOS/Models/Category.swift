import Foundation

struct Category: Identifiable, Equatable, Codable {
	let id: UUID
	let name: String
	var thumbURL: URL?
	var isSelected: Bool = false
	var isMuzeiSelected: Bool = false
	var count: Int = 0
	var color: Int?

	init(id: UUID = UUID(), name: String) {
		self.id = id
		self.name = name
	}
}