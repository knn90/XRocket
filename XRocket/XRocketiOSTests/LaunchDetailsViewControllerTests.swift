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
    
    func test_viewLoad_renderingImageCell() {
        let url0 = URL(string: "http://url-0.com")!
        let url1 = URL(string: "http://url-1.com")!
        let url2 = URL(string: "http://url-2.com")!
        let url3 = URL(string: "http://url-3.com")!
        let urls = [url0, url1, url2, url3]
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        sut.display(urls)
        
        XCTAssertEqual(sut.numberOfRenderedCells, 4)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (LaunchDetailsViewController, LoaderSpy) {
        let loader = LoaderSpy()
        let sut = LaunchDetailsUIComposer.composeWith(imageLoader: loader)
        
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
    
    private var launchImageSection: Int {
        return 0
    }
}
