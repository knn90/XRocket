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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = LaunchPresenter.title
    }
}

class LaunchViewControllerTests: XCTestCase {
    func test_loadView_hasCorrectTitle() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.title, localized("launch_view_title"))
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> LaunchViewController {
        let sut = LaunchViewController()
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
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
