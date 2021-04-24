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
        let urls = [url0, url1, url2, url3]
        let (sut, _) = makeSUT(urls: urls)
        
        sut.loadViewIfNeeded()
        
        
        XCTAssertEqual(sut.numberOfRenderedCells, 4)
    }
    
    func test_loadView_requestsImageFromURL() {
        let url0 = URL(string: "http://url-0.com")!
        let url1 = URL(string: "http://url-1.com")!
        let url2 = URL(string: "http://url-2.com")!
        let urls = [url0, url1, url2]
        let (sut, loader) = makeSUT(urls: urls)
        
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
        let urls = [url0, url1]
        let (sut, loader) = makeSUT(urls: urls)
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
        let urls = [url0, url1]
        let (sut, loader) = makeSUT(urls: urls)
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
    
    // MARK: - Helpers
    private func makeSUT(urls: [URL] = [], file: StaticString = #file, line: UInt = #line) -> (LaunchDetailsViewController, LoaderSpy) {
        let loader = LoaderSpy()
        let sut = LaunchDetailsUIComposer.composeWith(imageLoader: loader, urls: urls)
        
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(loader, file: file, line: line)
        
        return (sut, loader)
    }
    
    private func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        let table = "LaunchDetails"
        let bundle = Bundle(for: LaunchPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}

extension LaunchDetailsViewController {
    var numberOfRenderedCells: Int {
        return collectionView.numberOfItems(inSection: launchImageSection)
    }
    
    func simulateCellVisible(at index: Int) -> LaunchDetailsImageCell {
        return getCell(at: index) as! LaunchDetailsImageCell
    }
    
    private func getCell(at item: Int) -> UICollectionViewCell? {
        let ds = collectionView.dataSource
        let index = IndexPath(row: item, section: launchImageSection)
        return ds?.collectionView(collectionView, cellForItemAt: index)
    }
    
    private var launchImageSection: Int {
        return 0
    }
}

extension LaunchDetailsImageCell {
    var renderedImage: Data? {
        imageView.image?.pngData()
    }
    
    var isShowingLoadingIndicator: Bool {
        imageContainer.isShimmering
    }
}
