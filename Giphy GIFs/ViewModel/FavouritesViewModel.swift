//
//  FavouritesViewModel.swift
//  Giphy GIFs
//
//  Created by Haresh Ghatala on 2021/08/25.
//  Copyright © 2021 Haresh Ghatala. All rights reserved.
//

import Foundation

class FavouritesViewModel {
    
    private(set) var gifList: [URL]
    
    var bindFavouriteGifToController: (() -> ()) = { }
    var removeCell: ((IndexPath) -> ()) = { indexPath in }
    
    init() {
        gifList = []
    }
    
    // MARK: - Data fetcher
    
    func fetchFavouriteGifs() {
        ProgressHUD.show()
        
        gifList = FileHandler.getGifListFromDocumentsDirectory()
        if gifList.isEmpty {
            ProgressHUD.show(infoMsgNoGifFound, icon: .exclamation, interaction: false)
        }
        
        DispatchQueue.main.async {
            self.bindFavouriteGifToController()
        }
    }
    
    // MARK: - Helper methods
    
    func unfavouriteButtonTapHandler(index: Int) {
        if index < gifList.count {
            let urlPath = gifList.remove(at: index)
            removeCell(IndexPath(item: index, section: 0))
            FileHandler.removeGif(filePath: urlPath)
        } else {
            ProgressHUD.show(errorMsgUnknown, icon: .failed, interaction: true)
        }
    }
}
