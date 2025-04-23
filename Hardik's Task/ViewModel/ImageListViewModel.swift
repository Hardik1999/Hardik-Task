//
//  ImageListViewModel.swift
//  Hardik's Task
//
//  Created by Hardik D on 23/04/25.
//

import UIKit

class ImageListViewModel {
    private let apiService = APIService()
    var images: [ImageDataModel] = []
    var onImagesUpdated: (() -> Void)?
    var isLoading: ((Bool) -> Void)?
    var page = 1
    var perPage = 20
    
    func fetchImages() {
        
        Task { [weak self] in
            guard let self else { return }

            await MainActor.run {
                self.isLoading?(true)
            }

            do {
                let fetchedImages = try await apiService.fetchImages(page: self.page, perPage: self.perPage)
                self.page += 1

                await MainActor.run {
                    self.images.append(contentsOf: fetchedImages)
                    self.onImagesUpdated?()
                }

            } catch {
                await MainActor.run {
                    self.images = []
                    self.onImagesUpdated?()
                }
            }

            await MainActor.run {
                self.isLoading?(false)
            }
        }

    }
}
