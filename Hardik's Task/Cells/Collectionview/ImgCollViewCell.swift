//
//  ImgCollViewCell.swift
//  FlickerDemoTask
//
//  Created by kns on 20/03/25.
//

import UIKit

class ImgCollViewCell: UICollectionViewCell {

    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    
    var idxPath:IndexPath?
    private var task: Task<Void, Never>?
    private var currentImageUrl: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgVw.image = nil
        task?.cancel()
        currentImageUrl = nil
        
    }

    func loadImage(obj: ImageDataModel) {
        let url = obj.urls.regular
        currentImageUrl = url
        
        // Cancel previous task if needed
        task?.cancel()
        
        // Reset UI
        imgVw.image = UIImage(systemName: "photo")
        imgVw.contentMode = .scaleAspectFit
        actIndicator.startAnimating()
        
        // Begin new image load task
        task = Task { [weak self] in
            guard let self else { return }

            let image = await ImageLoader().fetchImage(from: url)

            await MainActor.run {
                // Only apply if image is still relevant for this cell
                guard self.currentImageUrl == url else { return }
                self.imgVw.contentMode = .scaleAspectFill
                self.imgVw.image = image
                self.actIndicator.stopAnimating()
            }
        }
    }


}

