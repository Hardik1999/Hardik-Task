//
//  CacheDataManager.swift
//  Hardik's Task
//
//  Created by Hardik D on 23/04/25.
//

import UIKit

final class CacheManager {
    static let shared = CacheManager()

    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    private let ioQueue = DispatchQueue(label: "com.task.CacheManagerIO", qos: .utility)

    private init() {
        // Set the directory where disk-cached images will be saved
        cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }

    // Save image to memory and disk cache
    func saveImage(_ image: UIImage, for url: String) async {
        let cacheKey = url as NSString
        memoryCache.setObject(image, forKey: cacheKey)

        let fileURL = cacheDirectory.appendingPathComponent((cacheKey as String).managedFileName())
        
        // Perform disk write in background
        await withCheckedContinuation { continuation in
            ioQueue.async {
                if let data = image.pngData() {
                    try? data.write(to: fileURL, options: [.atomic])
                }
                continuation.resume()
            }
        }
    }

    // Load image from memory if available, else from disk
    func loadImage(for url: String) async -> UIImage? {
        let cacheKeyString = url

        // Check memory cache first
        if let memoryImage = memoryCache.object(forKey: cacheKeyString as NSString) {
            debugPrint("Image from Memory Cache")
            return memoryImage
        }

        let fileURL = cacheDirectory.appendingPathComponent(cacheKeyString.managedFileName())

        // Load from disk in background
        return await withCheckedContinuation { continuation in
            ioQueue.async {
                let nsKey = cacheKeyString as NSString // convert inside the closure

                guard let data = try? Data(contentsOf: fileURL),
                      let diskImage = UIImage(data: data) else {
                    continuation.resume(returning: nil)
                    return
                }

                debugPrint("Image from Disk Cache")
                self.memoryCache.setObject(diskImage, forKey: nsKey)
                continuation.resume(returning: diskImage)
            }
        }
    }

}
