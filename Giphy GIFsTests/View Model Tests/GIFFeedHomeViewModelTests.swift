//
//  GIFFeedHomeViewModelTests.swift
//  Giphy GIFsTests
//
//  Created by Haresh Ghatala on 2021/08/27.
//  Copyright © 2021 Haresh Ghatala. All rights reserved.
//

import XCTest
@testable import Giphy_GIFs

class GIFFeedHomeViewModelTests: XCTestCase {
    
    var mockService: MockService!
    
    var mockPagination: Pagination!
    var mockImgDetails: ImageDetails!
    var mockGifImage: GifImage!
    var mockGifImages: [GifData]!
    var mockData: Trending!
    
    override func setUpWithError() throws {
        mockService = MockService.mockShared
        
        mockPagination = Pagination(totalCount: 1500, count: 5, offset: 0)
        mockImgDetails = ImageDetails(height: "300", width: "300", size: "123456", url: "https://mockurl.com/img.gif")
        mockGifImage = GifImage(original: nil,
                                downsizedMedium: nil,
                                fixedHeightDownsampled: mockImgDetails,
                                fixedWidthDownsampled: mockImgDetails)
        mockGifImages = [GifData(id: "Gif-ID-1", title: "Gif-Title-1", images: mockGifImage),
                         GifData(id: "Gif-ID-2", title: "Gif-Title-2", images: mockGifImage),
                         GifData(id: "Gif-ID-3", title: "Gif-Title-3", images: mockGifImage),
                         GifData(id: "Gif-ID-4", title: "Gif-Title-4", images: mockGifImage),
                         GifData(id: "Gif-ID-5", title: "Gif-Title-5", images: mockGifImage)]
        
        mockData = Trending(data: mockGifImages, pagination: mockPagination)
    }
    
    override func tearDownWithError() throws {
        mockService = nil
        mockPagination = nil
        mockImgDetails = nil
        mockGifImage = nil
        mockGifImages = nil
        mockData = nil
    }
    
    func testViewModelInitialsCorrectly() throws {
        mockService.isfailur = true
        mockService.mockServiceError = ServiceError.noData
        
        let obj = GIFFeedHomeViewModel()
        obj.serviceSession = mockService
        XCTAssertNotNil(obj)
    }
    
    func testFetchTrendingGifsRetrievesDataCorrectly() throws {
        mockService.isfailur = false
        mockService.mockResponse = mockData
        
        let obj = GIFFeedHomeViewModel()
        obj.serviceSession = mockService
        
        obj.fetchTrendingGifs(offset: 0)
        
        XCTAssertEqual(obj.gifList, mockGifImages)
        XCTAssertEqual(obj.gifList.count, 5)
        XCTAssertEqual(obj.trendingOffset, 5)
        XCTAssertFalse(obj.isSearching)
    }
    
    func testFetchTrendingGifsPaginationHandledCorrectly() throws {
        mockService.isfailur = false
        mockService.mockResponse = mockData
        
        let obj = GIFFeedHomeViewModel()
        obj.serviceSession = mockService
        
        obj.fetchTrendingGifs(offset: 0)
        obj.fetchTrendingGifs(offset: 5)
        
        XCTAssertEqual(obj.gifList.count, 10)
        XCTAssertEqual(obj.trendingOffset, 10)
    }
    
    func testFetchTrendingGifsOverPaginationHandledCorrectly() throws {
        mockService.isfailur = false
        mockService.mockResponse = mockData
        
        let obj = GIFFeedHomeViewModel()
        obj.serviceSession = mockService
        
        obj.fetchTrendingGifs(offset: 0)
        obj.fetchTrendingGifs(offset: 5)
        
        XCTAssertEqual(obj.gifList.count, 10)
        XCTAssertEqual(obj.trendingOffset, 10)
        
        obj.fetchTrendingGifs(offset: 1501)
        XCTAssertEqual(obj.gifList.count, 10)
        XCTAssertEqual(obj.trendingOffset, 10)
    }
    
    func testFetchTrendingGifsFailureHandledCorrectly() throws {
        mockService.isfailur = true
        mockService.mockServiceError = ServiceError.noData
        
        let obj = GIFFeedHomeViewModel()
        obj.serviceSession = mockService
        
        obj.fetchTrendingGifs(offset: 0)
        
        XCTAssertTrue(obj.gifList.isEmpty)
        XCTAssertEqual(obj.trendingOffset, 0)
    }
    
    func testSearchGifsRetrievesDataCorrectly() throws {
        mockService.isfailur = false
        mockService.mockResponse = mockData
        
        let obj = GIFFeedHomeViewModel()
        obj.serviceSession = mockService
        
        obj.searchGifs(searchText: "sample", offset: 0)
        
        XCTAssertEqual(obj.gifList, mockGifImages)
        XCTAssertEqual(obj.gifList.count, 5)
        XCTAssertEqual(obj.searchOffset, 5)
        XCTAssertTrue(obj.isSearching)
    }
    
    func testSearchGifsPaginationHandledCorrectly() throws {
        mockService.isfailur = false
        mockService.mockResponse = mockData
        
        let obj = GIFFeedHomeViewModel()
        obj.serviceSession = mockService
        
        obj.searchGifs(searchText: "sample", offset: 0)
        obj.searchGifs(searchText: "sample", offset: 5)
        
        XCTAssertEqual(obj.gifList.count, 10)
        XCTAssertEqual(obj.searchOffset, 10)
    }
    
    func testSearchGifsOverPaginationHandledCorrectly() throws {
        mockService.isfailur = false
        mockService.mockResponse = mockData
        
        let obj = GIFFeedHomeViewModel()
        obj.serviceSession = mockService
        
        obj.searchGifs(searchText: "sample", offset: 0)
        obj.searchGifs(searchText: "sample", offset: 5)
        
        XCTAssertEqual(obj.gifList.count, 10)
        XCTAssertEqual(obj.searchOffset, 10)
        
        obj.searchGifs(searchText: "sample", offset: 1501)
        XCTAssertEqual(obj.gifList.count, 10)
        XCTAssertEqual(obj.searchOffset, 10)
    }
    
    func testSearchGifsFailureHandledCorrectly() throws {
        mockService.isfailur = true
        mockService.mockServiceError = ServiceError.invalidResponse
        
        let obj = GIFFeedHomeViewModel()
        obj.serviceSession = mockService
        
        obj.searchGifs(searchText: "sample", offset: 0)
        
        XCTAssertTrue(obj.gifList.isEmpty)
        XCTAssertEqual(obj.trendingOffset, 0)
    }
    
    func testFavouriteButtonTapHandlerForSelected() throws {
        mockService.isfailur = false
        mockService.mockResponse = mockData
        
        let obj = GIFFeedHomeViewModel()
        obj.serviceSession = mockService
        obj.fetchTrendingGifs(offset: 0)
        
        obj.favouriteButtonTapHandler(index: 3, images: [], isSelected: true)
        
        XCTAssertEqual(obj.gifList.count, 5)
        XCTAssertTrue(obj.gifList[3].isFavourite!)
    }
    
    func testFavouriteButtonTapHandlerForUnselected() throws {
        mockService.isfailur = false
        mockService.mockResponse = mockData
        
        let obj = GIFFeedHomeViewModel()
        obj.serviceSession = mockService
        obj.fetchTrendingGifs(offset: 0)
        
        obj.favouriteButtonTapHandler(index: 4, images: [], isSelected: false)
        
        XCTAssertEqual(obj.gifList.count, 5)
        XCTAssertFalse(obj.gifList[4].isFavourite!)
    }
    
}
