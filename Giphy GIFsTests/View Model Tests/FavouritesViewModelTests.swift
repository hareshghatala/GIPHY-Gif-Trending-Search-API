//
//  FavouritesViewModelTests.swift
//  Giphy GIFsTests
//
//  Created by Hareshbhai Ghatala on 2021/08/27.
//

import XCTest
@testable import Giphy_GIFs

class FavouritesViewModelTests: XCTestCase {

    func testViewModelInitialsCorrectly() throws {
        let obj = FavouritesViewModel()
        XCTAssertNotNil(obj)
    }
    
    func testFetchFavouriteGifsRetrievesDataCorrectly() throws {
        let obj = FavouritesViewModel()
        obj.fetchFavouriteGifs()
        
        XCTAssertEqual(obj.gifList.count, 0)
    }
    
    func testUnfavouriteButtonTapHandlerRemovesImg() throws {
        let obj = FavouritesViewModel()
        obj.fetchFavouriteGifs()
        obj.unfavouriteButtonTapHandler(index: 0)
        
        XCTAssertEqual(obj.gifList.count, 0)
    }
    
    func testUnfavouriteButtonTapHandlerWithOverIndex() throws {
        let obj = FavouritesViewModel()
        obj.fetchFavouriteGifs()
        obj.unfavouriteButtonTapHandler(index: 2)
        
        XCTAssertEqual(obj.gifList.count, 0)
    }
    
}
