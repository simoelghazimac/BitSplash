# BitSplashiOS

SwiftUI iOS sample mirroring the Android BitSplash features: categories, wallpaper grid, search, detail with save/share.

- Requires Xcode 15+, iOS 16+
- No external dependencies

Getting started:
1. Open `ios/BitSplashiOS` in Xcode as a Swift package app project, or create a new iOS App and drop these files in.
2. Ensure the target has `Photos` framework capability if saving images is needed.
3. Run on simulator or device.

Config:
- `Config/AppConfig.wallpaperJSONURL` points to the same JSON as Android.
- `JSONStructure.default` mirrors `JsonStructure` keys.