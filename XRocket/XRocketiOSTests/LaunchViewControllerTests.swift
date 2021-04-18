//
//  LaunchViewControllerTests.swift
//  XRocketiOSTests
//
//  Created by Khoi Nguyen on 18/4/21.
//

import XCTest
import XRocket
import UIKit

class LaunchViewController: UIViewController {
    
    private let loader: LaunchLoader
    
    init(loader: LaunchLoader) {
        self.loader = loader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = LaunchPresenter.title
        loader.load { _ in }
    }
}

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
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (LaunchViewController, LoaderSpy) {
        let loader = LoaderSpy()
        let sut = LaunchViewController(loader: loader)
        
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(loader, file: file, line: line)
        
        return (sut, loader)
    }
    
    private class LoaderSpy: LaunchLoader {
        private(set) var loadLaunchCallCount = 0
        
        func load(completion: @escaping (Result<LaunchPagination, Error>) -> Void) {
            loadLaunchCallCount += 1
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
}
