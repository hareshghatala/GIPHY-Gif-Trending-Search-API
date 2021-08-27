//
//  GIFFeedHomeViewController.swift
//  Giphy GIFs
//
//  Created by Haresh Ghatala on 2021/08/24.
//  Copyright © 2021 Haresh Ghatala. All rights reserved.
//

import UIKit
import JellyGif
import MobileCoreServices

class GIFFeedHomeViewController: UIViewController {

    @IBOutlet weak var gifSearchBar: UISearchBar!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var footerLoaderView: UIView!
    @IBOutlet weak var noResultLabel: UILabel!
    
    private var animators: [IndexPath: JellyGifAnimator] = [:]
    
    let viewModel = GIFFeedHomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        isFooterLoaderViewDisply(show: false)
        
        viewModel.bindGifFeedToController = { wipeData in
            self.dataBindingHandler(wipeData: wipeData)
        }
        viewModel.serviceFailur = {
            self.isFooterLoaderViewDisply(show: false)
        }
    }
    
    private func dataBindingHandler(wipeData: Bool) {
        if wipeData {
            animators.removeAll()
            if !mainTableView.visibleCells.isEmpty {
                mainTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
            }
        }
        noResultLabel.isHidden = !viewModel.gifList.isEmpty
        isFooterLoaderViewDisply(show: false)
        mainTableView.reloadData()
        
        if viewModel.gifList.isEmpty {
            ProgressHUD.dismiss()
        }
    }
    
    private func isFooterLoaderViewDisply(show: Bool) {
        mainTableView.tableFooterView = show ? footerLoaderView : UIView()
    }
}

// MARK: - TableView DataSource & Delegate methods

extension GIFFeedHomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.gifList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: gifFeedCellId, for: indexPath) as! GIFFeedTableViewCell
        
        cell.delegate = self
        cell.index = indexPath.row
        cell.favouriteButton.isSelected = viewModel.gifList[indexPath.row].isFavourite ?? false
        
        if let gifUrl = viewModel.gifList[indexPath.row].gifUrl(),
           animators[indexPath] == nil {
            let animator = JellyGifAnimator(imageInfo: .localPath(gifUrl))
            animators[indexPath] = animator
        }
        animators[indexPath]?.delegate = self
        
        if animators[indexPath]?.isReady == false {
            animators[indexPath]?.prepareAnimation()
        } else {
            animators[indexPath]?.startAnimation()
        }
        
        return cell
    }
    
}

extension GIFFeedHomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(gifFeedCellHeight)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if animators[indexPath]?.isReady == true {
            ProgressHUD.dismiss()
            animators[indexPath]?.startAnimation()
        } else {
            animators[indexPath]?.prepareAnimation()
        }
        
        if indexPath.row == viewModel.gifList.count - 1 {
            isFooterLoaderViewDisply(show: true)
            if viewModel.isSearching, let text = gifSearchBar.text, !text.isEmpty {
                viewModel.searchGifs(searchText: text, offset: viewModel.searchOffset)
            } else {
                viewModel.fetchTrendingGifs(offset: viewModel.trendingOffset)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        animators[indexPath]?.pauseAnimation()
        animators[indexPath]?.stopPreparingAnimation()
    }
    
}

// MARK: - GIFFeedTableViewCell Delegate methods

extension GIFFeedHomeViewController: GIFFeedTableViewCellDelegate {
    
    func favouriteButtonTap(index: Int, isSelected: Bool) {
        let indexPath = IndexPath(row: index, section: 0)
        viewModel.favouriteButtonTapHandler(index: index,
                                            images: animators[indexPath]?.images ?? [],
                                            isSelected: isSelected)
    }
    
}

// MARK: - JellyGifAnimator Delegate methods

extension GIFFeedHomeViewController: JellyGifAnimatorDelegate {
    
    func gifAnimatorIsReady(_ sender: JellyGifAnimator) {
        ProgressHUD.dismiss()
        sender.startAnimation()
    }
    
    func imageViewForAnimator(_ sender: JellyGifAnimator) -> UIImageView? {
        guard let indexPathsForVisibleRows = mainTableView.indexPathsForVisibleRows else {
            return nil
        }
        
        for indexPath in indexPathsForVisibleRows {
            if animators[indexPath] === sender {
                return (mainTableView.cellForRow(at: indexPath) as? GIFFeedTableViewCell)?.gifImageView
            }
        }
        return nil
    }
    
}

// MARK: - SearchBar Delegate methods

extension GIFFeedHomeViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        self.view.endEditing(true)
        performSearch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        self.view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        self.view.endEditing(true)
    }
    
    private func performSearch() {
        guard let text = gifSearchBar.text, !text.isEmpty else {
            viewModel.trendingOffset = 0
            viewModel.fetchTrendingGifs(offset: viewModel.trendingOffset)
            return
        }
        viewModel.searchOffset = 0
        viewModel.searchGifs(searchText: text, offset: viewModel.searchOffset)
    }
}
