//
//  ImageLoaderManager.swift
//  Hardik's Task
//
//  Created by Hardik D on 23/04/25.
//

import UIKit

final class ImageLoader {
    private let cacheManager = CacheManager.shared

    func fetchImage(from urlString: String) async -> UIImage? {
        // 1. Check memory/disk cache first
        if let cachedImage = await cacheManager.loadImage(for: urlString) {
            debugPrint("Loaded image from cache")
            return cachedImage
        }

        // 2. Fetch from network
        guard let url = URL(string: urlString) else {
            debugPrint("Invalid URL: \(urlString)")
            return nil
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Optional: Validate response status
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                debugPrint("HTTP Error: \(httpResponse.statusCode)")
                return nil
            }

            guard let image = UIImage(data: data) else {
                debugPrint("Failed to decode image data")
                return nil
            }

            await cacheManager.saveImage(image, for: urlString)
            debugPrint("Loaded image from network and cached it")
            return image

        } catch {
            debugPrint("Network error while downloading image: \(error.localizedDescription)")
            return nil
        }
    }
}

