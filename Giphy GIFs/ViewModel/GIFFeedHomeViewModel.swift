//
//  GIFFeedHomeViewModel.swift
//  Giphy GIFs
//
//  Created by Haresh Ghatala on 2021/08/25.
//  Copyright © 2021 Haresh Ghatala. All rights reserved.
//

import Foundation
import UIKit

class GIFFeedHomeViewModel {
    
    private var gifData: Trending?
    
    private(set) var gifList: [GifData]
    
    var bindGifFeedToController: ((Bool) -> ()) = { wipeData in }
    var serviceFailur: (() -> ()) = { }
    var trendingOffset = 0
    var searchOffset = 0
    var isSearching = false
    
    init() {
        gifList = []
        fetchTrendingGifs(offset: trendingOffset)
    }
    
    // MARK: -  Network calls
    
    func fetchTrendingGifs(offset: Int) {
        print("Trending Offset - \(offset)")
        if offset != 0 && (offset) >= (gifData?.pagination?.totalCount ?? 0) {
            serviceFailurToView()
            return
        }
        ProgressHUD.show()
        Service.shared.fetchTrendingGif(offset: offset) { (result: Result<Trending, ServiceError>) in
            switch result {
                case .success(let trendingList):
                    self.handleSuccess(response: trendingList, wipeData: (offset == 0))
                    self.trendingOffset += self.gifData?.pagination?.count ?? 0
                    self.isSearching = false
                    
                case .failure(let error):
                    self.handleFailure(error: error)
            }
        }
    }
    
    func searchGifs(searchText: String, offset: Int) {
        print("Trending Offset - \(offset) ")
        if offset != 0 && (offset) >= (gifData?.pagination?.totalCount ?? 0) {
            serviceFailurToView()
            return
        }
        ProgressHUD.show()
        Service.shared.SearchGif(searchText: searchText, offset: offset) { (result: Result<Trending, ServiceError>) in
            switch result {
                case .success(let searchList):
                    self.handleSuccess(response: searchList, wipeData: (offset == 0))
                    self.searchOffset += self.gifData?.pagination?.count ?? 0
                    self.isSearching = true
                    
                case .failure(let error):
                    self.handleFailure(error: error)
            }
        }
    }
    
    private func handleSuccess(response: Trending, wipeData: Bool = false) {
        gifData = response
        guard let gifDataList = gifData?.data else {
            return
        }
        
        if wipeData {
            gifList.removeAll()
        }
        gifList.append(contentsOf: gifDataList)
        updateDataToView(wipeData: wipeData)
    }
    
    private func handleFailure(error: ServiceError) {
        serviceFailurToView()
        switch error {
        case .invalidEndpoint:
            ProgressHUD.show(errorMsgInvalidEndpoint, icon: .failed, interaction: true)
        case .invalidResponse, .decodeError:
            ProgressHUD.show(errorMsgInvalidResponse, icon: .failed, interaction: true)
        default:
            ProgressHUD.show(errorMsgUnknown, icon: .failed, interaction: true)
        }
    }
    
    
    // MARK: - Helper methods
    
    func favouriteButtonTapHandler(index: Int, images: [UIImage], isSelected: Bool) {
        let fileName = gifList[index].generateFileName()
        
        if isSelected {
            FileHandler.saveGif(fileName: fileName, images: images)
            gifList[index].isFavourite = true
        } else {
            FileHandler.removeGif(fileName: fileName)
            gifList[index].isFavourite = false
        }
    }
    
    
    // MARK: -  Private methods
    
    private func updateDataToView(wipeData: Bool) {
        DispatchQueue.main.async {
            self.bindGifFeedToController(wipeData)
        }
    }
    
    private func serviceFailurToView() {
        DispatchQueue.main.async {
            self.serviceFailur()
        }
    }
    
}
