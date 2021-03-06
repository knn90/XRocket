//
//  LaunchDetailsViewControllerTests.swift
//  XRocketiOSTests
//
//  Created by Khoi Nguyen on 23/4/21.
//

import XCTest
import XRocket
import UIKit
import XRocketiOS

class LaunchDetailsViewControllerTests: XCTestCase {
    
    func test_loadView_renderingImageCells() {
        let url0 = URL(string: "http://url-0.com")!
        let url1 = URL(string: "http://url-1.com")!
        let url2 = URL(string: "http://url-2.com")!
        let url3 = URL(string: "http://url-3.com")!
        let launch = LaunchFactory.any( urls: [url0, url1, url2, url3])
        let (sut, _) = makeSUT(launch: launch)
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.numberOfRenderedCells, 4)
    }
    
    func test_loadView_requestsImageFromURL() {
        let url0 = URL(string: "http://url-0.com")!
        let url1 = URL(string: "http://url-1.com")!
        let url2 = URL(string: "http://url-2.com")!
        let launch = LaunchFactory.any(urls: [url0, url1, url2])
        let (sut, loader) = makeSUT(launch: launch)
        
        sut.loadViewIfNeeded()
        
        let cell0 = sut.simulateCellVisible(at: 0)
        XCTAssertEqual(loader.requestedImageURLs, [url0])
        XCTAssertNil(cell0.renderedImage)
        
        let cell1 = sut.simulateCellVisible(at: 1)
        XCTAssertEqual(loader.requestedImageURLs, [url0, url1])
        XCTAssertNil(cell1.renderedImage)
    }
    
    func test_loadImage_showsLoadingIndicatorWhileLoadingImage() {
        let url0 = URL(string: "http://url-0.com")!
        let url1 = URL(string: "http://url-1.com")!
        let launch = LaunchFactory.any(urls: [url0, url1])
        let (sut, loader) = makeSUT(launch: launch)
        sut.loadViewIfNeeded()
        
        let cell0 = sut.simulateCellVisible(at: 0)
        let cell1 = sut.simulateCellVisible(at: 1)
        XCTAssertEqual(cell0.isShowingLoadingIndicator, true)
        XCTAssertEqual(cell1.isShowingLoadingIndicator, true)
        
        loader.completeImageLoading(with: UIImage.make(withColor: .red).pngData()!, at: 0)
        XCTAssertEqual(cell0.isShowingLoadingIndicator, false)
        XCTAssertEqual(cell1.isShowingLoadingIndicator, true)
        
        loader.completeImageLoading(with: anyNSError(), at: 1)
        XCTAssertEqual(cell0.isShowingLoadingIndicator, false)
        XCTAssertEqual(cell1.isShowingLoadingIndicator, false)
    }
    
    func test_loadImage_rendersLoadedImage() {
        let url0 = URL(string: "http://url-0.com")!
        let url1 = URL(string: "http://url-1.com")!
        let launch = LaunchFactory.any(urls: [url0, url1])
        let (sut, loader) = makeSUT(launch: launch)
        sut.loadViewIfNeeded()
        
        let cell0 = sut.simulateCellVisible(at: 0)
        let cell1 = sut.simulateCellVisible(at: 1)
        XCTAssertEqual(cell0.renderedImage, nil)
        XCTAssertEqual(cell0.renderedImage, nil)
        
        let imageData0 = UIImage.make(withColor: .red).pngData()!
        loader.completeImageLoading(with: imageData0, at: 0)
        XCTAssertEqual(cell0.renderedImage, imageData0)
        XCTAssertEqual(cell1.renderedImage, nil)
        
        let imageData1 = UIImage.make(withColor: .blue).pngData()!
        loader.completeImageLoading(with: imageData1, at: 1)
        XCTAssertEqual(cell0.renderedImage, imageData0)
        XCTAssertEqual(cell1.renderedImage, imageData1)
    }
    
    func test_loadImage_showsRetryButtonOnLoadImageFailed() {
        let url0 = URL(string: "http://url-0.com")!
        let url1 = URL(string: "http://url-1.com")!
        let launch = LaunchFactory.any(urls: [url0, url1])
        let (sut, loader) = makeSUT(launch: launch)
        sut.loadViewIfNeeded()
        
        let cell0 = sut.simulateCellVisible(at: 0)
        let cell1 = sut.simulateCellVisible(at: 1)
        XCTAssertEqual(cell0.isShowingRetryButton, false)
        XCTAssertEqual(cell0.isShowingRetryButton, false)
        
        loader.completeImageLoading(with: anyNSError(), at: 0)
        XCTAssertEqual(cell0.isShowingRetryButton, true)
        XCTAssertEqual(cell1.isShowingRetryButton, false)
        
        loader.completeImageLoading(with: anyNSError(), at: 1)
        XCTAssertEqual(cell0.isShowingRetryButton, true)
        XCTAssertEqual(cell1.isShowingRetryButton, true)
    }
    
    func test_onRetry_requestsImageDataFromURL() {
        let url0 = URL(string: "http://url-0.com")!
        let url1 = URL(string: "http://url-1.com")!
        let launch = LaunchFactory.any(urls: [url0, url1])
        let (sut, loader) = makeSUT(launch: launch)
        sut.loadViewIfNeeded()
        
        let cell0 = sut.simulateCellVisible(at: 0)
        let cell1 = sut.simulateCellVisible(at: 1)
        loader.completeImageLoading(with: anyNSError(), at: 0)
        loader.completeImageLoading(with: anyNSError(), at: 1)
        
        XCTAssertEqual(loader.requestedImageURLs, [url0, url1])
        
        cell0.simulateRetryButtonTap()
        XCTAssertEqual(loader.requestedImageURLs, [url0, url1, url0])
        
        cell1.simulateRetryButtonTap()
        XCTAssertEqual(loader.requestedImageURLs, [url0, url1, url0, url1])
    }
    
    func test_imageCell_preloadsImageWhenCellIsNearVisible() {
        let url0 = URL(string: "http://url-0.com")!
        let url1 = URL(string: "http://url-1.com")!
        let launch = LaunchFactory.any(urls: [url0, url1])
        let (sut, loader) = makeSUT(launch: launch)
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.requestedImageURLs, [])
        
        sut.simulateCellNearVisible(at: 0)
        XCTAssertEqual(loader.requestedImageURLs, [url0])
        
        sut.simulateCellNearVisible(at: 1)
        XCTAssertEqual(loader.requestedImageURLs, [url0, url1])
    }
    
    func test_imageCell_cancelImageRequestWhenCellIsNotNearVisibleAnymore() {
        let url0 = URL(string: "http://url-0.com")!
        let url1 = URL(string: "http://url-1.com")!
        let launch = LaunchFactory.any(urls: [url0, url1])
        let (sut, loader) = makeSUT(launch: launch)
        sut.loadViewIfNeeded()
        
        sut.simulateLauncCellIsNotNearVisible(at: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [url0])
        
        sut.simulateLauncCellIsNotNearVisible(at: 1)
        XCTAssertEqual(loader.cancelledImageURLs, [url0, url1])
    }
    
    func test_imageCell_doesNotRenderLoadedImageWhenNotVisibleAnyMore() {
        let url0 = URL(string: "http:url-0.com")!
        let launch = LaunchFactory.any(urls: [url0])
        let (sut, loader) = makeSUT(launch: launch)
        sut.loadViewIfNeeded()
        
        let cell = sut.simulateCellNotVisible(at: 0)
        loader.completeImageLoading(with: UIImage.make(withColor: .red).pngData()!, at: 0)
        
        XCTAssertNil(cell?.renderedImage)
    }
    
    func test_loadImageCompletion_dispatchFromBackgroundToMainThread() {
        let url0 = URL(string: "http:url-0.com")!
        let launch = LaunchFactory.any(urls: [url0])
        let (sut, loader) = makeSUT(launch: launch)
        sut.loadViewIfNeeded()
        
        _ = sut.simulateCellVisible(at: 0)
        
        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeImageLoading(with: UIImage.make(withColor: .blue).pngData()!, at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_populateLaunchDetails_rendersInfoCell() {
        let date = LaunchDateFactory.date3()
        let launch = LaunchFactory.any(id: "", name: "name", flightNumber: 1, success: true, dateUTC: date.0, details: "details")
        let (sut, _) = makeSUT(launch: launch)
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 1)
        let cell = sut.getInfoCell(at: 0)
        XCTAssertEqual(cell.name, launch.name)
        XCTAssertEqual(cell.launchDate, date.1)
        XCTAssertEqual(cell.status, "Success")
        XCTAssertEqual(cell.rocketName, launch.rocket.name)
        XCTAssertEqual(cell.descriptionText, launch.details)
    }
    
    // MARK: - Helpers
    private func makeSUT(launch: Launch = LaunchFactory.any(), file: StaticString = #file, line: UInt = #line) -> (LaunchDetailsViewController, LoaderSpy) {
        let loader = LoaderSpy()
        let sut = LaunchDetailsUIComposer.composeWith(imageLoader: loader, launch: launch)
        
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(loader, file: file, line: line)
        
        return (sut, loader)
    }
}

extension LaunchDetailsViewController {
    var numberOfRenderedCells: Int {
        return collectionView.numberOfItems(inSection: launchImageSection)
    }
    
    func simulateCellVisible(at index: Int) -> LaunchDetailsImageCell {
        return getCell(at: index) as! LaunchDetailsImageCell
    }
    
    func simulateCellNearVisible(at index: Int) {
        let ds = collectionView.prefetchDataSource
        let indexPath = IndexPath(item: index, section: launchImageSection)
        ds?.collectionView(collectionView, prefetchItemsAt: [indexPath])
    }
    
    func simulateLauncCellIsNotNearVisible(at index: Int) {
        simulateCellNearVisible(at: index)
        
        let ds = collectionView.prefetchDataSource
        let indexPath = IndexPath(row: index, section: launchImageSection)
        ds?.collectionView?(collectionView, cancelPrefetchingForItemsAt: [indexPath])
    }
    
    @discardableResult
    func simulateCellNotVisible(at index: Int) -> LaunchDetailsImageCell? {
        let cell = simulateCellVisible(at: index)
        let delegate = collectionView.delegate
        let indexPath = IndexPath(row: index, section: launchImageSection)
        delegate?.collectionView?(collectionView, didEndDisplaying: cell, forItemAt: indexPath)
        
        return cell
    }
    
    private func getCell(at item: Int) -> UICollectionViewCell? {
        let ds = collectionView.dataSource
        let index = IndexPath(row: item, section: launchImageSection)
        return ds?.collectionView(collectionView, cellForItemAt: index)
    }
    
    private var launchImageSection: Int {
        return 0
    }
    
    func getInfoCell(at row: Int) -> LaunchDetailsInfoCell {
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: 0)
        
        return ds?.tableView(tableView, cellForRowAt: index) as! LaunchDetailsInfoCell
    }
}

extension LaunchDetailsImageCell {
    var renderedImage: Data? {
        imageView.image?.pngData()
    }
    
    var isShowingLoadingIndicator: Bool {
        imageContainer.isShimmering
    }
    
    var isShowingRetryButton: Bool {
        !retryButton.isHidden
    }
    
    func simulateRetryButtonTap() {
        retryButton.simulate(event: .touchUpInside)
    }
}

extension LaunchDetailsInfoCell {
    var name: String? {
        nameLabel.text
    }
    
    var launchDate: String? {
        launchDateLabel.text
    }
    
    var rocketName: String? {
        rocketNameLabel.text
    }
    
    var status: String? {
        statusLabel.text
    }
    
    var descriptionText: String? {
        descriptionLabel.text
    }
}
