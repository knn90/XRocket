//
//  LaunchPresenterTests.swift
//  XRocketTests
//
//  Created by Khoi Nguyen on 18/4/21.
//

import XCTest
import XRocket

class LaunchPresenterTests: XCTestCase {
    func test_title_shouldLocalized() {
        XCTAssertEqual(LaunchPresenter.title, localized("launch_view_title"))
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> LaunchPresenter {
        let sut = LaunchPresenter()
        trackForMemoryLeak(sut)
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
