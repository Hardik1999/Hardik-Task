//
//  ViewController.swift
//  Hardik's Task
//
//  Created by Hardik D on 23/04/25.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - IBoutlets
    @IBOutlet weak var clvImg: UICollectionView!
    
    //MARK: - Variables
    var viewModel = ImageListViewModel()
    var arrImgData: [ImageDataModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupBindings()
        viewModel.fetchImages()
    }

}

// MARK: All Methods and functions
extension ViewController {
    
    func setupCollectionView() {
        clvImg.dataSource = self
        clvImg.delegate = self
        clvImg.register(UINib(nibName: "ImgCollViewCell", bundle: nil), forCellWithReuseIdentifier: "ImgCollViewCell")
    }

    func setupBindings() {
        viewModel.isLoading = { [weak self] isLoading in
            DispatchQueue.main.async {
                isLoading ? self?.showLoader() : self?.hideLoader()
            }
        }
        
        viewModel.onImagesUpdated = { [weak self] in
            updateData(imgData: self?.viewModel.images)
        }
        
        func updateData(imgData: [ImageDataModel]?) {
            let newData = imgData ?? []
            let oldCount = arrImgData.count
            let newCount = newData.count

            // No new items, reload all
            guard newCount > oldCount else {
                arrImgData = newData
                clvImg.reloadData()
                return
            }

            // Get only new items
            let newItems = Array(newData[oldCount..<newCount])

            // Update data source
            arrImgData = newData

            // Animate new items only
            let indexPaths = (oldCount..<newCount).map { IndexPath(item: $0, section: 0) }
            clvImg.performBatchUpdates {
                clvImg.insertItems(at: indexPaths)
            }
        }

    }
}


// MARK: Collection view delegate and datasource methods
extension ViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImgData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImgCollViewCell", for: indexPath) as? ImgCollViewCell else {
            return UICollectionViewCell()
        }
        cell.loadImage(obj: arrImgData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2, height: collectionView.bounds.width / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let lastItemIndex = arrImgData.count - 4
        if indexPath.item == lastItemIndex {
            viewModel.fetchImages()
        }
    }

}
