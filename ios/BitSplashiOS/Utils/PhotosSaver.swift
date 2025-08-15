import Foundation
import Photos

enum PhotosSaverError: Error { case unauthorized, saveFailed }

enum PhotosSaver {
	static func saveImageDataToPhotos(_ data: Data) async throws {
		let status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
		guard status == .authorized || status == .limited else { throw PhotosSaverError.unauthorized }
		try await PHPhotoLibrary.shared().performChanges {
			let request = PHAssetCreationRequest.forAsset()
			request.addResource(with: .photo, data: data, options: nil)
		}
	}
}