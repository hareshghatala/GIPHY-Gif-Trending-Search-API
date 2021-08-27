//
//  FavouritesViewController.swift
//  Giphy GIFs
//
//  Created by Haresh Ghatala on 2021/08/24.
//  Copyright © 2021 Haresh Ghatala. All rights reserved.
//

import UIKit

class FavouritesViewController: UIViewController {
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var nothingFoundLabel: UILabel!
    
    private var cellSize: Int = defaultCellWidth
    
    let viewModel = FavouritesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.bindFavouriteGifToController = {
            self.bindDataToController()
        }
        
        viewModel.removeCell = { indexPath in
            self.removeCellHandler(indexPath: indexPath)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        calculateCellSize(columns: 2)
        viewModel.fetchFavouriteGifs()
    }

    private func calculateCellSize(columns: Int = 2) {
        let columns = columnSpace * (columns + 1)
        cellSize = (Int(view.bounds.width) - columns) / 2
    }
    
    private func bindDataToController() {
        nothingFoundLabel.isHidden = !viewModel.gifList.isEmpty
        mainCollectionView.reloadData()
    }
}

// MARK: - UICollectionView DataSource & Delegate methods

extension FavouritesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.gifList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: favouriteCellId, for: indexPath) as! FavouriteCollectionViewCell
        
        cell.delegate = self
        cell.index = indexPath.item
        cell.gifImageView.startGif(with: .localPath(viewModel.gifList[indexPath.item]))
        
        return cell
    }
}

extension FavouritesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? FavouriteCollectionViewCell)?.gifImageView.resumeGif()
        ProgressHUD.dismiss()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? FavouriteCollectionViewCell)?.gifImageView.pauseGif()
    }
}

extension FavouritesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize, height: cellSize)
    }
}

// MARK: - FavouriteCollectionViewCell Delegate methods

extension FavouritesViewController: FavouriteCollectionViewCellDelegate {
    
    func unfavouriteButtonTap(index: Int) {
        viewModel.unfavouriteButtonTapHandler(index: index)
    }
    
    private func removeCellHandler(indexPath: IndexPath) {
        nothingFoundLabel.isHidden = !viewModel.gifList.isEmpty
        mainCollectionView.deleteItems(at: [indexPath])
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.mainCollectionView.reloadData()
        }
    }
}
