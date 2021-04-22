//
//  LaunchViewControllerTests.swift
//  XRocketiOSTests
//
//  Created by Khoi Nguyen on 18/4/21.
//

import XCTest
import UIKit
import XRocket
import XRocketiOS

class LaunchViewControllerTests: XCTestCase {
    func test_loadView_hasCorrectTitle() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.title, localized("launch_view_title"))
    }
    
    func test_loadLaunchesAction_RequestLaunchFromLoader() {
        let (sut, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadLaunchCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadLaunchCallCount, 1, "Expected first requests after view is loaded")
        
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(loader.loadLaunchCallCount, 2, "Expected another requests when user initiated reload")
        
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(loader.loadLaunchCallCount, 3, "Expected yet another requests when user initiated another reload")
    }
    
    func test_loadingIndicator_isVisibleWhileLoadingLaunches() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator after view is loaded")
        
        loader.completeLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator after loading successfully")
        
        sut.simulateUserInitiatedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator when user initiated a reload")
        
        loader.completeLoading(with: anyNSError(), at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator after loading failed")
    }
    
    func test_loadCompletion_renderSuccessfullyLoadedLaunches() {
        let (sut, loader) = makeSUT()
        let launch0 = Launch(id: "", name: "name 1", flightNumber: 23, success: true, dateUTC: LaunchDateFactory.date1().date, links: Link(flickr: Flickr(original: [anyURL()])))
        let launch1 = Launch(id: "", name: "name 2", flightNumber: 23, success: false, dateUTC: LaunchDateFactory.date2().date, links: Link(flickr: Flickr(original: [anyURL()])))
        let launch2 = Launch(id: "", name: "name 3", flightNumber: 23, success: true, dateUTC: LaunchDateFactory.date3().date, links: Link(flickr: Flickr(original: [anyURL()])))
        let launch3 = Launch(id: "", name: "name 4", flightNumber: 23, success: true, dateUTC: LaunchDateFactory.date4().date, links: Link(flickr: Flickr(original: [anyURL()])))
        let launches = [launch0, launch1, launch2, launch3]
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.numberOfRenderedCell, 0)
        
        loader.completeLoading(with: LaunchPaginationFactory.single(with: launches), at: 0)
        assertThat(sut, isRendering: LaunchViewModel(launches: launches).presentableLaunches)
    }
    
    func test_loadCompletion_renderSuccessfullyEmptyAfterNonEmptyLaunches() {
        let (sut, loader) = makeSUT()
        let launch0 = Launch(id: "", name: "name 1", flightNumber: 23, success: true, dateUTC: LaunchDateFactory.date1().date, links: Link(flickr: Flickr(original: [anyURL()])))
        let launches = [launch0]
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.numberOfRenderedCell, 0)
        
        loader.completeLoading(with: LaunchPaginationFactory.single(with: launches), at: 0)
        assertThat(sut, isRendering: LaunchViewModel(launches: launches).presentableLaunches)
        
        sut.simulateUserInitiatedReload()
        loader.completeLoading(with: LaunchPaginationFactory.empty(), at: 1)
        assertThat(sut, isRendering: [])
    }
    
    func test_loadCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let (sut, loader) = makeSUT()
        let launch0 = Launch(id: "", name: "name 1", flightNumber: 23, success: true, dateUTC: LaunchDateFactory.date1().date, links: Link(flickr: Flickr(original: [anyURL()])))
        let launches = [launch0]
        let presentableLaunches = LaunchViewModel(launches: launches).presentableLaunches
        sut.loadViewIfNeeded()
        
        loader.completeLoading(with: LaunchPaginationFactory.single(with: launches), at: 0)
        assertThat(sut, isRendering: presentableLaunches)
        
        sut.simulateUserInitiatedReload()
        loader.completeLoading(with: anyNSError(), at: 1)
        assertThat(sut, isRendering: presentableLaunches)
    }
    
    func test_loadCompletion_rendersErrorMessageOnErrorUntilNextReload() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.errorMessage, nil)
        
        loader.completeLoading(with: anyNSError(), at: 0)
        XCTAssertEqual(sut.errorMessage, localized("launch_view_connection_error"))
        
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(sut.errorMessage, nil)
    }
    
    func test_launchCell_loadsImageWhenVisible() {
        let url0 = URL(string: "http:url-0.com")!
        let url1 = URL(string: "http:url-1.com")!
        let launch0 = LaunchFactory.any(urls: [url0])
        let launch1 = LaunchFactory.any(urls: [url1])
        
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeLoading(with: LaunchPaginationFactory.single(with: [launch0, launch1]), at: 0)
        XCTAssertEqual(loader.requestedImageURLs, [])
        
        sut.simulateLaunchCellVisible(at: 0)
        XCTAssertEqual(loader.requestedImageURLs, [url0])
        
        sut.simulateLaunchCellVisible(at: 1)
        XCTAssertEqual(loader.requestedImageURLs, [url0, url1])
    }
    
    func test_launchCellWithoutURL_doesNotLoadImage() {
        let launch0 = LaunchFactory.any()
        let launch1 = LaunchFactory.any()
        
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeLoading(with: LaunchPaginationFactory.single(with: [launch0, launch1]), at: 0)
        sut.simulateLaunchCellVisible(at: 0)
        sut.simulateLaunchCellVisible(at: 1)
        XCTAssertEqual(loader.requestedImageURLs, [])
    }
    
    func test_launchCell_cancelsImageLoadingWhenNotVisibleAnymore() {
        let url0 = URL(string: "http:url-0.com")!
        let url1 = URL(string: "http:url-1.com")!
        let launch0 = LaunchFactory.any(urls: [url0])
        let launch1 = LaunchFactory.any(urls: [url1])
        
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeLoading(with: LaunchPaginationFactory.single(with: [launch0, launch1]), at: 0)
        XCTAssertEqual(loader.requestedImageURLs, [])
        
        sut.simulateLaunchCellNotVisible(at: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [url0])
        
        sut.simulateLaunchCellNotVisible(at: 1)
        XCTAssertEqual(loader.cancelledImageURLs, [url0, url1])
    }
    
    func test_launchCellLoadingIndicator_isVisibleWhileLoadingImage() {
        let url0 = URL(string: "http:url-0.com")!
        let url1 = URL(string: "http:url-1.com")!
        let launch0 = LaunchFactory.any(urls: [url0])
        let launch1 = LaunchFactory.any(urls: [url1])
        
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        loader.completeLoading(with: LaunchPaginationFactory.single(with: [launch0, launch1]), at: 0)
        
        let cell0 = sut.simulateLaunchCellVisible(at: 0)
        let cell1 = sut.simulateLaunchCellVisible(at: 1)
        
        XCTAssertEqual(cell0?.isShowingImageLoadingIndicator, true)
        XCTAssertEqual(cell1?.isShowingImageLoadingIndicator, true)
        
        loader.completeImageLoading(at: 0)
        XCTAssertEqual(cell0?.isShowingImageLoadingIndicator, false)
        XCTAssertEqual(cell1?.isShowingImageLoadingIndicator, true)
        
        loader.completeImageLoading(at: 1)
        XCTAssertEqual(cell0?.isShowingImageLoadingIndicator, false)
        XCTAssertEqual(cell1?.isShowingImageLoadingIndicator, false)
    }
    
    func test_launchCell_rendersImageLoadedFromURL() {
        let url0 = URL(string: "http:url-0.com")!
        let url1 = URL(string: "http:url-1.com")!
        let launch0 = LaunchFactory.any(urls: [url0])
        let launch1 = LaunchFactory.any(urls: [url1])
        
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        loader.completeLoading(with: LaunchPaginationFactory.single(with: [launch0, launch1]), at: 0)
        
        let cell0 = sut.simulateLaunchCellVisible(at: 0)
        let cell1 = sut.simulateLaunchCellVisible(at: 1)
        
        XCTAssertEqual(cell0?.renderedImage, nil)
        XCTAssertEqual(cell1?.renderedImage, nil)
        
        let imageData0 = UIImage.make(withColor: .red).pngData()!
        loader.completeImageLoading(with: imageData0, at: 0)
        XCTAssertEqual(cell0?.renderedImage, imageData0)
        XCTAssertEqual(cell1?.renderedImage, nil)
        
        let imageData1 = UIImage.make(withColor: .blue).pngData()!
        loader.completeImageLoading(with: imageData1, at: 1)
        XCTAssertEqual(cell0?.renderedImage, imageData0)
        XCTAssertEqual(cell1?.renderedImage, imageData1)
        
    }
    
    func test_launchCell_stopsLoadingIndicatorOnLoadImageError() {
        let url0 = URL(string: "http:url-0.com")!
        let launch0 = LaunchFactory.any(urls: [url0])
        
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        loader.completeLoading(with: LaunchPaginationFactory.single(with: [launch0]), at: 0)
        
        let cell0 = sut.simulateLaunchCellVisible(at: 0)
        loader.completeImageLoading(with: anyNSError(), at: 0)
        
        XCTAssertEqual(cell0?.isShowingImageLoadingIndicator, false)
        XCTAssertEqual(cell0?.renderedImage, nil)
    }

    func test_feedImageView_preloadsImageWhenNearVisible() {
        let url0 = URL(string: "http:url-0.com")!
        let url1 = URL(string: "http:url-1.com")!
        let launch0 = LaunchFactory.any(urls: [url0])
        let launch1 = LaunchFactory.any(urls: [url1])
        
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        loader.completeLoading(with: LaunchPaginationFactory.single(with: [launch0, launch1]), at: 0)
        XCTAssertEqual(loader.requestedImageURLs, [])
        
        sut.simulateLauncCellIsNearVisible(at: 0)
        XCTAssertEqual(loader.requestedImageURLs, [url0])
        
        sut.simulateLauncCellIsNearVisible(at: 1)
        XCTAssertEqual(loader.requestedImageURLs, [url0, url1])
    }
    
    func test_feedImageView_cancelsImageLoadingWhenNotNearVisibleAnymore() {
        let url0 = URL(string: "http:url-0.com")!
        let url1 = URL(string: "http:url-1.com")!
        let launch0 = LaunchFactory.any(urls: [url0])
        let launch1 = LaunchFactory.any(urls: [url1])
        
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        loader.completeLoading(with: LaunchPaginationFactory.single(with: [launch0, launch1]), at: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [])
        
        sut.simulateLauncCellIsNotNearVisible(at: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [url0])
        
        sut.simulateLauncCellIsNotNearVisible(at: 1)
        XCTAssertEqual(loader.cancelledImageURLs, [url0, url1])
    }
    
    func test_launchCell_doesNotRenderLoadedImageWhenNotVisibleAnyMore() {
        let url0 = URL(string: "http:url-0.com")!
        let launch0 = LaunchFactory.any(urls: [url0])
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        loader.completeLoading(with: LaunchPaginationFactory.single(with: [launch0]), at: 0)
        
        let cell = sut.simulateLaunchCellNotVisible(at: 0)
        loader.completeImageLoading(with: UIImage.make(withColor: .red).pngData()!, at: 0)
        
        XCTAssertNil(cell?.renderedImage)
    }
    
    func test_loadCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeLoading(at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_loadImageCompletion_dispatchFromBackgroundToMainThread() {
        let url0 = URL(string: "http:url-0.com")!
        let launch0 = LaunchFactory.any(urls: [url0])
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        loader.completeLoading(with: LaunchPaginationFactory.single(with: [launch0]), at: 0)
        _ = sut.simulateLaunchCellVisible(at: 0)
        
        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeImageLoading(with: UIImage.make(withColor: .blue).pngData()!, at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (LaunchViewController, LoaderSpy) {
        let loader = LoaderSpy()        
        let sut = LaunchUIComposer.composeWith(loader: loader, imageLoader: loader)
        
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(loader, file: file, line: line)
        
        return (sut, loader)
    }
    
    private class LoaderSpy: LaunchLoader, ImageDataLoader {
        private(set) var loadLaunchCallCount = 0
        private(set) var completions = [(LaunchLoader.Result) -> Void]()
        
        func load(completion: @escaping (Result<LaunchPagination, Error>) -> Void) {
            loadLaunchCallCount += 1
            completions.append(completion)
        }
        
        func completeLoading(with launchPagination: LaunchPagination = LaunchPaginationFactory.empty(), at index: Int) {
            completions[index](.success(launchPagination))
        }
        
        func completeLoading(with error: Error, at index: Int) {
            completions[index](.failure(error))
        }
        
        // Image Loader
        private(set) var requestedImageURLs = [URL]()
        private(set) var cancelledImageURLs = [URL]()
        private(set) var imageCompletions = [(ImageDataLoader.Result) -> Void]()
        private struct TaskSpy: ImageDataLoaderTask {
            let cancelCallback: () -> Void
            func cancel() {
                cancelCallback()
            }
        }
        func load(from request: URLRequest, completion: @escaping (ImageDataLoader.Result) -> Void) -> ImageDataLoaderTask {
            requestedImageURLs.append(request.url!)
            imageCompletions.append(completion)
            return TaskSpy { [weak self] in
                self?.cancelledImageURLs.append(request.url!)
            }
        }
        
        func completeImageLoading(with data: Data = Data(), at index: Int) {
            imageCompletions[index](.success(data))
        }
        
        func completeImageLoading(with error: Error, at index: Int) {
            imageCompletions[index](.failure(error))
        }
    }
    
    private func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        let table = "Launch"
        let bundle = Bundle(for: LaunchPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
    
    private func assertThat(_ sut: LaunchViewController, isRendering launches: [PresentableLaunch], file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(sut.numberOfRenderedCell, launches.count, file: file, line: line)
        
        launches.enumerated().forEach { index, launch in
            assertThat(sut, hasCellConfiguredFor: launch, at: index, file: file, line: line)
        }
    }
    
    private func assertThat(_ sut: LaunchViewController, hasCellConfiguredFor launch: PresentableLaunch, at index: Int, file: StaticString = #filePath, line: UInt = #line) {
        guard let  cell = sut.getCell(at: index) as? LaunchCell else {
            return XCTFail("Can't parse cell as LaunchCell", file: file, line: line)
        }
        XCTAssertEqual(cell.flightNumberLabel.text, launch.flightNumber)
        XCTAssertEqual(cell.rocketNameLabel.text, launch.name)
        XCTAssertEqual(cell.dateLabel.text, launch.launchDate)
        XCTAssertEqual(cell.statusLabel.text, launch.status)
    }
}

extension UIRefreshControl {
    func simulatePullToRefresh() {
        simulate(event: .valueChanged)
    }
}

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}

private extension UIImage {
    static func make(withColor color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

extension LaunchViewController {
    func simulateUserInitiatedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    @discardableResult
    func simulateLaunchCellVisible(at row: Int) -> LaunchCell? {
        return getCell(at: row) as? LaunchCell
    }
    
    @discardableResult
    func simulateLaunchCellNotVisible(at row: Int) -> LaunchCell? {
        let cell = simulateLaunchCellVisible(at: row)!
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: launchSection)
        delegate?.tableView?(tableView, didEndDisplaying: cell, forRowAt: index)
        
        return cell
    }
    
    func simulateLauncCellIsNearVisible(at row: Int) {
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: launchSection)
        ds?.tableView(tableView, prefetchRowsAt: [index])
    }
    
    func simulateLauncCellIsNotNearVisible(at row: Int) {
        simulateLauncCellIsNearVisible(at: row)
        
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: launchSection)
        ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
    }
    
    func getCell(at row: Int) -> UITableViewCell? {
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: launchSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
    
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
    
    var numberOfRenderedCell: Int {
        return tableView.numberOfRows(inSection: launchSection)
    }
    
    var errorMessage: String? {
        return errorView?.message
    }
    
    private var launchSection: Int {
        return 0
    }
}

extension LaunchCell {
    var isShowingImageLoadingIndicator: Bool {
        return imageContainer.isShimmering
    }
    
    var renderedImage: Data? {
        return rocketImageView.image?.pngData()
    }
}

class LaunchDateFactory {
    static func date1() -> (date: Date, string: String) {
        return (Date(timeIntervalSince1970: 1614846240), "2021-03-04")
    }
    
    static func date2() -> (date: Date, string: String) {
        return (Date(timeIntervalSince1970: 1612419540), "2021-02-04")
    }
    
    static func date3() -> (date: Date, string: String) {
        return (Date(timeIntervalSince1970: 1611500400), "2021-01-24")
    }
    
    static func date4() -> (date: Date, string: String) {
        return (Date(timeIntervalSince1970: 1610072100), "2021-01-08")
    }
}
